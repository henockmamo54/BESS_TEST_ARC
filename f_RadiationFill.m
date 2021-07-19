% This fuction is the last step of preparing the radiation climate forcing  List = ["NIRDiff_AM", "NIRDiff_PM","NIRDir_AM","NIRDir_PM","PARDiff_AM","PARDiff_PM","PARDir_AM","PARDir_PM","Rg_AM","Rg_PM","UV_AM","UV_PM"]
function f_RadiationFill(ds,year,month)
	
	year= double(year);
	month= double(month) ;
	
	disp(ds);

	disp(month);

	if strfind(ds,'AM')
		x = strrep(ds,'AM','ERA_AM');
		y = strrep(ds,'AM','MOD');
	elseif strfind(ds,'PM')
		x = strrep(ds,'PM','ERA_PM');
		y = strrep(ds,'PM','MYD');
	end 
		coef = importdata(sprintf('/bess/JCY/BESSv2/0Calibration/%s_ERA_FLiES/%s_ERA_FLiES.%02d.mat',ds,ds,month));
	for day = 1:31
		vec = datevec(datenum(year,month,day));
		if vec(2) == month
			doy = datenum(year,month,day) - datenum(year,1,1) + 1;   
			data = importdata(sprintf('/bess19/Yulin/BESSv2/%s/%s.%d.%03d.mat',x,x,year,doy));
			% data = slope .* data + intercept;
			data = coef .* data;
			upper = prctile(data,99);
			data(data>upper) = upper;            
			try 
				raw = importdata(sprintf('/bess19/Yulin/BESSv2/%s/%s.%d.%03d.mat',y,y,year,doy));
				msk = isfinite(raw);
				data(msk) = raw(msk);
			end
			data(data<0|isnan(data)) = 0; 
			mkdir(sprintf('/bess19/Yulin/BESSv2/%s/',ds));
			save(sprintf('/bess19/Yulin/BESSv2/%s/%s.%d.%03d.mat',ds,ds,year,doy),'data');
		end
	end        
