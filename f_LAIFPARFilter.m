function f_LAIFPARFilter(ds,year,month,opt)  
    
	year= double(year);
	month= double(month) ;
	% Prepare
	if strfind(ds,'MCD')
		ds0 = strrep(ds,'MCD','MCD_Filter');
		ds_ = strrep(ds,'MCD','MOD');
		t = 4;
	else
		ds0 = strrep(ds,'MOD','MOD_Filter');
		ds_ = strrep(ds,'MOD','MCD');
		t = 8;
	end 

	% Define rolling window 
	win = -16:t:16;
	n = length(win); 
	if opt == 0
		series = nan(8774037,n,'single');
	elseif opt == 1
		series = nan(311724940,n,'single');
	end
	   
	% Process day by day
	for day = 1:31 
		vec = datevec(datenum(year,month,day));
		if vec(2) == month
			doy = datenum(year,month,day) - datenum(year,1,1) + 1;
			
			% LAI/FPAR day
			if mod(doy,t) == 1
			 
				% Read all data within the rolling window
				series(:) = nan;
				for i = 1:n
					vec_ = datevec(datenum(year,1,doy+win(i)));
					year_ = vec_(1);
					month_ = vec_(2);
					day_ = vec_(3);
					doy_ = datenum(year_,month_,day_) - datenum(year_,1,1) + 1;   
					doy_ = ceil(doy_/t-1)*t+1;
					try
						try
							sprintf('/bess19/Yulin/BESSv2/%s/%s.%d.%03d.mat',ds,ds,year_,doy_)
							series(:,i) = importdata(sprintf('/bess19/Yulin/BESSv2/%s/%s.%d.%03d.mat',ds,ds,year_,doy_));
						catch    
							sprintf('/bess19/Yulin/BESSv2/%s/%s.%d.%03d.mat',ds_,ds_,year_,doy_)
							series(:,i) = importdata(sprintf('/bess19/Yulin/BESSv2/%s/%s.%d.%03d.mat',ds_,ds_,year_,doy_));
						end
					end
				end
				 
				if t == 4
					% Get mean values before current day
					left = nanmean(series(:,1:4),2);
					% Get mean values after current day
					right = nanmean(series(:,6:9),2);
					% Get values of current day
					data = series(:,5);
				elseif t == 8
					% Get mean values before current day
					left = nanmean(series(:,1:2),2);
					% Get mean values after current day
					right = nanmean(series(:,4:5),2);
					% Get values of current day
					data = series(:,3);
				end
					  
				% Filter rule
				msk = (left>data & right>data) | isnan(data);
				% Filter
				avg = nanmean(cat(2,left,right),2);
				data(msk) = avg(msk);
				% Write filtered results  
				mkdir(sprintf('/bess19/Yulin/BESSv2/%s/',ds0))
				save(sprintf('/bess19/Yulin/BESSv2/%s/%s.%d.%03d.mat',ds0,ds0,year,doy),'data');
			end    
		end
	end
