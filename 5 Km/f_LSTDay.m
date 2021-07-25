function f_LSTDay(year,month,opt1,opt2) 
	
	year= double(year);
	month= double(month) ;
	% Prepare
	if strcmp(opt2,'MOD')
		time = 'AM';
	elseif strcmp(opt2,'MYD')
		time = 'PM';
	end
	path = '/bess19/Yulin/BESSv2/NOAH21';
	var = 'AvgSurfT_inst';    
	MSK = importdata('/bess19/Yulin/BESSv2/Ancillary/Landmask.005d.mat');
	snapshots = nan(720,1440,9,'single');
	r = 0.5;
	l = r / 0.05;
	try
		IGBP = importdata(sprintf('/bess/JCY/BESSv2/IGBP^/IGBP^.%d.mat',year));
	catch
		try
			IGBP = importdata(sprintf('/bess/JCY/BESSv2/IGBP^/IGBP^.%d.mat',year-3));
		catch    
			IGBP = importdata(sprintf('/bess/JCY/BESSv2/IGBP^/IGBP^.%d.mat',year-6)); %noted that we only have the IGBP maps for 1992-2015
		end    
	end

	% Overpass time (local time)
	msk = importdata('/bess19/Yulin/BESSv2/Ancillary/Landmask.005d.mat');
	DATA = nan(size(msk),'single');
	DATA(msk) = importdata(sprintf('/bess19/Yulin/BESSv2/Ancillary/Overpass%s.005d.mat',opt2));
	overpass = f_Aggregate(DATA,l);

	% Overpass time (UTC)
	[LON,~] = meshgrid(-180+r/2:r:180-r/2,90-r/2:-r:-90+r/2);
	UTC = overpass - LON/15; 
	UTC(UTC>=24) = UTC(UTC>=24) - 24;
	UTC(UTC<0) = UTC(UTC<0) + 24;

	% Calculate slope for linear interpolation
	scale = UTC / 3 + 1;
	alf = scale - floor(scale);

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
			 
			% Read MOD/MYD data
			try
				data = importdata(sprintf('/bess19/Yulin/BESSv2/LST_%s^/LST_%s^.%d.%03d.mat',opt2,opt2,year,doy));
			catch
				data = nan(size(MSK(MSK)),'single');
			end
			
			% Read reanalysis data (0:00 ~ 24:00)
			snapshots(:) = nan;
			sprintf('%s/%d.%02d/%s.%d.%02d.%02d.mat',path,year,month,var,year,month,day)
			raw = importdata(sprintf('%s/%d.%02d/%s.%d.%02d.%02d.mat',path,year,month,var,year,month,day));
			raw_ = importdata(sprintf('%s/%d.%02d/%s.%d.%02d.%02d.mat',path,year_,month_,var,year_,month_,day_));
			for i = 1:8
				snapshots(1:600,:,i) = squeeze(raw(i,:,:));
			end
			snapshots(1:600,:,9) = squeeze(raw_(1,:,:));
			% Calculate maximum LST
			temp = nanmax(snapshots,[],3);
			% Temporally interpolate to MODIS overpass time
			for i = 1:8 
				msk = floor(scale) == i;
				snapshot0 = snapshots(:,:,i);
				snapshot_ = snapshots(:,:,i+1);
				temp(msk) = snapshot0(msk) + alf(msk).*(snapshot_(msk)-snapshot0(msk));
			end
			% Fill gaps using nearest neighbour sampling
			msk = isnan(temp);
			[~,ind] = bwdist(~msk);
			temp(msk) = temp(ind(msk));
			temp(601:end,:) = nan; 
			% Interpolate to MODIS resolution
			temp = imresize(temp,size(MSK),'nearest');
			temp = ndnanfilter(temp,'hamming',[l,l]); 
			temp = temp(MSK);
			
			% Fill gaps in MODIS data
			coef = nan(14,1);
			mi = nan(14,1);
			ma = nan(14,1);
			msk0 = isfinite(data) & isfinite(temp); 
			if sum(msk0) > 0
				mi0 = min(data(msk0));
				ma0 = max(data(msk0));
				x = temp(msk0);
				y = data(msk0);
				coef0 = median(y) / median(x); 
				mi(:) = mi0;
				ma(:) = ma0; 
				coef(:) = coef0;  
				for i = 1:14
					mski = IGBP==i-1;
					msk = msk0 & mski;
					if sum(msk) > 2 
						mi(i) = min(data(msk));
						ma(i) = max(data(msk));
						x = temp(msk); 
						y = data(msk); 
						coef(i) = median(y) / median(x);
					end    
				end
				msk0 = isnan(data);
				for i = 1:14
					mski = IGBP==i-1;
					msk = msk0 & mski;
					yy = coef(i) * temp(msk);
					yy(yy<mi(i)) = mi(i);
					yy(yy>ma(i)) = ma(i);
					data(msk) = yy;
				end
			else
				data = temp;
			end 
			mkdir(sprintf('/bess19/Yulin/BESSv2/LST_%s^/',time))
			save(sprintf('/bess19/Yulin/BESSv2/LST_%s^/LST_%s^.%d.%03d.mat',time,time,year,doy),'data');
		end
	end
	 

            
 
    % % Prepare
    % MSK = importdata('../Ancillary/Landmask.005d.mat');
    % DATA = nan(size(MSK),'single');
    % snapshots = nan(720,1440,9,'single');
    % snapshot = nan(720,1440,'single'); 
    % path = '../NOAH21';
    % var = 'AvgSurfT_inst';
    % r = 0.25;
    % l = r / 0.05;
    % if strcmp(opt2,'MOD')
        % time = 'AM';
    % elseif strcmp(opt2,'MYD')
        % time = 'PM';
    % end
    
    % % Process day by day    
    % for day = 1:31
        % % Current day
        % vec = datevec(datenum(year,month,day));
        % if vec(2) == month
            % doy = datenum(year,month,day) - datenum(year,1,1) + 1;
            % % Next day
            % vec_ = datevec(datenum(year,1,doy+1)); 
            % year_ = vec_(1);
            % month_ = vec_(2);
            % day_ = vec_(3);
            % % Read reanalysis data (0:00 ~ 24:00)
            % snapshots(:) = nan;
            % raw = importdata(sprintf('%s/%d.%02d/%s.%d.%02d.%02d.mat',path,year,month,var,year,month,day));
            % raw_ = importdata(sprintf('%s/%d.%02d/%s.%d.%02d.%02d.mat',path,year_,month_,var,year_,month_,day_));
            % for i = 1:8
                % snapshots(1:600,:,i) = squeeze(raw(i,:,:));
            % end
            % snapshots(1:600,:,9) = squeeze(raw_(1,:,:));
            % % Temporally interpolate to MODIS overpass time
            % for i = 1:8 
                % msk = floor(scale) == i;
                % snapshot0 = snapshots(:,:,i);
                % snapshot_ = snapshots(:,:,i+1);
                % snapshot(msk) = snapshot0(msk) + alf(msk).*(snapshot_(msk)-snapshot0(msk));
            % end
            % % Fill gaps using nearest neighbour sampling
            % msk = isnan(snapshot);
            % [~,ind] = bwdist(~msk);
            % snapshot(msk) = snapshot(ind(msk));
            % snapshot(601:end,:) = nan;
            % % 
            % temp = snapshot;
            % % Spatially interpolate to MODIS resolution
            % data = imresize(temp,size(MSK),'nearest');
            % data = ndnanfilter(data,'hamming',[l,l]); 
            % data = data(MSK);
            % try 
                % % Read MODIS data
                % DATA(MSK) = importdata(sprintf('../LST_%s^/LST_%s^.%d.%03d.mat',opt2,opt2,year,doy));
                % % Aggregate to reanalysis resolution
                % TEMP = f_Aggregate(DATA,l);
                % c = temp ./ TEMP; 
                % upper = prctile(c(:),99);
                % lower = prctile(c(:),1);
                % c(c>upper) = upper;
                % c(c<lower) = lower;
                % C = imresize(c,size(DATA),'nearest');
                % C = ndnanfilter(C,'hamming',[l,l]); 
                % raw = DATA .* C;
                % % Fill Antarctica using interpolation
                % Antarctica = double(TEMP(601:end,:));
                % [col,row] = meshgrid(1:size(Antarctica,2),1:size(Antarctica,1));
                % msk = isfinite(Antarctica);
                % Antarctica = griddata(col(msk),row(msk),Antarctica(msk),col,row);
                % raw(3001:end,:) = imresize(Antarctica,l);
                % raw = raw(MSK);                  
                % % Fill with MODIS data
                % msk = isfinite(raw);
                % data(msk) = raw(msk);
            % end
            % % Write gap-filled data 
            % save(sprintf('../LST_%s^/LST_%s^.%d.%03d.mat',time,time,year,doy),'data');
        % end
    % end 
  