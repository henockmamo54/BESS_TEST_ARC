function f_SMAP(year,month)
	
	year= double(year);
	month= double(month) ;
    path = '/bess/JCY/Data/SMAP';
    r = 0.25;  
      
    for day = 1:31
        vec = datevec(datenum(year,month,day));
        if vec(2) == month
            doy = datenum(year,month,day) - datenum(year,1,1) + 1;  
            
            % Get file name
            file = dir(sprintf('%s/%d/SMAP_L3_SM_P_E_%d%02d%02d_*.h5',path,year,year,month,day));
            if length(file) == 0
                continue;
            end  
            url = sprintf('%s/%d/%s',path,year,file.name);
             
            % Prepare AM data
            rawAM = hdf5read(url,'/Soil_Moisture_Retrieval_Data_AM/soil_moisture')';
            flgAM = hdf5read(url,'/Soil_Moisture_Retrieval_Data_AM/retrieval_qual_flag')';
            rawAM(bitget(flgAM,2,'uint16')==1) = nan;%|bitget(flgAM,1,'uint16')==1) = nan;
            latAM = hdf5read(url,'/Soil_Moisture_Retrieval_Data_AM/latitude_centroid')';
            latAM(latAM==-9999) = nan;
            lonAM = hdf5read(url,'/Soil_Moisture_Retrieval_Data_AM/longitude_centroid')';
            lonAM(lonAM==-9999) = nan;
            mskAM = isfinite(rawAM);
             
            % Prepare PM data
            rawPM = hdf5read(url,'/Soil_Moisture_Retrieval_Data_PM/soil_moisture_pm')';
            flgPM = hdf5read(url,'/Soil_Moisture_Retrieval_Data_PM/retrieval_qual_flag_pm')';
            rawPM(bitget(flgPM,2,'uint16')==1) = nan;%|bitget(flgPM,1,'uint16')==1) = nan;
            latPM = hdf5read(url,'/Soil_Moisture_Retrieval_Data_PM/latitude_centroid_pm')';
            latPM(latPM==-9999) = nan;
            lonPM = hdf5read(url,'/Soil_Moisture_Retrieval_Data_PM/longitude_centroid_pm')';
            lonPM(lonPM==-9999) = nan;
            mskPM = isfinite(rawPM);
               
            % Aggregate to daily grids
            raw = [rawAM(mskAM);rawPM(mskPM)];
            lat = [latAM(mskAM);latPM(mskPM)];
            lon = [lonAM(mskAM);lonPM(mskPM)];
            lat = floor(lat/r)*r + r/2;
            lon = floor(lon/r)*r + r/2;
            row = uint32((90-r/2-lat)/r) + 1;
            col = uint32((lon-(-180+r/2))/r) + 1;
            id = col + (row-1)*360/r;
            id(end) = (180/r) * (360/r);
            id = uint32(id);
            temp = accumarray(id(:), raw(:), [], @nanmean);
            data = reshape(temp,360/r,180/r)';
            data(data==0) = nan;
            save(sprintf('/bess19/Yulin/BESSv2/Microwave/SMAP-SM/SMAP-SM.%d.%03d.mat',year,doy),'data'); 
        end
    end 
        