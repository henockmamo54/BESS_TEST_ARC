function f_LAIFPARDaily(ds,year,month,opt)  
    
	year= double(year);
	month= double(month) ;
    
	% Prepare
	if strfind(ds,'MOD') & strfind(ds,'LAI') & opt == 0
		coef = importdata(sprintf('/bess/JCY/BESSv2/0Calibration/LAI/LAI_MOD^_MCD^.%02d.mat',month));
	elseif strfind(ds,'MOD') & strfind(ds,'FPAR') & opt == 0
		coef = importdata(sprintf('/bess/JCY/BESSv2/0Calibration/FPAR/FPAR_MOD^_MCD^.%02d.mat',month));
	elseif strfind(ds,'MOD') & strfind(ds,'LAI') & opt == 1
		coef = importdata(sprintf('/bess/JCY/BESSv2/0Calibration/LAI/LAI_MOD_MCD.%02d.mat',month));
	elseif strfind(ds,'MOD') & strfind(ds,'FPAR') & opt == 1
		coef = importdata(sprintf('/bess/JCY/BESSv2/0Calibration/FPAR/FPAR_MOD_MCD.%02d.mat',month));
	end    
	if strfind(ds,'MCD')
		ds0 = strrep(ds,'MCD_Filter','Daily');
		t = 4;
	else
		ds0 = strrep(ds,'MOD_Filter','Daily');
		t = 8;
	end
	win = -8:t:8;
	n = length(win);
	sigma = t;

	% Generate background data
	
	if strfind(ds,'FPAR')
		sprintf('/bess19/blli/bess/%s_Climatology/%s_Climatology.%02d.mat',ds,ds,month)
		climatology = importdata(sprintf('/bess19/blli/bess/%s_Climatology/%s_Climatology.%02d.mat',ds,ds,month));
	else 
		climatology = importdata(sprintf('/bess/JCY/BESSv2/%s_Climatology/%s_Climatology.%02d.mat',ds,ds,month));
		sprintf('/bess/JCY/BESSv2/%s_Climatology/%s_Climatology.%02d.mat',ds,ds,month)
	end
	monthly = importdata(sprintf('/bess19/Yulin/BESSv2/%s_Monthly/%s_Monthly.%d.%02d.mat',ds,ds,year,month));
	msk = isnan(monthly); 
	monthly(msk) = climatology(msk);

	% Generate constraint information
	monthly0 = importdata(sprintf('/bess19/Yulin/BESSv2/%s_Monthly0/%s_Monthly0.%d.%02d.mat',ds,ds,year,month));
	upper = monthly + 2*monthly0;
	lower = monthly - 2*monthly0;
	  
	% 0.05 degree
	if opt == 0
		series = nan(8774037,n,'single');
		weight = nan(8774037,n,'single');
		sum = zeros(8774037,1,'single');
		cnt = zeros(8774037,1,'single');
	% 30 second    
	else
		series = nan(311724940,n,'single');
		weight = nan(311724940,n,'single');
		sum = zeros(311724940,1,'single');
		cnt = zeros(311724940,1,'single');
	end 
	for day = 1:31
		vec = datevec(datenum(year,month,day));
		if vec(2) == month
			doy = datenum(year,month,day) - datenum(year,1,1) + 1;
			
			% Read all data within the rolling window
			series(:) = nan;
			for i = 1:n
				vec_ = datevec(datenum(year,1,doy+win(i)));
				year_ = vec_(1);
				month_ = vec_(2);
				day_ = vec_(3);
				doy_ = datenum(year_,month_,day_) - datenum(year_,1,1) + 1;
				doy0_ = ceil(doy_/t-1)*t + 1;
				x = datenum(year,1,doy) - datenum(year_,1,doy0_) - t/2;
				fx = 1/(sigma*sqrt(2*pi)) * exp(-x^2/(2*sigma^2));
				try
					temp = importdata(sprintf('/bess19/Yulin/BESSv2/%s/%s.%d.%03d.mat',ds,ds,year_,doy0_));
					% Remove outliers 
					temp(temp>upper) = nan;
					temp(temp<lower) = nan;
					series(:,i) = temp;
					weight(:,i) = fx * single(isfinite(temp));
				end
			end
			% Apply Gaussian filter
			norm = nansum(weight,2);
			for i = 1:n
				w = weight(:,i) ./ norm;
				series(:,i) = series(:,i) .* w;
			end 
			data = nansum(series,2);
			data(data==0) = nan; 
			% Fill gaps 
			msk = isnan(data);
			data(msk) = monthly(msk);
			% MOD ~ MCD
			if strfind(ds,'MOD')
				data = coef .* data;
			end 
			% Write results
			mkdir(sprintf('/bess19/Yulin/BESSv2/%s/',ds0))
			save(sprintf('/bess19/Yulin/BESSv2/%s/%s.%d.%03d.mat',ds0,ds0,year,doy),'data'); 
		end
	end
