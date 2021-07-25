function f_ReprojectTerraSwaths(year,doy)
      
    path = sprintf('/bess19/Yulin/Data/Terra_L2/%d/%03d',year,doy);
    if ~exist(sprintf('%s/swaths.mat',path))
        disp('N/A');
        return 
    end

    r = 0.05;
    [LON,LAT] = meshgrid(-180+r/2:r:180-r/2,90-r/2:-r:-90+r/2); 
    mskLand = importdata('/bess19/Yulin/BESSv2/Ancillary/Landmask.005d.mat');  
 
    path = sprintf('/bess19/Yulin/BESSv2/Reprojection/%d%03d',year,doy);
    if ~exist(path)
        mkdir(path)
    end
    system(sprintf('cp /bess19/Yulin/Data/Terra_L2/%d/%03d/swaths.mat %s/Terra_swaths.mat',year,doy,path));
  
    r = 0.05; 
    [height,width] = size(mskLand);
    hm = importdata(sprintf('%s/Terra_swaths.mat',path));
    
    ensemble = zeros(length(hm),height,width,'int16');
    ensemble(:) = 32767;
    for i = 1:length(hm)
        % Swath coordinates
        if ~exist(sprintf('/bess19/Yulin/BESSv2/Swath/MOD_SZA/%d%03d/MOD_SZA.%d%03d.%s.mat',year,doy,year,doy,hm{i}))
            continue;
        end
        lat = importdata(sprintf('/bess19/Yulin/BESSv2/Swath/MOD_LAT/%d%03d/MOD_LAT.%d%03d.%s.mat',year,doy,year,doy,hm{i}));
        lon = importdata(sprintf('/bess19/Yulin/BESSv2/Swath/MOD_LON/%d%03d/MOD_LON.%d%03d.%s.mat',year,doy,year,doy,hm{i}));
        lon(lon>=180) = 179.9999;
        lon(lon<=-180) = -179.9999;
        % Grid coordinates
        Lat = floor(lat/r)*r + r/2;
        Lon = floor(lon/r)*r + r/2;
        % Grid positions
        Row = uint32((90-r/2-Lat)/r) + 1;
        Col = uint32((Lon-(-180+r/2))/r) + 1;
        % Mark swath on grid
        if min(Col(:))==1 & max(Col(:))==width & min(Row(:))>1 & max(Row(:))<height    % cross date line but not over N/S pole
            msk = Col <= width/2;
            x1 = Lon(msk);
            y1 = Lat(msk);
            x2 = Lon(~msk);
            y2 = Lat(~msk);
            try
                edge1 = convhull(double(x1),double(y1));
                x1_ = x1(edge1);
                y1_ = y1(edge1);
            catch
                x1_ = x1;
                y1_ = y1;
            end    
            try
                edge2 = convhull(double(x2),double(y2));
                x2_ = x2(edge2);
                y2_ = y2(edge2);
            catch
                x2_ = x2;
                y2_ = y2;
            end    
            [Z,R] = vec2mtx([y1_;y2_],[x1_;x2_],20,[-90,90],[-180,180]);
        else    
            edge = convhull(double(Lon(:)),double(Lat(:)));
            [Z,R] = vec2mtx(Lat(edge),Lon(edge),20,[-90,90],[-180,180]);
        end
        msk = imfill(flipud(logical(Z)),'holes') & mskLand;
        % Mapping relation
        pt = [lon(:),lat(:)];
        PT = [LON(msk),LAT(msk)];
        dt = delaunayTriangulation(double(pt));
        pid = dt.nearestNeighbor(double(PT));
        % Save reprojection
        data.msk = msk;
        data.pid = uint32(pid);
        save(sprintf('%s/Terra_proj.%s.mat',path,hm{i}),'data');
        % Load solar zenith angle
        sza = importdata(sprintf('/bess19/Yulin/BESSv2/Swath/MOD_SZA/%d%03d/MOD_SZA.%d%03d.%s.mat',year,doy,year,doy,hm{i}));
        ensemble(i,msk) = sza(pid);        
    end
    % Identify min solar zenith angle for overlapped swaths
    [~,ind] = min(ensemble,[],1);
    data = squeeze(ind); save(sprintf('%s/Terra_index.mat',path),'data');
     