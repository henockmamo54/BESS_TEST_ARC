function f_ExtractAquaSwaths(year,doy)
     
    path = sprintf('/bess19/Yulin/Data/Aqua_L2/%d/%03d',year,doy);
    if ~exist(sprintf('%s/files.mat',path))
        disp('N/A');
        return 
    end
     
    files = importdata(sprintf('%s/files.mat',path));

    pathLAT = sprintf('/bess19/Yulin/BESSv2/Swath/MYD_LAT/%d%03d',year,doy);
    if ~exist(pathLAT)
        mkdir(pathLAT)
    end
    pathLON = sprintf('/bess19/Yulin/BESSv2/Swath/MYD_LON/%d%03d',year,doy);
    if ~exist(pathLON)
        mkdir(pathLON)
    end
    pathSZA = sprintf('/bess19/Yulin/BESSv2/Swath/MYD_SZA/%d%03d',year,doy);
    if ~exist(pathSZA)
        mkdir(pathSZA)
    end
    pathVZA = sprintf('/bess19/Yulin/BESSv2/Swath/MYD_VZA/%d%03d',year,doy);
    if ~exist(pathVZA)
        mkdir(pathVZA)
    end
    pathST = sprintf('/bess19/Yulin/BESSv2/Swath/MYD_ST/%d%03d',year,doy);
    if ~exist(pathST)
        mkdir(pathST)
    end
    pathTa3D = sprintf('/bess19/Yulin/BESSv2/Swath/MYD_Ta3D/%d%03d',year,doy);
    if ~exist(pathTa3D)
        mkdir(pathTa3D)
    end
    pathTd3D = sprintf('/bess19/Yulin/BESSv2/Swath/MYD_Td3D/%d%03d',year,doy);
    if ~exist(pathTd3D)
        mkdir(pathTd3D)
    end
    pathPs = sprintf('/bess19/Yulin/BESSv2/Swath/MYD_Ps/%d%03d',year,doy);
    if ~exist(pathPs)
        mkdir(pathPs)
    end
    pathTn = sprintf('/bess19/Yulin/BESSv2/Swath/MYD_Tn/%d%03d',year,doy);
    if ~exist(pathTn)
        mkdir(pathTn)
    end
    pathWV = sprintf('/bess19/Yulin/BESSv2/Swath/MYD_WV/%d%03d',year,doy);
    if ~exist(pathWV)
        mkdir(pathWV)
    end
    pathOZ = sprintf('/bess19/Yulin/BESSv2/Swath/MYD_OZ/%d%03d',year,doy);
    if ~exist(pathOZ)
        mkdir(pathOZ)
    end
    pathCOT = sprintf('/bess19/Yulin/BESSv2/Swath/MYD_COT/%d%03d',year,doy);
    if ~exist(pathCOT)
        mkdir(pathCOT)
    end
    pathCF = sprintf('/bess19/Yulin/BESSv2/Swath/MYD_CF/%d%03d',year,doy);
    if ~exist(pathCF)
        mkdir(pathCF)
    end
    pathAOD = sprintf('/bess19/Yulin/BESSv2/Swath/MYD_AOD/%d%03d',year,doy);
    if ~exist(pathAOD)
        mkdir(pathAOD)
    end
    pathLST = sprintf('/bess19/Yulin/BESSv2/Swath/MYD_LST/%d%03d',year,doy);
    if ~exist(pathLST)
        mkdir(pathLST)
    end
    pathEMIS31 = sprintf('/bess19/Yulin/BESSv2/Swath/MYD_EMIS31/%d%03d',year,doy);
    if ~exist(pathEMIS31)
        mkdir(pathEMIS31)
    end
    pathEMIS32 = sprintf('/bess19/Yulin/BESSv2/Swath/MYD_EMIS32/%d%03d',year,doy);
    if ~exist(pathEMIS32)
        mkdir(pathEMIS32)
    end
    
    for i = 1:length(files)
        name = files{i,5};
        if length(name) == 0
            continue;
        end
        hm = cell2mat(files{i,1});
        
        % Local and online address
        url = sprintf('%s/MYD07_L2/%s',path,name);
        URL = sprintf('https://ladsweb.modaps.eosdis.nasa.gov/archive/allData/61/MYD07_L2/%d/%03d/%s',year,doy,name);
        
        % % LAT
        raw = readHDF(url,URL,'Latitude');
        data = imresize(raw,[406,270],'nearest');
        save(sprintf('%s/MYD_LAT.%d%03d.%s.mat',pathLAT,year,doy,hm),'data');

        % % LON
        raw = readHDF(url,URL,'Longitude');
        data = imresize(raw,[406,270],'nearest');
        save(sprintf('%s/MYD_LON.%d%03d.%s.mat',pathLON,year,doy,hm),'data');
        
        % % SZA
        raw = readHDF(url,URL,'Solar_Zenith');
        data = imresize(raw,[406,270],'nearest');
        save(sprintf('%s/MYD_SZA.%d%03d.%s.mat',pathSZA,year,doy,hm),'data');
        
        % % VZA
        raw = readHDF(url,URL,'Sensor_Zenith');
        data = imresize(raw,[406,270],'nearest');
        save(sprintf('%s/MYD_VZA.%d%03d.%s.mat',pathVZA,year,doy,hm),'data');
        
        % % ST
        raw = readHDF(url,URL,'Scan_Start_Time');
        data = imresize(raw,[406,270],'nearest');
        save(sprintf('%s/MYD_ST.%d%03d.%s.mat',pathST,year,doy,hm),'data');
        
        % % Ta3D
        raw = readHDF(url,URL,'Retrieved_Temperature_Profile');
        data = cat(3,imresize(squeeze(raw(13,:,:)),[406,270],'nearest'),imresize(squeeze(raw(14,:,:)),[406,270],'nearest'),imresize(squeeze(raw(15,:,:)),[406,270],'nearest'),imresize(squeeze(raw(16,:,:)),[406,270],'nearest'),imresize(squeeze(raw(17,:,:)),[406,270],'nearest'),imresize(squeeze(raw(18,:,:)),[406,270],'nearest'),imresize(squeeze(raw(19,:,:)),[406,270],'nearest'),imresize(squeeze(raw(20,:,:)),[406,270],'nearest'));
        save(sprintf('%s/MYD_Ta3D.%d%03d.%s.mat',pathTa3D,year,doy,hm),'data');
        
        % % Td3D
        raw = readHDF(url,URL,'Retrieved_Moisture_Profile');
        data = cat(3,imresize(squeeze(raw(13,:,:)),[406,270],'nearest'),imresize(squeeze(raw(14,:,:)),[406,270],'nearest'),imresize(squeeze(raw(15,:,:)),[406,270],'nearest'),imresize(squeeze(raw(16,:,:)),[406,270],'nearest'),imresize(squeeze(raw(17,:,:)),[406,270],'nearest'),imresize(squeeze(raw(18,:,:)),[406,270],'nearest'),imresize(squeeze(raw(19,:,:)),[406,270],'nearest'),imresize(squeeze(raw(20,:,:)),[406,270],'nearest'));
        save(sprintf('%s/MYD_Td3D.%d%03d.%s.mat',pathTd3D,year,doy,hm),'data');
          
        % Ps
        raw = readHDF(url,URL,'Surface_Pressure');
        data = imresize(raw,[406,270],'nearest');
        save(sprintf('%s/MYD_Ps.%d%03d.%s.mat',pathPs,year,doy,hm),'data');
          
        % % Tn
        raw = readHDF(url,URL,'Skin_Temperature');
        data = imresize(raw,[406,270],'nearest');
        save(sprintf('%s/MYD_Tn.%d%03d.%s.mat',pathTn,year,doy,hm),'data');
        
        % % WV
        raw = readHDF(url,URL,'Water_Vapor');
        data = imresize(raw,[406,270],'nearest');
        save(sprintf('%s/MYD_WV.%d%03d.%s.mat',pathWV,year,doy,hm),'data');
        
        % % OZ
        raw = readHDF(url,URL,'Total_Ozone');
        data = imresize(raw,[406,270],'nearest');
        save(sprintf('%s/MYD_OZ.%d%03d.%s.mat',pathOZ,year,doy,hm),'data');
        
    end
     
    for i = 1:length(files)
        name = files{i,4};
        if length(name) == 0
            continue;
        end
        hm = cell2mat(files{i,1});
        
        % % Local and online address
        url = sprintf('%s/MYD06_L2/%s',path,name);
        URL = sprintf('https://ladsweb.modaps.eosdis.nasa.gov/archive/allData/61/MYD06_L2/%d/%03d/%s',year,doy,name);

        % % COT
        raw1 = readHDF(url,URL,'Cloud_Optical_Thickness');
        raw2 = readHDF(url,URL,'Cloud_Optical_Thickness_PCL');
        data = raw1;
        data(raw1==-9999) = raw2(raw1==-9999);
        save(sprintf('%s/MYD_COT.%d%03d.%s.mat',pathCOT,year,doy,hm),'data');
        
        % % CF
        raw = readHDF(url,URL,'Cloud_Fraction');
        data = imresize(raw,[406,270],'nearest'); 
        save(sprintf('%s/MYD_CF.%d%03d.%s.mat',pathCF,year,doy,hm),'data');
    end   
        
    for i = 1:length(files)
        name = files{i,3};
        if length(name) == 0
            continue;
        end
        hm = cell2mat(files{i,1});
        
        % % Local and online address
        url = sprintf('%s/MYD04_L2/%s',path,name);
        URL = sprintf('https://ladsweb.modaps.eosdis.nasa.gov/archive/allData/61/MYD04_L2/%d/%03d/%s',year,doy,name);
        
        % % AOD
        raw = readHDF(url,URL,'AOD_550_Dark_Target_Deep_Blue_Combined');
        data = raw;
        save(sprintf('%s/MYD_AOD.%d%03d.%s.mat',pathAOD,year,doy,hm),'data');
    end    
     
    for i = 1:length(files)
        name = files{i,2};
        if length(name) == 0
            continue;
        end
        hm = cell2mat(files{i,1});
        
        % % Local and online address
        url = sprintf('%s/MYD11_L2/%s',path,name);
        URL = sprintf('https://ladsweb.modaps.eosdis.nasa.gov/archive/allData/6/MYD11_L2/%d/%03d/%s',year,doy,name);

        % % LST
        raw = readHDF(url,URL,'LST');
        data = raw;
        save(sprintf('%s/MYD_LST.%d%03d.%s.mat',pathLST,year,doy,hm),'data');
        
        % % EMIS31
        raw = readHDF(url,URL,'Emis_31');
        data = raw;
        save(sprintf('%s/MYD_EMIS31.%d%03d.%s.mat',pathEMIS31,year,doy,hm),'data');
        
        % % EMIS32
        raw = readHDF(url,URL,'Emis_32');
        data = raw;
        save(sprintf('%s/MYD_EMIS32.%d%03d.%s.mat',pathEMIS32,year,doy,hm),'data');
    end
    
 