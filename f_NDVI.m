function f_NDVI(year,month)
	year= double(year);
	month= double(month) ;
    disp('test wer')
	% Prepare
	msk30s = importdata('/bess19/Yulin/BESSv2/Ancillary/Landmask.30s.mat');
	msk005d = importdata('/bess19/Yulin/BESSv2/Ancillary/Landmask.005d.mat');
	path1 = '/bess19/Yulin/Data/MCD43D62';
	path2 = '/bess19/Yulin/Data/MCD43D63';

	% Process day by day
	for day = 1:31
		vec = datevec(datenum(year,month,day));
		if vec(2) == month
			doy = datenum(year,month,day) - datenum(year,1,1) + 1;
			if exist(sprintf('%s/%d/%03d',path1,year,doy)) & exist(sprintf('%s/%d/%03d',path2,year,doy))
				% Read raw RED & NIR data 
				file = dir(sprintf('%s/%d/%03d/*.hdf',path1,year,doy));
				disp(file.name)
				RED = hdfread(sprintf('%s/%d/%03d/%s',path1,year,doy,file.name),'BRDF_Albedo_NBAR_Band1');
				RED = single(RED);
				RED(RED==32767) = nan;
				RED = RED * 0.001;
				file = dir(sprintf('%s/%d/%03d/*.hdf',path2,year,doy));
				disp(file.name)
				NIR = hdfread(sprintf('%s/%d/%03d/%s',path2,year,doy,file.name),'BRDF_Albedo_NBAR_Band2');
				NIR = single(NIR);
				NIR(NIR==32767) = nan;
				NIR = NIR * 0.001;
				% Calculate NDVI
				temp = (NIR-RED) ./ (NIR+RED);
				temp(temp>1) = nan;
				temp(temp<-1) = nan;
				% Write in BESS format
				data = temp(msk30s);
				save(sprintf('/bess19/Yulin/BESSv2/NDVI_MCD/NDVI_MCD.%d.%03d.mat',year,doy),'data');
				% Aggregate
				temp_ = f_Aggregate(temp,6);
				data = temp_(msk005d);
				save(sprintf('/bess19/Yulin/BESSv2/NDVI_MCD^/NDVI_MCD^.%d.%03d.mat',year,doy),'data');
			end
		end
	end    
disp('test finished')