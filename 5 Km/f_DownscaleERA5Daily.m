%this funcion downscale ERA5 surface shortwave radiation,Ta,Td with WorldClim data
function f_DownscaleERADaily(year,month,opt)

	year= double(year);
	month= double(month) ;
    
	if strcmp(opt,'Rs')
		ds0 = 'ssrd';
	elseif strcmp(opt,'Ta')
		ds0 = 't2m';
	elseif strcmp(opt,'Td')
		ds0 = 'd2m';
	end
	MSK = importdata('/bess19/Yulin/BESSv2/Ancillary/Landmask.005d.mat');
	DATA = nan(size(MSK),'single'); 
	DATA(MSK) = importdata(sprintf('/bess19/Yulin/BESSv2/%s_Clim/%s_Clim.%02d.mat',opt,opt,month));
	l = 0.25 / 0.05; %resolution
	r = floor(l/2);
	proxy = f_Aggregate(DATA,l);
	for day = 1:31 		
		vec = datevec(datenum(year,month,day));
		if vec(2) == month
			doy = datenum(year,month,day) - datenum(year,1,1) + 1;
			raw = importdata(sprintf('/bess19/Yulin/BESSv2/ERA/%d.%02d/%s.%d.%02d.%02d.mat',year,month,ds0,year,month,day));
			coarse = squeeze(nanmean(raw,1));
			coarse = imresize(coarse,[720,1440]); %number of grids of ERA5 globally
			coarse = [coarse(:,721:end),coarse(:,1:720)];
			ma = nanmax(coarse(:));
			mi = nanmin(coarse(:));
			c = coarse ./ proxy; 
			c(isinf(c)) = nan;
			c(c==0) = nan;
			upper = prctile(c(:),99);
			lower = prctile(c(:),1);
			c(c>upper) = upper;
			c(c<lower) = lower;
			c(isnan(c)) = 1;
			C = imresize(c,size(DATA),'nearest');
			C = ndnanfilter(C,'hamming',[r,r]); 
			data = DATA(MSK) .* C(MSK); 
			data(data>ma) = ma;
			data(data<mi) = mi;
			if strcmp(ds0,'ssrd')
				data = data* 24*1e-6;   %ssrd data were based on hourly interval (J m-2 h-1), so *24 yields per day (J m-2 d-1), and further *1e-6 leads to MJ m-2 d-1.
			end
			mkdir(sprintf('/bess19/Yulin/BESSv2/%s_Daily', opt));
			save(sprintf('/bess19/Yulin/BESSv2/%s_Daily/%s_Daily.%d.%03d.mat',opt,opt,year,doy),'data');
		end
	end  
 
	