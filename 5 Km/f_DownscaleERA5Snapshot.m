%This function downscales ERA data with MODIS Ta and Td
%list1 = ["Ta","Td","Rs"]
function f_DownscaleERASnapshot(year,month,opt1,opt2)
	year= double(year);
	month= double(month) ;
	
%     year = 2020
%     month = 9
%     opt1 = 'Ta'
%     opt2 = 'MOD'
				
	% Prepare
	MSK = importdata('/bess19/Yulin/BESSv2/Ancillary/Landmask.005d.mat');
	DATA = nan(size(MSK),'single');
	snapshots = nan(720,1440,25,'single');
	snapshot = nan(720,1440,'single'); 
	path = '/bess19/Yulin/BESSv2/ERA';
	r = 0.25;
	l = r / 0.05;
	if strcmp(opt1,'Ta')
		var = 't2m';
	elseif strcmp(opt1,'Td')
		var = 'd2m';
	elseif strcmp(opt1,'Rs')
		var = 'ssrd';
	end
	if strcmp(opt2,'MOD')
		time = 'AM';
	elseif strcmp(opt2,'MYD')
		time = 'PM';
	end
	 
	% Overpass time (local time)
	DATA(MSK) = importdata(sprintf('/bess19/Yulin/BESSv2/Ancillary/Overpass%s.005d.mat',opt2));
	overpass = f_Aggregate(DATA,l);
	 
	% Overpass time (UTC)
	[LON,~] = meshgrid(-180+r/2:r:180-r/2,90-r/2:-r:-90+r/2);
	UTC = overpass - LON/15; 
	UTC(UTC>=24) = UTC(UTC>=24) - 24;
	UTC(UTC<0) = UTC(UTC<0) + 24;

	% Calculate slope for linear interpolation
	scale = UTC / 3 + 1;
	alf = scale - floor(scale);

	% 
	try
		if strcmp(opt1,'Rs') 
			temp_ = importdata(sprintf('/bess19/Yulin/BESSv2/Rg_%s_Monthly/Rg_%s_Monthly.%d.%02d.mat',opt2,opt2,year,month));
		else
			temp_ = importdata(sprintf('/bess19/Yulin/BESSv2/%s_%s_Monthly/%s_%s_Monthly.%d.%02d.mat',opt1,opt2,opt1,opt2,year,month));
		end
	catch
		temp_ = importdata(sprintf('/bess19/Yulin/BESSv2/%s_Clim/%s_Clim.%02d.mat',opt1,opt1,month));    
	end

	% Process day by day    
	for day = 1:31
		% Current day
		vec = datevec(datenum(year,month,day));
		if vec(2) == month
			doy = datenum(year,month,day) - datenum(year,1,1) + 1;
			% Next day
			vec_ = datevec(datenum(year,1,doy+1)); 
			year_ = vec_(1);
			month_ = vec_(2);
			day_ = vec_(3);
			% Read reanalysis data (0:00 ~ 24:00)
			snapshots(:) = nan;
			
			sprintf('%s/%d.%02d/%s.%d.%02d.%02d.mat',path,year,month,var,year,month,day);
			sprintf('%s/%d.%02d/%s.%d.%02d.%02d.mat',path,year_,month_,var,year_,month_,day_);
			            
			raw = importdata(sprintf('%s/%d.%02d/%s.%d.%02d.%02d.mat',path,year,month,var,year,month,day));
			sprintf('%s/%d.%02d/%s.%d.%02d.%02d.mat',path,year_,month_,var,year_,month_,day_)
			raw_ = importdata(sprintf('%s/%d.%02d/%s.%d.%02d.%02d.mat',path,year_,month_,var,year_,month_,day_));
			for i = 1:24
				snapshots(:,:,i) = imresize(squeeze(raw(i,:,:)),[720,1440]);
			end
			snapshots(:,:,25) = imresize(squeeze(raw_(1,:,:)),[720,1440]);
			% 
			snapshots = cat(2,snapshots(:,721:end,:),snapshots(:,1:720,:));
			% Temporally interpolate to MODIS overpass time
			for i = 1:24 
				msk = floor(scale) == i;
				snapshot0 = snapshots(:,:,i);
				snapshot_ = snapshots(:,:,i+1);
				snapshot(msk) = snapshot0(msk) + alf(msk).*(snapshot_(msk)-snapshot0(msk));
			end
			if strcmp(opt1,'Rs')
				% J m-2-> W m-2
				snapshot = snapshot / 3600 / 1; 
			end

			% Read MODIS data
			try
				if strcmp(opt1,'Rs')
					temp = importdata(sprintf('/bess19/Yulin/BESSv2/Rg_%s/Rg_%s.%d.%03d.mat',opt2,opt2,year,doy));
				else
					temp = importdata(sprintf('/bess19/Yulin/BESSv2/%s_%s/%s_%s.%d.%03d.mat',opt1,opt2,opt1,opt2,year,doy));
				end
				msk = isnan(temp);
				temp(msk) = temp_(msk);
			catch
				temp = temp_;
			end              

			% Aggregate to reanalysis resolution
			DATA(MSK) = temp;
			aggregate = f_Aggregate(DATA,l);
			c = snapshot ./ aggregate;
			upper = prctile(c(:),99);
			lower = prctile(c(:),1);
			c(c>upper) = upper;
			c(c<lower) = lower;
			C = imresize(c,size(DATA),'nearest');
			C = ndnanfilter(C,'hamming',[l,l]); 
			data = DATA(MSK) .* C(MSK); 
			% Fill gaps
			data_ = imresize(snapshot,size(DATA),'nearest');
			data_ = ndnanfilter(data_,'hamming',[l,l]); 
			data_ = data_(MSK);
			msk = isnan(data);
			data(msk) = data_(msk);
			% Write
			mkdir(sprintf('/bess19/Yulin/BESSv2/%s_%s',opt1,time));	
			save(sprintf('/bess19/Yulin/BESSv2/%s_%s/%s_%s.%d.%03d.mat',opt1,time,opt1,time,year,doy),'data');
		end 
	end 
