% This function is the prepcocessing of OCO2 CO2 raw data, daily to monthly

function f_OCO2(year,month)

	year= double(year);
	month= double(month) ;
	% Prepare
	path = '/bess19/Yulin/Data/OCO2CO2/';
	r = 5;
	
	disp("this is for test, remove this after test" + "****no data for 2021 ***")
	year=2020
	 
	% Collect all data within the month
	dire = dir(sprintf('%s/%d/*_%d%02d*_*.nc4',path,year,year-2000,month));
	names = {dire.name};
	latitude = [];
	longitude = [];
	raw = [];
	qc = [];
	for i = 1:length(names)
		url = sprintf('%s/%d/%s',path,year,names{i});
		sprintf('%s/%d/%s',path,year,names{i})
		% Read swath data
		lat = ncread(url,'latitude');
		lon = ncread(url,'longitude');  
		xco2 = ncread(url,'xco2');  
		flg = ncread(url,'xco2_quality_flag');
		% Add current swath data to ensemble
		latitude = [latitude;double(lat(:))];
		longitude = [longitude;double(lon(:))];
		raw = [raw;double(xco2(:))];
		qc = [qc;double(flg(:))];
	end  
	% Apply quality control
	raw(qc==1) = nan;    
	longitude(longitude>=180) = 179.9999;
	longitude(longitude<=-180) = -179.9999; 
	% Grid coordinates   
	lat = floor(latitude/r)*r + r/2;
	lon = floor(longitude/r)*r + r/2;
	% Grid positions   
	row = uint32((90-r/2-lat)/r) + 1;
	col = uint32((lon-(-180+r/2))/r) + 1;
	% Grid index    
	ind = sub2ind([180/r,360/r],row,col);
	% Aggregate  
	temp = accumarray(ind(:), raw(:), [], @nanmean);
	temp = [temp;nan(180/r*360/r-max(ind),1)];
	temp = reshape(temp,180/r,360/r);
	temp(temp<=0) = nan;
	
	data = temp;
	
	save(sprintf('/bess19/Yulin/BESSv2/Ca_OCO2/Ca_OCO2.%d.%02d.mat',year,month),'data');

		% MSK = importdata('../Ancillary/Landmask.005d.mat');
		% CLI = importdata('../Ancillary/Climate.005d.mat');
		% LAT = importdata('../Ancillary/LAT.005d.mat');
		% LON = importdata('../Ancillary/LON.005d.mat');
		
		% % Fill gaps using interpolation
		% ma = nanmax(temp(:)); 
		% mi = nanmin(temp(:));
		% msk = isnan(temp);
		% temp(msk) = griddata(lon(~msk),lat(~msk),temp(~msk),lon(msk),lat(msk));
		% temp(temp>ma) = ma;
		% temp(temp<mi) = mi; 
		% % Convert to BESS format
		% data = imresize(temp,size(MSK));
		% data = data(MSK); 
		% % Fill gaps using interpolation
		% msk = isnan(data);
		% data(msk) = griddata(double(LON(~msk)),double(LAT(~msk)),double(data(~msk)),double(LON(msk)),double(LAT(msk)));
		% data = single(data);
		% data(data>ma) = ma;
		% data(data<mi) = mi;
		% % Fill gaps using climate zone mean
		% msk0 = isnan(data);
		% for i = 1:6 
			% mski = CLI == i; 
			% data(msk0&mski) = nanmean(data(mski));
		% end
