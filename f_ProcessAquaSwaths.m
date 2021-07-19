function f_ProcessAquaSwaths(year,doy)
 
    try
        swaths = importdata(sprintf('/bess19/Yulin/BESSv2/Reprojection/%d%03d/Aqua_swaths.mat',year,doy));
        index = importdata(sprintf('/bess19/Yulin/BESSv2/Reprojection/%d%03d/Aqua_index.mat',year,doy));
    catch
        disp('N/A');
        return
    end
     
    mskLand = importdata('/bess19/Yulin/BESSv2/Ancillary/Landmask.005d.mat');
    [height,width] = size(mskLand);
 
    % UTC
    UTC = nan(height,width,'single');
    for i = 1:length(swaths)
        try
            proj = importdata(sprintf('/bess19/Yulin/BESSv2/Reprojection/%d%03d/Aqua_proj.%s.mat',year,doy,swaths{i}));
            msk = proj.msk;
            pid = proj.pid;
        
            raw = importdata(sprintf('/bess19/Yulin/BESSv2/Swath/MYD_ST/%d%03d/MYD_ST.%d%03d.%s.mat',year,doy,year,doy,swaths{i}));
            raw = double(raw);
            raw(raw<0) = nan;
            [~,~,~,hr,min,sec] = datevec(raw/24/3600+datenum(1993,1,1));
            raw = hr+min/60+sec/3600;
            
            temp = nan(height,width,'single');
            temp(msk) = raw(pid);
            msk0 = index == i;
            UTC(msk0) = temp(msk0);
        end
    end
    data = UTC(mskLand); 
	mkdir('/bess19/Yulin/BESSv2/UTC_MYD');
    save(sprintf('/bess19/Yulin/BESSv2/UTC_MYD/UTC_MYD.%d.%03d.mat',year,doy),'data');
    
    % AOD
    AOD = nan(height,width,'single');
    for i = 1:length(swaths)
        try
            proj = importdata(sprintf('/bess19/Yulin/BESSv2/Reprojection/%d%03d/Aqua_proj.%s.mat',year,doy,swaths{i}));
            msk = proj.msk;
            pid = proj.pid;
        
            raw = importdata(sprintf('/bess19/Yulin/BESSv2/Swath/MYD_AOD/%d%03d/MYD_AOD.%d%03d.%s.mat',year,doy,year,doy,swaths{i}));
            raw = imresize(raw,[406,270],'nearest');
            raw = single(raw);
            raw(raw<0) = nan;
            raw = raw * 0.001;
            
            temp = nan(height,width,'single');
            temp(msk) = raw(pid);
            msk0 = index == i;
            AOD(msk0) = temp(msk0);
        end
    end
    data = AOD(mskLand); 
		mkdir('/bess19/Yulin/BESSv2/AOD_MYD');
    save(sprintf('/bess19/Yulin/BESSv2/AOD_MYD/AOD_MYD.%d.%03d.mat',year,doy),'data');
 
    % WV
    WV = nan(height,width,'single');
    for i = 1:length(swaths)
        try
            proj = importdata(sprintf('/bess19/Yulin/BESSv2/Reprojection/%d%03d/Aqua_proj.%s.mat',year,doy,swaths{i}));
            msk = proj.msk;
            pid = proj.pid;
        
            raw = importdata(sprintf('/bess19/Yulin/BESSv2/Swath/MYD_WV/%d%03d/MYD_WV.%d%03d.%s.mat',year,doy,year,doy,swaths{i}));
            raw = single(raw);
            raw(raw==-9999) = nan;
            raw = raw * 0.001;
             
            temp = nan(height,width,'single');
            temp(msk) = raw(pid);
            msk0 = index == i;
            WV(msk0) = temp(msk0);
        end
    end
    data = WV(mskLand); 
	mkdir('/bess19/Yulin/BESSv2/WV_MYD');
    save(sprintf('/bess19/Yulin/BESSv2/WV_MYD/WV_MYD.%d.%03d.mat',year,doy),'data');

    % OZ
    OZ = nan(height,width,'single');
    for i = 1:length(swaths)
        try
            proj = importdata(sprintf('/bess19/Yulin/BESSv2/Reprojection/%d%03d/Aqua_proj.%s.mat',year,doy,swaths{i}));
            msk = proj.msk;
            pid = proj.pid;
        
            raw = importdata(sprintf('/bess19/Yulin/BESSv2/Swath/MYD_OZ/%d%03d/MYD_OZ.%d%03d.%s.mat',year,doy,year,doy,swaths{i}));
            raw = single(raw);
            raw(raw==-32768) = nan;
            raw = raw * 0.1;
             
            temp = nan(height,width,'single');
            temp(msk) = raw(pid);
            msk0 = index == i;
            OZ(msk0) = temp(msk0);
        end
    end
    data = OZ(mskLand); 
	mkdir('/bess19/Yulin/BESSv2/OZ_MYD');
    save(sprintf('/bess19/Yulin/BESSv2/OZ_MYD/OZ_MYD.%d.%03d.mat',year,doy),'data');
    
    % SZA
    SZA = nan(height,width,'single');
    for i = 1:length(swaths)
        try
            proj = importdata(sprintf('/bess19/Yulin/BESSv2/Reprojection/%d%03d/Aqua_proj.%s.mat',year,doy,swaths{i}));
            msk = proj.msk;
            pid = proj.pid;
        
            raw = importdata(sprintf('/bess19/Yulin/BESSv2/Swath/MYD_SZA/%d%03d/MYD_SZA.%d%03d.%s.mat',year,doy,year,doy,swaths{i}));
            raw = single(raw);
            raw(raw<0) = nan;
            raw = raw * 0.01;
            
            temp = nan(height,width,'single');
            temp(msk) = raw(pid);
            msk0 = index == i;
            SZA(msk0) = temp(msk0);
        end
    end
    SZA = SZA(mskLand);  
    
    % VZA
    VZA = nan(height,width,'single');
    for i = 1:length(swaths)
        try
            proj = importdata(sprintf('/bess19/Yulin/BESSv2/Reprojection/%d%03d/Terra_proj.%s.mat',year,doy,swaths{i}));
            msk = proj.msk;
            pid = proj.pid;
        
            raw = importdata(sprintf('/bess19/Yulin/BESSv2/Swath/MYD_VZA/%d%03d/MYD_VZA.%d%03d.%s.mat',year,doy,year,doy,swaths{i}));
            raw = single(raw);
            raw(raw<0) = nan;
            raw = raw * 0.01;
            
            temp = nan(height,width,'single');
            temp(msk) = raw(pid);
            msk0 = index == i;
            VZA(msk0) = temp(msk0);
        end
    end
    data = VZA(mskLand);  
	mkdir('/bess19/Yulin/BESSv2/VZA_MYD');
    save(sprintf('/bess19/Yulin/BESSv2/VZA_MYD/VZA_MYD.%d.%03d.mat',year,doy),'data');
     
    % CF
    CF = nan(height,width,'single');
    for i = 1:length(swaths)
        try
            proj = importdata(sprintf('/bess19/Yulin/BESSv2/Reprojection/%d%03d/Aqua_proj.%s.mat',year,doy,swaths{i}));
            msk = proj.msk;
            pid = proj.pid;
        
            raw = importdata(sprintf('/bess19/Yulin/BESSv2/Swath/MYD_CF/%d%03d/MYD_CF.%d%03d.%s.mat',year,doy,year,doy,swaths{i}));
            raw = single(raw);
            raw(raw<0) = nan;
            raw = raw * 0.01;
              
            temp = nan(height,width,'single');
            temp(msk) = raw(pid);
            msk0 = index == i;
            CF(msk0) = temp(msk0);
        end
    end
    CF = CF(mskLand); 
     
    % COT
    COT = nan(height,width,'single');
    for i = 1:length(swaths)
        try
            proj = importdata(sprintf('/bess19/Yulin/BESSv2/Reprojection/%d%03d/Aqua_proj.%s.mat',year,doy,swaths{i}));
            msk = proj.msk;
            pid = proj.pid;
   
            raw = importdata(sprintf('/bess19/Yulin/BESSv2/Swath/MYD_COT/%d%03d/MYD_COT.%d%03d.%s.mat',year,doy,year,doy,swaths{i}));
            raw = imresize(raw,[406,270],'nearest');
            raw = single(raw);
            raw(raw<0) = nan;
            raw = raw * 0.01;

            temp = nan(height,width,'single');
            temp(msk) = raw(pid);
            msk0 = index == i;
            COT(msk0) = temp(msk0);
        end
    end   
    msk = isnan(COT);
    [~,ind] = bwdist(~msk);
    COT(msk) = COT(ind(msk));
    data = COT(mskLand); 
    data = data .* CF;
    data(SZA>85) = nan;
	mkdir('/bess19/Yulin/BESSv2/COT_MYD');
    save(sprintf('/bess19/Yulin/BESSv2/COT_MYD/COT_MYD.%d.%03d.mat',year,doy),'data');
  