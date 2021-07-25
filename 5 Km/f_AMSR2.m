function f_AMSR2(year,month)
	
	year= double(year);
	month= double(month) ;
    path = '/bess/JCY/Data/AMSR2';
            
    for day = 1:31
        vec = datevec(datenum(year,month,day));
        if vec(2) == month
            doy = datenum(year,month,day) - datenum(year,1,1) + 1;  
             
            % Ascending
            file = dir(sprintf('%s/AMSR2_Ascending/%d/%02d/*%d%02d%02d*.nc4',path,year,month,year,month,day));
            if length(file) > 1
                file = file(2);
            end
            if length(file) > 0
                url = sprintf('%s/AMSR2_Ascending/%d/%02d/%s',path,year,month,file.name);
                rawAS_c1 = ncread(url,'soil_moisture_c1');
                rawAS_c2 = ncread(url,'soil_moisture_c2');
                rawAS_x = ncread(url,'soil_moisture_x');
            else
                rawAS_c1 = nan(1800,3600);
                rawAS_c2 = nan(1800,3600);
                rawAS_x = nan(1800,3600);
            end
                  
            % Descending
            file = dir(sprintf('%s/AMSR2_Descending/%d/%02d/*%d%02d%02d*.nc4',path,year,month,year,month,day));
            if length(file) > 1
                file = file(2);
            end
            if length(file) > 0
                url = sprintf('%s/AMSR2_Descending/%d/%02d/%s',path,year,month,file.name);
                rawDS_c1 = ncread(url,'soil_moisture_c1');
                rawDS_c2 = ncread(url,'soil_moisture_c2');
                rawDS_x = ncread(url,'soil_moisture_x');
            else
                rawDS_c1 = nan(1800,3600);
                rawDS_c2 = nan(1800,3600);
                rawDS_x = nan(1800,3600);
            end
               
            % Aggregate to daily grids 
            DATA = nanmean(cat(3,rawAS_c1,rawAS_c2,rawAS_x,rawDS_c1,rawDS_c2,rawDS_x),3) / 100;
            if all(isnan(DATA(:)))
                continue;
            end 
            DATA = imresize(DATA,2,'nearest'); 
            data = f_Aggregate(DATA,5);
            save(sprintf('/bess19/Yulin/BESSv2/Microwave/AMSR2-SM/AMSR2-SM.%d.%03d.mat',year,doy),'data'); 
        end
    end
    