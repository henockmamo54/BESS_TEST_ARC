function f_SMOS(year,month)
	
	year= double(year);
	month= double(month) ;
    path = '/bess/JCY/Data/SMOS';
    r = 0.25;
    lat0 = importdata([path,'/lat.txt']);
    lon0 = importdata([path,'/lon.txt']);
    [LON,LAT] = meshgrid(lon0,lat0);
     
    for day = 1:31
        vec = datevec(datenum(year,month,day));
        if vec(2) == month
            doy = datenum(year,month,day) - datenum(year,1,1) + 1;  
            
            % Ascending
            pathA = sprintf('%s/MIR_CLF31A/%d/%03d',path,year,doy);
            if exist(pathA)
                file = dir([pathA,'/*.nc']); 
                url = [pathA,'/',file.name];
                rawAS = ncread(url,'Soil_Moisture')';
            else
                rawAS = nan(length(lat0),length(lon0));
            end
            
            % Descending
            pathD = sprintf('%s/MIR_CLF31D/%d/%03d',path,year,doy);
            if exist(pathD)
                file = dir([pathD,'/*.nc']);
                url = [pathD,'/',file.name];
                rawDS = ncread(url,'Soil_Moisture')';
            else
                rawDS = nan(length(lat0),length(lon0));
            end
              
            % Aggregate to daily grids
            raw = nanmean(cat(3,rawAS,rawDS),3);
            if all(isnan(raw(:)))
                continue;
            end         
            lat = floor(LAT/r)*r + r/2;
            lon = floor(LON/r)*r + r/2;
            row = uint32((90-r/2-lat)/r) + 1;
            col = uint32((lon-(-180+r/2))/r) + 1;
            id = col + (row-1)*360/r;
            id(end) = (180/r) * (360/r);
            id = uint32(id);
            temp = accumarray(id(:), raw(:), [], @nanmean);
            data = reshape(temp,360/r,180/r)';
            data(data==0) = nan;
            save(sprintf('/bess19/Yulin/BESSv2/Microwave/SMOS-SM/SMOS-SM.%d.%03d.mat',year,doy),'data'); 
        end
    end
    