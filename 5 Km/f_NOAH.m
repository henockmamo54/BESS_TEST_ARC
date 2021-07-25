function f_NOAH(year,month,opt)
	%year =2018;
	
	year = double(year)
	month = double(month)
	
	opt =21;
    vars = {'SoilMoi0_10cm_inst','AvgSurfT_inst'};  
    pathIn = sprintf('/bess19/Yulin/Data/NOAH3H%d',opt);
	for month =1:12
	
		pathOut = sprintf('/bess19/Yulin/BESSv2/NOAH%d/%d.%02d',opt,year,month);
		if ~exist(pathOut)
			mkdir(pathOut)
		end
		 
		for day = 1:31
			vec = datevec(datenum(year,month,day));
			if vec(2) == month
				doy = datenum(year,month,day) - datenum(year,1,1) + 1;
				for i = 1:length(vars)
					data = nan(8,600,1440,'single');
					for j = 1:8
						hour = (j-1) * 3;
						try
							raw = flipud(ncread(sprintf('%s/%d/%03d/GLDAS_NOAH025_3H.A%d%02d%02d.%02d00.0%d.nc4',pathIn,year,doy,vec(1),vec(2),vec(3),hour,opt),vars{i})');
							data(j,:,:) = raw;
						end
					end
					mkdir(sprintf('%s/',pathOut))
					save(sprintf('%s/%s.%d.%02d.%02d.mat',pathOut,vars{i},year,month,day),'data');
				end
			end
		end
	end	