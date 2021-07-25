function f_ProcessTerraSwaths(year,doy)

    try
        swaths = importdata(sprintf('/bess19/Yulin/BESSv2/Reprojection/%d%03d/Terra_swaths.mat',year,doy));
        index = importdata(sprintf('/bess19/Yulin/BESSv2/Reprojection/%d%03d/Terra_index.mat',year,doy));
    catch
        disp('N/A');
        return
    end
         
    mskLand = importdata('/bess19/Yulin/BESSv2/Ancillary/Landmask.005d.mat');
    [height,width] = size(mskLand); 

    % % UTC
    UTC = nan(height,width,'single');
    for i = 1:length(swaths)
        try
            proj = importdata(sprintf('/bess19/Yulin/BESSv2/Reprojection/%d%03d/Terra_proj.%s.mat',year,doy,swaths{i}));
            msk = proj.msk;
            pid = proj.pid;
        
            raw = importdata(sprintf('/bess19/Yulin/BESSv2/Swath/MOD_ST/%d%03d/MOD_ST.%d%03d.%s.mat',year,doy,year,doy,swaths{i}));
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
	mkdir('/bess19/Yulin/BESSv2/UTC_MOD');
    save(sprintf('/bess19/Yulin/BESSv2/UTC_MOD/UTC_MOD.%d.%03d.mat',year,doy),'data');
            
    % % AOD
    AOD = nan(height,width,'single');
    for i = 1:length(swaths)
        try
            proj = importdata(sprintf('/bess19/Yulin/BESSv2/Reprojection/%d%03d/Terra_proj.%s.mat',year,doy,swaths{i}));
            msk = proj.msk;
            pid = proj.pid;
        
            raw = importdata(sprintf('/bess19/Yulin/BESSv2/Swath/MOD_AOD/%d%03d/MOD_AOD.%d%03d.%s.mat',year,doy,year,doy,swaths{i}));
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
	mkdir('/bess19/Yulin/BESSv2/AOD_MOD');
    save(sprintf('/bess19/Yulin/BESSv2/AOD_MOD/AOD_MOD.%d.%03d.mat',year,doy),'data');

    % % WV
    WV = nan(height,width,'single');
    for i = 1:length(swaths)
        try
            proj = importdata(sprintf('/bess19/Yulin/BESSv2/Reprojection/%d%03d/Terra_proj.%s.mat',year,doy,swaths{i}));
            msk = proj.msk;
            pid = proj.pid;
        
            raw = importdata(sprintf('/bess19/Yulin/BESSv2/Swath/MOD_WV/%d%03d/MOD_WV.%d%03d.%s.mat',year,doy,year,doy,swaths{i}));
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
	mkdir('/bess19/Yulin/BESSv2/WV_MOD');
    save(sprintf('/bess19/Yulin/BESSv2/WV_MOD/WV_MOD.%d.%03d.mat',year,doy),'data');

    % % OZ
    OZ = nan(height,width,'single');
    for i = 1:length(swaths)
        try
            proj = importdata(sprintf('/bess19/Yulin/BESSv2/Reprojection/%d%03d/Terra_proj.%s.mat',year,doy,swaths{i}));
            msk = proj.msk;
            pid = proj.pid;
        
            raw = importdata(sprintf('/bess19/Yulin/BESSv2/Swath/MOD_OZ/%d%03d/MOD_OZ.%d%03d.%s.mat',year,doy,year,doy,swaths{i}));
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
	mkdir('/bess19/Yulin/BESSv2/OZ_MOD');
    save(sprintf('/bess19/Yulin/BESSv2/OZ_MOD/OZ_MOD.%d.%03d.mat',year,doy),'data');
    
    % % SZA
    SZA = nan(height,width,'single');
    for i = 1:length(swaths)
        try
            proj = importdata(sprintf('/bess19/Yulin/BESSv2/Reprojection/%d%03d/Terra_proj.%s.mat',year,doy,swaths{i}));
            msk = proj.msk;
            pid = proj.pid;
        
            raw = importdata(sprintf('/bess19/Yulin/BESSv2/Swath/MOD_SZA/%d%03d/MOD_SZA.%d%03d.%s.mat',year,doy,year,doy,swaths{i}));
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
        
            raw = importdata(sprintf('/bess19/Yulin/BESSv2/Swath/MOD_VZA/%d%03d/MOD_VZA.%d%03d.%s.mat',year,doy,year,doy,swaths{i}));
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
	mkdir('/bess19/Yulin/BESSv2/VZA_MOD');
    save(sprintf('/bess19/Yulin/BESSv2/VZA_MOD/VZA_MOD.%d.%03d.mat',year,doy),'data');
     
    % % CF
    CF = nan(height,width,'single');
    for i = 1:length(swaths)
        try
            proj = importdata(sprintf('/bess19/Yulin/BESSv2/Reprojection/%d%03d/Terra_proj.%s.mat',year,doy,swaths{i}));
            msk = proj.msk;
            pid = proj.pid;
        
            raw = importdata(sprintf('/bess19/Yulin/BESSv2/Swath/MOD_CF/%d%03d/MOD_CF.%d%03d.%s.mat',year,doy,year,doy,swaths{i}));
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
     
    % % COT
    COT = nan(height,width,'single');
    for i = 1:length(swaths)
        try
            proj = importdata(sprintf('/bess19/Yulin/BESSv2/Reprojection/%d%03d/Terra_proj.%s.mat',year,doy,swaths{i}));
            msk = proj.msk;
            pid = proj.pid;
   
            raw = importdata(sprintf('/bess19/Yulin/BESSv2/Swath/MOD_COT/%d%03d/MOD_COT.%d%03d.%s.mat',year,doy,year,doy,swaths{i}));
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
	mkdir('/bess19/Yulin/BESSv2/COT_MOD');
    save(sprintf('/bess19/Yulin/BESSv2/COT_MOD/COT_MOD.%d.%03d.mat',year,doy),'data');
  