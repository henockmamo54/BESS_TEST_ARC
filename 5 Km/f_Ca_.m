%This function produce the gap free CO2 from OCO2, GHG-CCI and NOAA baseline carbon dioxide measurements

function f_Ca_(year,month)
%     year = 2021
%     month= 12
    
	load('/bess/JCY/BESSv2/0Calibration/Ca_Site_Sate.mat');

	try
		sprintf('/bess19/Yulin/BESSv2/Ca_OCO2/Ca_OCO2.%d.%02d.mat',year,month)
		raw = importdata(sprintf('/bess19/Yulin/BESSv2/Ca_OCO2/Ca_OCO2.%d.%02d.mat',year,month));
	catch
		try
			sprintf('/bess19/Yulin/BESSv2/Ca_GHGCCI/Ca_GHGCCI.%d.%02d.mat',year,month)
			raw = importdata(sprintf('/bess19/Yulin/BESSv2/Ca_GHGCCI/Ca_GHGCCI.%d.%02d.mat',year,month));
		catch
			raw = nan(36,72,'single');
		end
	end    
		
	noaa = importdata('/bess19/Yulin/Data/NOAACO2/co2_mm_gl.txt');
	years = noaa(:,1);
	months = noaa(:,2);
	vals = noaa(:,3);
	temp = repmat(vals(years==year&months==month),36,72);

	temp = slope.*temp + intercept;
	msk = isfinite(raw);
	temp(msk) = raw(msk);

	MSK = importdata('/bess19/Yulin/BESSv2/Ancillary/Landmask.005d.mat');
	CLI = importdata('/bess19/Yulin/BESSv2/Ancillary/Climate.005d.mat');
	LAT = importdata('/bess19/Yulin/BESSv2/Ancillary/LAT.005d.mat');
	LON = importdata('/bess19/Yulin/BESSv2/Ancillary/LON.005d.mat');

	% Convert to BESS format
	data = imresize(temp,size(MSK),'nearest');
	data = ndnanfilter(data,'hamming',[50,50]);
	data = data(MSK); 
	% Constraints
	ma = nanmax(temp(:)); 
	mi = nanmin(temp(:));
	data(data>ma) = nan;
	data(data<mi) = nan;
	% Fill gaps using climate zone mean
	msk0 = isnan(data);
	for i = 1:6 
		mski = CLI == i; 
		data(msk0&mski) = nanmean(data(mski));
	end

	save(sprintf('/bess19/Yulin/BESSv2/Ca/Ca.%d.%02d.mat',year,month),'data');
