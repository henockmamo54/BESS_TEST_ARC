

function f_FNonVeg(year)
	 
	year = double(year); 
	
	
	for year = year
 
		%Prepare
		msk30s = importdata('/bess19/Yulin/BESSv2/Ancillary/Landmask.30s.mat');
		msk005d = importdata('/bess19/Yulin/BESSv2/Ancillary/Landmask.005d.mat');
		path = '/bess19/Yulin/Data/MOD44B';
		%path = '/bess/JCY/Data/MOD44B';
		temp = nan(size(msk30s),'single');
		id = importdata('/bess19/Yulin/BESSv2/Ancillary/id_500m_30s.mat');
		sidelength = 2400;
		height = 43200;
		width = 86400;
		huge = zeros(height,width,'uint8');

		directory = dir(sprintf('%s/%d/*.hdf',path,year));
		names = {directory.name};
		%Initialize global matrix and BESS grid
		huge(:) = 255;
		temp(:) = nan;
		%Fill the matrix file by file
		for k = 1:length(names)
			%Read dataset tile from HDF file
			url = sprintf('%s/%d/%s',path,year,names{k});
			%Identify tile name from file name
			ind = regexp(url,'h\d\dv\d\d');
			tile = url(ind:ind+5);
			%Convert tile number to matrix position
			h = str2num(tile(2:3));
			v = str2num(tile(5:6));
			j = (h-0)*sidelength + 1;
			i = (v-0)*sidelength + 1;
			%Read data
			raw = hdfread(url,'Percent_NonVegetated');
			raw = single(raw);  
			raw(raw>=200) = nan;
			%Reduce resolution from 250 m to 500 m
			raw = f_Aggregate(raw,2);
			raw = round(raw);
			raw(isnan(raw)) = 255;
			%Fill the global huge matrix
			huge(i:i+sidelength-1,j:j+sidelength-1) = raw;
		end 
		%Convert from 500m to 30s
		msk = huge < 255;
		temp(id(msk)) = huge(msk); 
		clear msk 
		%Convert DN to value
		temp(temp==255) = nan;
		temp = temp * 0.01;
		%Write in BESS format
		data = temp(msk30s);
		mkdir(sprintf('/bess19/Yulin/BESSv2/FNonVeg/'));
		save(sprintf('/bess19/Yulin/BESSv2/FNonVeg/FNonVeg.%d.mat',year),'data');
		%Aggregate to 0.05 degree
		temp_ = f_Aggregate(temp,6);
		%Write in BESS format
		data = temp_(msk005d);
		mkdir(sprintf('/bess19/Yulin/BESSv2/FNonVeg^/'));
		save(sprintf('/bess19/Yulin/BESSv2/FNonVeg^/FNonVeg^.%d.mat',year),'data');
		 
	end 

	
	series = nan(8774037,17,'single');
	for year = 2000:year 
		series(:,year-1999) = importdata(sprintf('/bess19/Yulin/BESSv2/FNonVeg^/FNonVeg^.%d.mat',year));
	end
	data = nanmean(series,2);
	save('/bess19/Yulin/BESSv2/Ancillary^/FNonVeg^.mat','data');

	n = 17;
	X = nan(8774037,n,'single');
	Y = nan(8774037,n,'single');
	i = 1;
	for year = 2000:year
		X(:,i) = year;
		Y(:,i) = importdata(sprintf('/bess19/Yulin/BESSv2/FNonVeg^/FNonVeg^.%d.mat',year));
		i = i + 1;
	end
	msk = isfinite(X) & isfinite(Y);
	X(~msk) = nan;
	Y(~msk) = nan;
	X_ = nanmean(X,2);
	Y_ = nanmean(Y,2);
	X(isnan(X)) = 0;
	Y(isnan(Y)) = 0;
	SXY = zeros(8774037,1,'single');
	SXX = zeros(8774037,1,'single');
	SYY = zeros(8774037,1,'single');
	for i = 1:n
		dX = X(:,i) - X_;
		dY = Y(:,i) - Y_;
		SXY = SXY + dX.*dY.*msk(:,i);
		SXX = SXX + dX.*dX.*msk(:,i);
		SYY = SYY + dY.*dY.*msk(:,i);
	end
	r = SXY ./ sqrt((SXX.*SYY));
	slope = SXY ./ SXX;
	upper = prctile(slope,99);
	lower = prctile(slope,1);
	slope(slope>upper) = upper;
	slope(slope<lower) = lower;
	slope(isnan(slope)) = nanmedian(slope);
	intercept = Y_ - slope.*X_;
	upper = prctile(intercept,99);
	lower = prctile(intercept,1);
	intercept(intercept>upper) = upper;
	intercept(intercept<lower) = lower;
	intercept(isnan(intercept)) = nanmedian(intercept); 
	for year = 2000:year
		data = slope*year + intercept;
		data(data<0) = 0;
		data(data>1) = 1;
		msk = abs(r) < 0.4;
		data(msk) = Y_(msk);
		mkdir(sprintf('/bess19/Yulin/BESSv2/FNonVeg^_Trended/'))
		sprintf('/bess19/Yulin/BESSv2/FNonVeg^_Trended/FNonVeg^_Trended.%d.mat',year)
		save(sprintf('/bess19/Yulin/BESSv2/FNonVeg^_Trended/FNonVeg^_Trended.%d.mat',year),'data');
	end

end