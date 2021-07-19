function f_Calibrate(ds,year,month)
	
	year= double(year);
	month= double(month) ;
	
	if strcmp(ds,'Rs_Daily')
		ds0 = 'PAR_Daily';
		load('/bess/JCY/BESSv2/0Calibration/PAR_ERA_FLiES.mat')
	end

		for day = 1:31
			vec = datevec(datenum(year,month,day));
			if vec(2) == month
				doy = datenum(year,month,day) - datenum(year,1,1) + 1;
				try
					raw = importdata(sprintf('/bess19/Yulin/BESSv2/%s/%s.%d.%03d.mat',ds,ds,year,doy));
					data = raw .* slope + intercept;
					save(sprintf('/bess19/Yulin/BESSv2/%s/%s.%d.%03d.mat',ds0,ds0,year,doy),'data');
				end 
			end
		end
	