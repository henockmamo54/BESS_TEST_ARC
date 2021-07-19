clear all
%addpath('/bess19/blli/bess/src/Debug');
path0 = '/bess19/Yulin/BESSv2';
path1 = '/bess21/blli/bess';
path = '/bess19/blli/bess';
opath = '/bess22/Henock'; % output data directory
warning('off', 'MATLAB:MKDIR:DirectoryExists');

%%mkdir LST_AM LST_PM
vars = {'LST_AM^','LST_PM^','Ts_AM^','Ts_PM^'};
for i = 1:length(vars)
    ds = vars{i};
    if ~exist(sprintf('%s/%s',opath,ds))
        mkdir(sprintf('%s/%s',opath,ds))
    end
end

MSK005d = importdata('/bess/JCY/BESSv2/Ancillary/Landmask.005d.mat');
MSK30s = importdata('/bess/JCY/BESSv2/Ancillary/Landmask.30s.mat');

years = 2020;
months = 4:5;
    
for year = years
    for month = months
           
        DATA005d = nan(size(MSK005d),'single');
        DATA30s = nan(size(MSK30s),'single');
        
        OverpassMOD = importdata(sprintf('%s/Ancillary/OverpassMOD.005d.mat',path));       
        DATA005d(MSK005d) = OverpassMOD;
        DATA30s = imresize(DATA005d,6,'nearest'); 
        OverpassMOD = DATA30s(MSK30s);
        OverpassMYD = importdata(sprintf('%s/Ancillary/OverpassMYD.005d.mat',path));
        DATA005d(MSK005d) = OverpassMYD;
        DATA30s = imresize(DATA005d,6,'nearest'); 
        OverpassMYD = DATA30s(MSK30s);
        LAT = importdata(sprintf('%s/Ancillary/LAT.30s.mat',path));
        ALT = importdata(sprintf('%s/Ancillary/ALT.30s.mat',path));
        Climate = importdata(sprintf('%s/Ancillary/Climate.30s.mat',path));
        hc = importdata(sprintf('%s/Ancillary/hc.30s.mat',path));                      
        %fC4 = importdata(sprintf('%s/Ancillary/fC4InVeg.005d.mat',path0)); 
        fC4InCrop = importdata(sprintf('%s/Ancillary/Maize.005d.mat',path0)); 
        DATA005d(MSK005d) = fC4InCrop;
        DATA30s = imresize(DATA005d,6,'nearest'); 
        fC4InCrop = DATA30s(MSK30s);                                 
        fC4InGrass = importdata('/bess19/blli/bess/Ancillary/fC4InGrass.005d.mat'); 
        fC4InGrass(fC4InGrass<0) = 0;  
        DATA005d(MSK005d) = fC4InGrass;
        DATA30s = imresize(DATA005d,6,'nearest'); 
        fC4InGrass = DATA30s(MSK30s);                          
        %Water = importdata(sprintf('%s/Ancillary/Water.30s.mat',path0)); 
        OCD05 = importdata('/bess19/blli/bess/SoilGrids/ocd_0-5cm_mean.005d.mat')./10; %unit:kg/m3
        OCD515 = importdata('/bess19/blli/bess/SoilGrids/ocd_5-15cm_mean.005d.mat')./10; %unit:kg/m3
        OCS = (OCD05*0.05+OCD515*0.1); %unit:kg/m2      
        DATA005d(MSK005d) = OCS;
        DATA30s = imresize(DATA005d,6,'nearest'); 
        OCS = DATA30s(MSK30s);                      
        
        sprintf('%s/LC_MCD12Q1/LC_MCD12Q1.%d.mat',path,year)
        IGBP = importdata(sprintf('%s/LC_MCD12Q1/LC_MCD12Q1.%d.mat',path,year));
        IGBP11 = importdata(sprintf('%s/LC11_MCD12Q1/LC11_MCD12Q1.%d.mat',path,year));
        %IGBP = importdata(sprintf('/bess19/Yulin/BESSv2/LC_MCD12C1/LC_MCD12C1.%d.mat',year));                            
        FNonVeg = importdata(sprintf('%s/FNonVeg_Trended/FNonVeg_Trended.%d.mat',path,year));
        fTree = importdata(sprintf('%s/FTree_Trended/FTree_Trended.%d.mat',path,year));
        kn = importdata(sprintf('%s/kn^_backup/kn^_backup.%d.mat',path,year));        
        DATA005d(MSK005d) = kn;
        DATA30s = imresize(DATA005d,6,'nearest'); 
        kn = DATA30s(MSK30s);                  
        
        CI = importdata(sprintf('%s/CI^_Clim/CI^_Clim.%02d.mat',path0,month));
        DATA005d(MSK005d) = CI;
        DATA30s = imresize(DATA005d,6,'nearest'); 
        CI = DATA30s(MSK30s);
        v = importdata(sprintf('%s/v_Clim/v_Clim.%02d.mat',path0,month));
        DATA005d(MSK005d) = v;
        DATA30s = imresize(DATA005d,6,'nearest'); 
        v = DATA30s(MSK30s);

        fC4 = zeros(size(IGBP),'single');
        fC4(IGBP==10) = fC4InCrop(IGBP==10);
        fC4(IGBP~=10) = fC4InGrass(IGBP~=10);
        fC4(IGBP==7) = fC4InGrass(IGBP==7).*(1-fTree(IGBP==7));
        fC4(IGBP==9) = fC4InGrass(IGBP==9).*0.55;                        
        fC4(IGBP<7|IGBP>10) = 0;        
        mskC4 = fC4>0;
        fC4(~mskC4) = 0;
        hc(isnan(hc)&(IGBP<=5|IGBP==7)) = 10;
        hc(hc==0|(IGBP>5&IGBP~=7)) = 1;        
        hc(fC4>0.5) = 2;
        
        m_C3 = nan(size(Climate),'single');
        m_C3(Climate<4) = 9.5;
        m_C3(Climate>=4) = 7.5;
        m_C3(IGBP==8|IGBP==10)  = 13.5;
        m_C4 = nan(size(Climate),'single');
        m_C4(:) = 5;
        m_C4(IGBP==8) = 4.1;
        m_C4(IGBP==10) = 5.8;       
        
        b0_C3 = nan(size(Climate),'single');
        b0_C3(:) = 0.005;
        b0_C3(IGBP==8)= 0.010;
        b0_C3(IGBP==10)= 0.015;
        b0_C4 = nan(size(Climate),'single');
        b0_C4(:) = 0.04;             

        Ca = importdata(sprintf('%s/Ca/Ca.%d.%02d.mat',path0,year,month)); 
        DATA005d(MSK005d) = Ca;
        DATA30s = imresize(DATA005d,6,'nearest'); 
        Ca = DATA30s(MSK30s);

        GPP_ = nan(311724940,31,'single'); %8774037 for 0.05d
        LE_ = nan(311724940,31,'single');
        ET_ = nan(311724940,31,'single');
        PET_ = nan(311724940,31,'single');
        Rn_ = nan(311724940,31,'single');
 
        for day = 1:31
            vec = datevec(datenum(year,month,day));
            if vec(2) == month
                doy = datenum(year,month,day) - datenum(year,1,1) + 1;
                disp(sprintf('BESS Flux, %d%03d',year,doy));
    
                SZAAM = importdata(sprintf('%s/SZA_AM/SZA_AM.%03d.mat',path0,doy));
                DATA005d(MSK005d) = SZAAM;
                DATA30s = imresize(DATA005d,6,'nearest'); 
                SZAAM = DATA30s(MSK30s);
                SZAPM = importdata(sprintf('%s/SZA_PM/SZA_PM.%03d.mat',path0,doy));    
                DATA005d(MSK005d) = SZAPM;
                DATA30s = imresize(DATA005d,6,'nearest'); 
                SZAPM = DATA30s(MSK30s);
                LAI = importdata(sprintf('/bess22/blli/bess/LAI_Daily/LAI_Daily.%d.%03d.mat',year,doy));   
                RVIS = importdata(sprintf('/bess22/blli/bess/RVIS_Daily/RVIS_Daily.%d.%03d.mat',year,doy));
                RVIS = single(RVIS)./10000;
                RNIR = importdata(sprintf('/bess22/blli/bess/RNIR_Daily/RNIR_Daily.%d.%03d.mat',year,doy));
                RNIR = single(RNIR)./10000;
                RSW = importdata(sprintf('/bess22/blli/bess/RSW_Daily/RSW_Daily.%d.%03d.mat',year,doy));
                RSW = single(RSW)./10000;
 
                try
                    RgDaily = importdata(sprintf('%s/Rg_Daily/Rg_Daily.%d.%03d.mat',path0,year,doy)); 
                    %RgDaily = importdata(sprintf('/environment/Chongya/Radiation/Rg_Daily/Rg_Daily.%d.%03d.mat',year,doy));
                    DATA005d(MSK005d) = RgDaily;
                    DATA30s = imresize(DATA005d,6,'nearest'); 
                    RgDaily = DATA30s(MSK30s);
                catch
                    try
                        %RgDaily = importdata(sprintf('%s/Rg_Daily/Rg_Daily.%d.%03d.mat',path,year,doy)); 
                        RgDaily = importdata(sprintf('/bess/JCY/Radiation/Rg_Daily/Rg_Daily.%d.%03d.mat',year,doy)); 
                        DATA005d(MSK005d) = RgDaily;
                        DATA30s = imresize(DATA005d,6,'nearest'); 
                        RgDaily = DATA30s(MSK30s);
                    catch
                        RgDaily = importdata(sprintf('%s/Rs_Daily/Rs_Daily.%d.%03d.mat',path1,year,doy)); 
                        %RgDaily = importdata(sprintf('/bess/JCY/BESSv2/Rs_Daily/Rs_Daily.%d.%03d.mat',year,doy)); 
                        DATA005d(MSK005d) = RgDaily;
                        DATA30s = imresize(DATA005d,6,'nearest'); 
                        RgDaily = DATA30s(MSK30s);
                    end
                end
                TaDaily = importdata(sprintf('%s/Ta_Daily/Ta_Daily.%d.%03d.mat',path1,year,doy)); 
                DATA005d(MSK005d) = TaDaily;
                DATA30s = imresize(DATA005d,6,'nearest'); 
                TaDaily = DATA30s(MSK30s);
                TdDaily = importdata(sprintf('%s/Td_Daily/Td_Daily.%d.%03d.mat',path1,year,doy)); 
                DATA005d(MSK005d) = TdDaily;
                DATA30s = imresize(DATA005d,6,'nearest'); 
                TdDaily = DATA30s(MSK30s);
                          
                RgAM = importdata(sprintf('%s/Rg_AM/Rg_AM.%d.%03d.mat',path,year,doy));
                DATA005d(MSK005d) = RgAM;
                DATA30s = imresize(DATA005d,6,'nearest'); 
                RgAM = DATA30s(MSK30s);
                RgPM = importdata(sprintf('%s/Rg_PM/Rg_PM.%d.%03d.mat',path,year,doy));
                DATA005d(MSK005d) = RgPM;
                DATA30s = imresize(DATA005d,6,'nearest'); 
                RgPM = DATA30s(MSK30s);
                UVAM = importdata(sprintf('%s/UV_AM/UV_AM.%d.%03d.mat',path,year,doy));
                DATA005d(MSK005d) = UVAM;
                DATA30s = imresize(DATA005d,6,'nearest'); 
                UVAM = DATA30s(MSK30s);
                UVPM = importdata(sprintf('%s/UV_PM/UV_PM.%d.%03d.mat',path,year,doy));
                DATA005d(MSK005d) = UVPM;
                DATA30s = imresize(DATA005d,6,'nearest'); 
                UVPM = DATA30s(MSK30s);
                PARDirAM = importdata(sprintf('%s/PARDir_AM/PARDir_AM.%d.%03d.mat',path,year,doy));
                DATA005d(MSK005d) = PARDirAM;
                DATA30s = imresize(DATA005d,6,'nearest'); 
                PARDirAM = DATA30s(MSK30s);
                PARDirPM = importdata(sprintf('%s/PARDir_PM/PARDir_PM.%d.%03d.mat',path,year,doy));
                DATA005d(MSK005d) = PARDirPM;
                DATA30s = imresize(DATA005d,6,'nearest'); 
                PARDirPM = DATA30s(MSK30s);
                PARDiffAM = importdata(sprintf('%s/PARDiff_AM/PARDiff_AM.%d.%03d.mat',path,year,doy));
                DATA005d(MSK005d) = PARDiffAM;
                DATA30s = imresize(DATA005d,6,'nearest'); 
                PARDiffAM = DATA30s(MSK30s);
                PARDiffPM = importdata(sprintf('%s/PARDiff_PM/PARDiff_PM.%d.%03d.mat',path,year,doy));
                DATA005d(MSK005d) = PARDiffPM;
                DATA30s = imresize(DATA005d,6,'nearest'); 
                PARDiffPM = DATA30s(MSK30s);
                NIRDirAM = importdata(sprintf('%s/NIRDir_AM/NIRDir_AM.%d.%03d.mat',path,year,doy));
                DATA005d(MSK005d) = NIRDirAM;
                DATA30s = imresize(DATA005d,6,'nearest'); 
                NIRDirAM = DATA30s(MSK30s);
                NIRDirPM = importdata(sprintf('%s/NIRDir_PM/NIRDir_PM.%d.%03d.mat',path,year,doy));
                DATA005d(MSK005d) = NIRDirPM;
                DATA30s = imresize(DATA005d,6,'nearest'); 
                NIRDirPM = DATA30s(MSK30s);
                NIRDiffAM = importdata(sprintf('%s/NIRDiff_AM/NIRDiff_AM.%d.%03d.mat',path,year,doy));
                DATA005d(MSK005d) = NIRDiffAM;
                DATA30s = imresize(DATA005d,6,'nearest'); 
                NIRDiffAM = DATA30s(MSK30s);
                NIRDiffPM = importdata(sprintf('%s/NIRDiff_PM/NIRDiff_PM.%d.%03d.mat',path,year,doy));
                DATA005d(MSK005d) = NIRDiffPM;
                DATA30s = imresize(DATA005d,6,'nearest'); 
                NIRDiffPM = DATA30s(MSK30s);
                TaAM = importdata(sprintf('%s/Ta_AM/Ta_AM.%d.%03d.mat',path1,year,doy));
                DATA005d(MSK005d) = TaAM;
                DATA30s = imresize(DATA005d,6,'nearest'); 
                TaAM = DATA30s(MSK30s);
                TaPM = importdata(sprintf('%s/Ta_PM/Ta_PM.%d.%03d.mat',path1,year,doy));
                DATA005d(MSK005d) = TaPM;
                DATA30s = imresize(DATA005d,6,'nearest'); 
                TaPM = DATA30s(MSK30s);
                TdAM = importdata(sprintf('%s/Td_AM/Td_AM.%d.%03d.mat',path1,year,doy));
                DATA005d(MSK005d) = TdAM;
                DATA30s = imresize(DATA005d,6,'nearest'); 
                TdAM = DATA30s(MSK30s);
                TdPM = importdata(sprintf('%s/Td_PM/Td_PM.%d.%03d.mat',path1,year,doy));
                DATA005d(MSK005d) = TdPM;
                DATA30s = imresize(DATA005d,6,'nearest'); 
                TdPM = DATA30s(MSK30s);
                TaLag = importdata(sprintf('%s/Ta_Lag40/Ta_Lag40.%d.%03d.mat',path1,year,doy));          
                DATA005d(MSK005d) = TaLag;
                DATA30s = imresize(DATA005d,6,'nearest'); 
                TaLag = DATA30s(MSK30s); 
                PAR_Daily = importdata(sprintf('%s/PAR_Daily/PAR_Daily.%d.%03d.mat',path0,year,doy));     
                DATA005d(MSK005d) = PAR_Daily;
                DATA30s = imresize(DATA005d,6,'nearest'); 
                PAR_Daily = DATA30s(MSK30s);                            

                % Intrinsic quantum yield (Jiang et al. 2020)
                alf = 0.352 + 0.022.*(TaLag-273.16) - 0.00034.*(TaLag-273.16).^2;
                alf = alf .* 1 .* 0.5 ./ 4; 
                % constraint
                alf(alf>0.08&IGBP~=10) = 0.08;
                alf(alf>0.07&IGBP==2&Climate<=2) = 0.07;
                alf(alf<0) = 0;     
                                
                Vcmax25 = importdata(sprintf('%s/Vcmax25/Vcmax25/Vcmax25.%d.%03d.mat',path,year,doy));
                DATA005d(MSK005d) = Vcmax25;
                DATA30s = imresize(DATA005d,6,'nearest'); 
                Vcmax25 = DATA30s(MSK30s);

                Vcmax25_C3Leaf = Vcmax25;
                Vcmax25_C4Leaf = Vcmax25_C3Leaf;
                Vcmax25_C4Leaf(:) = 22; %27 %27*0.8
                Vcmax25_C4Leaf(IGBP==10) = 30; %37 %33*0.8             

                for k = 1:2 
                    if k == 1
                        Overpass = OverpassMOD;
                        Rg = RgAM;
                        UV = UVAM;
                        PARDir = PARDirAM;
                        PARDiff = PARDiffAM;
                        NIRDir = NIRDirAM;
                        NIRDiff = NIRDiffAM;
                        Ta = TaAM;
                        Td = TdAM;
                        SZA = SZAAM;
                    else
                        Overpass = OverpassMYD;
                        Rg = RgPM;
                        UV = UVPM;
                        PARDir = PARDirPM;
                        PARDiff = PARDiffPM;
                        NIRDir = NIRDirPM;
                        NIRDiff = NIRDiffPM;
                        Ta = TaPM;
                        Td = TdPM;
                        SZA = SZAPM;
                    end 
                    mskDay = SZA <= 89; 
                    mskNight = SZA > 89;
                    
                    [Ps, VPD, RH, desTa, ddesTa, gamma, Cp, rhoa, epsa, R, Rc, Rs, SFd, SFd2, DL, Ra, fStress] = m_Meteorology(doy, LAT, ALT, SZA, Overpass, Ta, Td, Rg, v, hc, LAI);
                 
                    NonVeg = LAI < 0.101;
                    LAI(NonVeg) = 0.1;  
                    fSun = zeros(size(LAT),'single');
                    APAR_Sun = zeros(size(LAT),'single');
                    APAR_Sh = zeros(size(LAT),'single');
                    ASW_Sun = zeros(size(LAT),'single');
                    ASW_Sh = zeros(size(LAT),'single');
                    ASW_Soil = zeros(size(LAT),'single');
                    G = zeros(size(LAT),'single');
                    Vcmax25_C3Sun = zeros(size(LAT),'single');
                    Vcmax25_C3Sh = zeros(size(LAT),'single');
                    Vcmax25_C4Sun = zeros(size(LAT),'single');
                    Vcmax25_C4Sh = zeros(size(LAT),'single');
                    msk = mskDay & isfinite(RVIS) & isfinite(RNIR);
                    [fSun0, APAR_Sun0, APAR_Sh0, ASW_Sun0, ASW_Sh0, ASW_Soil0, G0, Vcmax25_C3Sun0, Vcmax25_C3Sh0, Vcmax25_C4Sun0, Vcmax25_C4Sh0] = m_CanopyShortwaveRadiation(Rg(msk), PARDiff(msk), PARDir(msk), NIRDiff(msk), NIRDir(msk), UV(msk), SZA(msk), LAI(msk), CI(msk), RVIS(msk), RNIR(msk), Vcmax25_C3Leaf(msk), Vcmax25_C4Leaf(msk), kn(msk)); 
                    fSun(msk) = fSun0;
                    APAR_Sun(msk) = APAR_Sun0;
                    APAR_Sh(msk) = APAR_Sh0;
                    ASW_Sun(msk) = ASW_Sun0;
                    ASW_Sh(msk) = ASW_Sh0;
                    ASW_Soil(msk) = ASW_Soil0;
                    G(msk) = G0;
                    Vcmax25_C3Sun(msk) = Vcmax25_C3Sun0;
                    Vcmax25_C3Sh(msk) = Vcmax25_C3Sh0;
                    Vcmax25_C4Sun(msk) = Vcmax25_C4Sun0;
                    Vcmax25_C4Sh(msk) = Vcmax25_C4Sh0;
                    
                    GPP = zeros(size(LAT),'single');
                    LE = zeros(size(LAT),'single'); 
                    Rn = zeros(size(LAT),'single'); 
                    LST = zeros(size(LAT),'single'); 
                    Ts = zeros(size(LAT),'single'); 
                    LE_Soil = zeros(size(LAT),'single');                                         
                    msk = mskDay & isfinite(RVIS) & isfinite(RNIR);
                    [GPP0, LE0, Rn0, Gs0, LST0, Ts0, LE_Soil0] = m_CarbonWaterFluxes(APAR_Sun(msk), APAR_Sh(msk), ASW_Sun(msk), ASW_Sh(msk), Vcmax25_C3Sun(msk), Vcmax25_C3Sh(msk), m_C3(msk), b0_C3(msk), fSun(msk), ASW_Soil(msk), G(msk), SZA(msk), LAI(msk), CI(msk), Ca(msk), Ps(msk), Ta(msk), gamma(msk), Cp(msk), rhoa(msk), VPD(msk), RH(msk), desTa(msk), ddesTa(msk), epsa(msk), Rc(msk), Rs(msk), alf(msk), fStress(msk), FNonVeg(msk),false);
                    GPP(msk) = GPP0;
                    LE(msk) = LE0;
                    Rn(msk) = Rn0;
                    LST(msk) = LST0;
                    Ts(msk) = Ts0;
                    LE_Soil(msk) = LE_Soil0;
                    msk = mskDay & isfinite(RVIS) & isfinite(RNIR) & mskC4;
                    [GPP0, LE0, Rn0, Gs0, LST0, Ts0, LE_Soil0] = m_CarbonWaterFluxes(APAR_Sun(msk), APAR_Sh(msk), ASW_Sun(msk), ASW_Sh(msk), Vcmax25_C4Sun(msk), Vcmax25_C4Sh(msk), m_C4(msk), b0_C4(msk), fSun(msk), ASW_Soil(msk), G(msk), SZA(msk), LAI(msk), CI(msk), Ca(msk), Ps(msk), Ta(msk), gamma(msk), Cp(msk), rhoa(msk), VPD(msk), RH(msk), desTa(msk), ddesTa(msk), epsa(msk), Rc(msk), Rs(msk), alf(msk), fStress(msk), FNonVeg(msk),true);
                    GPP(msk) = GPP(msk).*(1-fC4(msk)) + GPP0.*fC4(msk);
                    LE(msk) = LE(msk).*(1-fC4(msk)) + LE0.*fC4(msk);
                    Rn(msk) = Rn(msk).*(1-fC4(msk)) + Rn0.*fC4(msk);
                    LST(msk) = LST(msk).*(1-fC4(msk)) + LST0.*fC4(msk);
                    Ts(msk) = Ts(msk).*(1-fC4(msk)) + Ts0.*fC4(msk);
                    LE_Soil(msk) = LE_Soil(msk).*(1-fC4(msk)) + LE_Soil0.*fC4(msk);                                        
                    
                    msk = NonVeg;
                    [ LE0, Rn0, LST0, Ts0] = m_NonVeg(G(msk), Rg(msk), RSW(msk), Ta(msk), RH(msk), VPD(msk), desTa(msk), gamma(msk), epsa(msk), Cp(msk), rhoa(msk), R(msk));
                    GPP(msk) = 0;
                    LE(msk) = LE0;  
                    Rn(msk) = Rn0;  
                    LST(msk) = LST0;
                    Ts(msk) = Ts0;
                    LE_Soil(msk) = LE0;                                                                                
                     
                    msk = isnan(ALT);
                    GPP(msk) = nan;
                    LE(msk) = nan;
                    Rn(msk) = nan;
                    LE_Soil(msk) = nan;                                                            
                    
                    %msk = Water;
                    msk = IGBP == 0;                                                                                
                    [LE0,Rn0] = m_Water(doy, LAT(msk), ALT(msk), TaDaily(msk), TdDaily(msk), RgDaily(msk), RSW(msk), v(msk));
                    GPP(msk) = 0;
                    LE(msk) = LE0;  
                    Rn(msk) = Rn0;  
                    % Ts(msk) = nan;
                    LE_Soil(msk) = 0; 
                    
                    msk = mskNight;
                    GPP(msk) = 0;
                    LE(msk) = 0;
                    Rn(msk) = 0;
                    LE_Soil(msk) = 0;                                         
                     
                    if k == 1
                        GPP_MOD = 1800 * GPP ./ SFd * 12*1e-6;
                        LE_MOD = 1800 * LE ./ SFd * 1e-6;
                        LE_Soil_MOD = 1800 * LE_Soil ./ SFd * 1e-6;
                        Rn_MOD = Rn .* SFd2 * 60*60*24*1e-6;     
                        APAR_AM = (APAR_Sun + APAR_Sh) / 4.56; 
                        FPAR_AM = APAR_AM ./ (PARDirAM + PARDiffAM);                                     
                        GPP_MOD(GPP_MOD>30) = nan;
                        LE_MOD(LE_MOD>25) = nan;
                        Rn_MOD(Rn_MOD>25) = nan;
                        Rn_MOD(Rn_MOD<-25) = nan;
                        data = LST; save(sprintf('%s/LST_AM^/LST_AM^.%d.%03d.mat',opath,year,doy),'data');
                        data = Ts; save(sprintf('%s/Ts_AM^/Ts_AM^.%d.%03d.mat',opath,year,doy),'data');
                    else
                        GPP_MYD = 1800 * GPP ./ SFd * 12*1e-6;
                        LE_MYD = 1800 * LE ./ SFd * 1e-6;
                        LE_Soil_MYD = 1800 * LE_Soil ./ SFd * 1e-6;
                        Rn_MYD = Rn .* SFd2 * 60*60*24*1e-6; 
                        APAR_PM = (APAR_Sun + APAR_Sh) / 4.56;
                        FPAR_PM = APAR_PM ./ (PARDirPM + PARDiffPM);                        
                        GPP_MYD(GPP_MYD>30) = nan;
                        LE_MYD(LE_MYD>25) = nan;
                        Rn_MYD(Rn_MYD>25) = nan;
                        Rn_MYD(Rn_MYD<-25) = nan;
                        data = LST; save(sprintf('%s/LST_PM^/LST_PM^.%d.%03d.mat',opath,year,doy),'data');
                        data = Ts; save(sprintf('%s/Ts_PM^/Ts_PM^.%d.%03d.mat',opath,year,doy),'data');
                    end
                end  
          
                GPP_Daily = nanmean(cat(2,GPP_MOD,GPP_MYD),2);
                LE_Daily = nanmean(cat(2,LE_MOD,LE_MYD),2);
                LE_Soil_Daily = nanmean(cat(2,LE_Soil_MOD,LE_Soil_MYD),2);
                Rn_Daily = nanmean(cat(2,Rn_MOD,Rn_MYD),2); 
                %APAR_Daily = nanmean(cat(2,APAR_MOD,APAR_MYD),2); 
                %PARDir_Daily = nanmean(cat(2,PARDirAM,PARDirPM),2);
                %PARDiff_Daily = nanmean(cat(2,PARDiffAM,PARDiffPM),2);
                %FPAR_Daily = APAR_Daily ./ (PARDir_Daily + PARDiff_Daily);
                FPAR_Daily = nanmean(cat(2,FPAR_AM,FPAR_PM),2);                
                % Constraints
                FPAR_Daily(FPAR_Daily<0) = 0;
                FPAR_Daily(FPAR_Daily>1) = 1;
                APAR_Daily = PAR_Daily .* FPAR_Daily;                 
                
                [LE_Daily, ET_Daily, PET_Daily, Es_Daily, RECO_Daily, NEE_Daily] = m_Byproduct_update(GPP_Daily, LE_Daily, LE_Soil_Daily, Rn_Daily, TaDaily, ALT, IGBP11, OCS);                

                data = GPP_Daily; mkdir(sprintf('%s/GPP_Daily^/',opath)); save(sprintf('%s/GPP_Daily^/GPP_Daily^.%d.%03d.mat',opath,year,doy),'data','-v7.3');
                data = LE_Daily; mkdir(sprintf('%s/LE_Daily^/',opath)); save(sprintf('%s/LE_Daily^/LE_Daily^.%d.%03d.mat',opath,year,doy),'data','-v7.3');
                data = ET_Daily; mkdir(sprintf('%s/ET_Daily^/',opath)); save(sprintf('%s/ET_Daily^/ET_Daily^.%d.%03d.mat',opath,year,doy),'data','-v7.3');
                data = PET_Daily; mkdir(sprintf('%s/PET_Daily^/',opath)); save(sprintf('%s/PET_Daily^/PET_Daily^.%d.%03d.mat',opath,year,doy),'data','-v7.3');
                data = Rn_Daily; mkdir(sprintf('%s/Rn_Daily^/',opath)); save(sprintf('%s/Rn_Daily^/Rn_Daily^.%d.%03d.mat',opath,year,doy),'data','-v7.3');
                %data = FPAR_Daily; mkdir(sprintf('%s/FPAR_Daily^/',opath)); save(sprintf('%s/FPAR_Daily^/FPAR_Daily^.%d.%03d.mat',opath,year,doy),'data','-v7.3'); 
                data = APAR_Daily; mkdir(sprintf('%s/APAR_Daily^/',opath)); save(sprintf('%s/APAR_Daily^/APAR_Daily^.%d.%03d.mat',opath,year,doy),'data','-v7.3');    
                data = Es_Daily; mkdir(sprintf('%s/Es_Daily^/',opath)); save(sprintf('%s/Es_Daily^/Es_Daily^.%d.%03d.mat',opath,year,doy),'data','-v7.3'); 
                data = RECO_Daily; mkdir(sprintf('%s/RECO_Daily^/',opath)); save(sprintf('%s/RECO_Daily^/RECO_Daily^.%d.%03d.mat',opath,year,doy),'data','-v7.3');
                data = NEE_Daily; mkdir(sprintf('%s/NEE_Daily^/',opath)); save(sprintf('%s/NEE_Daily^/NEE_Daily^.%d.%03d.mat',opath,year,doy),'data','-v7.3');            
                
                GPP_(:,day) = GPP_Daily;
                LE_(:,day) = LE_Daily;
                ET_(:,day) = ET_Daily;
                PET_(:,day) = PET_Daily;
                Rn_(:,day) = Rn_Daily;
                APAR_(:,day) = APAR_Daily;
                Es_(:,day) = Es_Daily;
                RECO_(:,day) = RECO_Daily;
                NEE_(:,day) = NEE_Daily;
                
                GPP_(:,day) = importdata(sprintf('%s/GPP_Daily^/GPP_Daily^.%d.%03d.mat',opath,year,doy));
                LE_(:,day) = importdata(sprintf('%s/LE_Daily^/LE_Daily^.%d.%03d.mat',opath,year,doy));
                ET_(:,day) = importdata(sprintf('%s/ET_Daily^/ET_Daily^.%d.%03d.mat',opath,year,doy));
                PET_(:,day) = importdata(sprintf('%s/PET_Daily^/PET_Daily^.%d.%03d.mat',opath,year,doy));
                Rn_(:,day) = importdata(sprintf('%s/Rn_Daily^/Rn_Daily^.%d.%03d.mat',opath,year,doy));
                APAR_(:,day) = importdata(sprintf('%s/APAR_Daily^/APAR_Daily^.%d.%03d.mat',opath,year,doy));
                Es_(:,day) = importdata(sprintf('%s/Es_Daily^/Es_Daily^.%d.%03d.mat',opath,year,doy));
                RECO_(:,day) = importdata(sprintf('%s/RECO_Daily^/RECO_Daily^.%d.%03d.mat',opath,year,doy));
                NEE_(:,day) = importdata(sprintf('%s/NEE_Daily^/NEE_Daily^.%d.%03d.mat',opath,year,doy));
            end
        end
          
         data = nanmean(GPP_,2);
		 mkdir(sprintf('%s/GPP_Monthly^/',opath));
         save(sprintf('%s/GPP_Monthly^/GPP_Monthly^.%d.%02d.mat',opath,year,month),'data','-v7.3');
         data = nanmean(LE_,2);
		 mkdir(sprintf('%s/LE_Monthly^/',opath));
         save(sprintf('%s/LE_Monthly^/LE_Monthly^.%d.%02d.mat',opath,year,month),'data','-v7.3');
         data = nanmean(ET_,2);
		 mkdir(sprintf('%s/ET_Monthly^/',opath));
         save(sprintf('%s/ET_Monthly^/ET_Monthly^.%d.%02d.mat',opath,year,month),'data','-v7.3');
         data = nanmean(PET_,2);
		 mkdir(sprintf('%s/PET_Monthly^/',opath));
         save(sprintf('%s/PET_Monthly^/PET_Monthly^.%d.%02d.mat',opath,year,month),'data','-v7.3');
         data = nanmean(Rn_,2);
		 mkdir(sprintf('%s/Rn_Monthly^/',opath));
         save(sprintf('%s/Rn_Monthly^/Rn_Monthly^.%d.%02d.mat',opath,year,month),'data','-v7.3');
         data = nanmean(APAR_,2);
		 mkdir(sprintf('%s/APAR_Monthly^/',opath));
         save(sprintf('%s/APAR_Monthly^/APAR_Monthly^.%d.%02d.mat',opath,year,month),'data','-v7.3');     
         data = nanmean(Es_,2);
		 mkdir(sprintf('%s/Es_Monthly^/',opath));
         save(sprintf('%s/Es_Monthly^/Es_Monthly^.%d.%02d.mat',opath,year,month),'data','-v7.3');   
         data = nanmean(RECO_,2);
		 mkdir(sprintf('%s/RECO_Monthly^/',opath));
         save(sprintf('%s/RECO_Monthly^/RECO_Monthly^.%d.%02d.mat',opath,year,month),'data','-v7.3'); 
         data = nanmean(NEE_,2);
		 mkdir(sprintf('%s/NEE_Monthly^/',opath));
         save(sprintf('%s/NEE_Monthly^/NEE_Monthly^.%d.%02d.mat',opath,year,month),'data','-v7.3'); 
     end    
          
     series = nan(8774037,12,'single');
     for month = 1:12
         series(:,month) = importdata(sprintf('%s/GPP_Monthly^/GPP_Monthly^.%d.%02d.mat',opath,year,month));
     end
     data = nanmean(series,2);
	 mkdir(sprintf('%s/GPP_Annual^/',opath));
     save(sprintf('%s/GPP_Annual^/GPP_Annual^.%d.mat',opath,year),'data','-v7.3');
     for month = 1:12
         series(:,month) = importdata(sprintf('%s/LE_Monthly^/LE_Monthly^.%d.%02d.mat',opath,year,month));
     end
     data = nanmean(series,2);
	 mkdir(sprintf('%s/LE_Annual^/',opath));
     save(sprintf('%s/LE_Annual^/LE_Annual^.%d.mat',opath,year),'data','-v7.3');
     for month = 1:12
         series(:,month) = importdata(sprintf('%s/ET_Monthly^/ET_Monthly^.%d.%02d.mat',opath,year,month));
     end
     data = nanmean(series,2);
	 mkdir(sprintf('%s/ET_Annual^/',opath));
     save(sprintf('%s/ET_Annual^/ET_Annual^.%d.mat',opath,year),'data','-v7.3');
     for month = 1:12
         series(:,month) = importdata(sprintf('%s/PET_Monthly^/PET_Monthly^.%d.%02d.mat',opath,year,month));
     end
     data = nanmean(series,2);
	 mkdir(sprintf('%s/PET_Annual^/',opath));
     save(sprintf('%s/PET_Annual^/PET_Annual^.%d.mat',opath,year),'data','-v7.3');
     for month = 1:12
         series(:,month) = importdata(sprintf('%s/Rn_Monthly^/Rn_Monthly^.%d.%02d.mat',opath,year,month));
     end
     data = nanmean(series,2);
	 mkdir(sprintf('%s/Rn_Annual^/',opath));
     save(sprintf('%s/Rn_Annual^/Rn_Annual^.%d.mat',opath,year),'data','-v7.3');
     for month = 1:12
         series(:,month) = importdata(sprintf('%s/APAR_Monthly^/APAR_Monthly^.%d.%02d.mat',opath,year,month));
     end
     data = nanmean(series,2);
	 mkdir(sprintf('%s/APAR_Annual^/',opath));
     save(sprintf('%s/APAR_Annual^/APAR_Annual^.%d.mat',opath,year),'data','-v7.3');                          
     for month = 1:12
         series(:,month) = importdata(sprintf('%s/Es_Monthly^/Es_Monthly^.%d.%02d.mat',opath,year,month));
     end
     data = nanmean(series,2);
	 mkdir(sprintf('%s/Es_Annual^/',opath));
     save(sprintf('%s/Es_Annual^/Es_Annual^.%d.mat',opath,year),'data','-v7.3');
     for month = 1:12
         series(:,month) = importdata(sprintf('%s/RECO_Monthly^/RECO_Monthly^.%d.%02d.mat',opath,year,month));
     end
     data = nanmean(series,2);
	 mkdir(sprintf('%s/RECO_Annual^/',opath));
     save(sprintf('%s/RECO_Annual^/RECO_Annual^.%d.mat',opath,year),'data','-v7.3');
     for month = 1:12
         series(:,month) = importdata(sprintf('%s/NEE_Monthly^/NEE_Monthly^.%d.%02d.mat',opath,year,month));
     end
     data = nanmean(series,2);
	 mkdir(sprintf('%s/NEE_Annual^/',opath));
     save(sprintf('%s/NEE_Annual^/NEE_Annual^.%d.mat',opath,year),'data','-v7.3');                                        
         
 end   
