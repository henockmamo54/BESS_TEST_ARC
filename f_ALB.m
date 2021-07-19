%This code derives RVIS_MCD, RNIR_MCD, RSW_MCD, RVIS_MCD^, RNIR_MCD^, and RSW_MCD^ from MCD43D59, MCD43D60 and MCD43D61. with "^" 0.05 degree, without "^" 0.01 degree
function f_ALB(year,month,opt)
	year= double(year);
	month= double(month) ;
    
%     year = 2020
%     month = 6
%     opt = "VIS"
    
	% Prepare
	msk30s = importdata('/bess19/Yulin/BESSv2/Ancillary/Landmask.30s.mat');
	msk005d = importdata('/bess19/Yulin/BESSv2/Ancillary/Landmask.005d.mat');
	if strcmp(opt,'VIS')
		path = '/bess19/Yulin/Data/MCD43D59';
		field = 'BRDF_Albedo_WSA_VIS';
	elseif strcmp(opt,'NIR')
		path = '/bess19/Yulin/Data/MCD43D60';
		field = 'BRDF_Albedo_WSA_NIR';
	elseif strcmp(opt,'SW')
		path = '/bess19/Yulin/Data/MCD43D61';
		field = 'BRDF_Albedo_WSA_Shortwave';
	end
	ds = sprintf('R%s_MCD',opt);

	% Process day by day
	for day = 1:31
		vec = datevec(datenum(year,month,day));
		if vec(2) == month
			doy = datenum(year,month,day) - datenum(year,1,1) + 1;
			if exist(sprintf('%s/%d/%03d',path,year,doy))
				% Read raw ALB data 
				file = dir(sprintf('%s/%d/%03d/*.hdf',path,year,doy));
				raw = hdfread(sprintf('%s/%d/%03d/%s',path,year,doy,file.name),field);
				temp = single(raw);
				temp(temp==32767) = nan;
				temp = temp * 0.001;
				% Write in BESS format
				data = temp(msk30s);
				mkdir(sprintf('/bess19/Yulin/BESSv2/%s',ds))
				save(sprintf('/bess19/Yulin/BESSv2/%s/%s.%d.%03d.mat',ds,ds,year,doy),'data');
				% Aggregate
				temp_ = f_Aggregate(temp,6);
				data = temp_(msk005d);
				mkdir(sprintf('/bess19/Yulin/BESSv2/%s^',ds));
				save(sprintf('/bess19/Yulin/BESSv2/%s^/%s^.%d.%03d.mat',ds,ds,year,doy),'data');
			end
		end
	end