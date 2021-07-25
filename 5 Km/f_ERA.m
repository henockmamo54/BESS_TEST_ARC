% this is the fuction for producing ssrd, t2m, d2m from ERA_Interim/ERA5 data
function f_ERA(year,month)
	year= double(year);
	month= double(month) ;
    
%     year = 2020
%     month = 7

	vars = {'ssrd','t2m','d2m'};
	pathIn = '/bess19/Yulin/Data/ERA5';
	pathOut = sprintf('/bess19/Yulin/BESSv2/ERA/%d.%02d',year,month);
	if ~exist(pathOut)
		mkdir(pathOut)
	end

	dh = ncread(sprintf('%s/%d/ERA_Forecast.%d.%02d.nc',pathIn,year,year,month),'time');
	vec = datevec(datetime('1900-01-01')+hours(dh));
	for i = 1:length(vars)
		raw = ncread(sprintf('%s/%d/ERA_Forecast.%d.%02d.nc',pathIn,year,year,month),vars{i});
		raw = single(raw);
		size(raw);
		
		% raw = permute(raw,[3,2,1]); %  note data issue ERA5 at 2020-05      raw = permute(raw,[4,2,1,3]);
		try
			raw = permute(raw,[3,2,1]);
		catch
			raw = permute(raw,[4,2,1,3]);
		end
		
		raw= raw(:,:,:,1);
		size(raw)
		
		if month == 1
			raw_ = ncread(sprintf('%s/%d/ERA_Forecast.%d.%02d.nc',pathIn,year-1,year-1,12),vars{i});
		else
			raw_ = ncread(sprintf('%s/%d/ERA_Forecast.%d.%02d.nc',pathIn,year,year,month-1),vars{i});
		end
		raw_ = single(raw_);
		size(raw_);
		% raw_ = permute(raw_,[3,2,1]); %  note data issue ERA5 at 2020-05      raw = permute(raw,[4,2,1,3]);   raw_ = permute(raw_,[3,2,1]);
		%raw_ = raw_(:,:,:,1);
		
		try
			raw_ = permute(raw_,[3,2,1]);
		catch
			 raw = permute(raw,[4,2,1,3]);
		end
		
		
		raw_ = raw_(end,:,:);
		for day = 1:31
			msk = vec(:,2)==month & vec(:,3)==day;
			size(msk);
			if sum(msk) == 0
				continue;
			end
			data = raw(msk,:,:);
			if day == 1
				data = [raw_;data];
			end
			save(sprintf('%s/%s.%d.%02d.%02d.mat',pathOut,vars{i},year,month,day),'data');
		end
	end
