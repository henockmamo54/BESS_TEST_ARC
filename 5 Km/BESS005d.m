function BESS005d (year,month)
    years = double(year);  
	months = double(month);

%     years = 2020;
%     months = 8;
    
for year = years
    for month = months
     
        
            
        OverpassMOD = importdata('/bess19/Yulin/BESSv2/Ancillary/OverpassMOD.005d.mat');
        OverpassMYD = importdata('/bess19/Yulin/BESSv2/Ancillary/OverpassMYD.005d.mat');
        LAT = importdata('/bess19/Yulin/BESSv2/Ancillary/LAT.005d.mat');
        ALT = importdata('/bess19/Yulin/BESSv2/Ancillary/ALT.005d.mat');
        Climate = importdata('/bess19/Yulin/BESSv2/Ancillary/Climate.005d.mat');
        hc = importdata('/bess19/Yulin/BESSv2/Ancillary/hc.005d.mat');
        fC4 = importdata('/bess19/Yulin/BESSv2/Ancillary/fC4InVeg.005d.mat'); 
        fTreesInVeg = importdata('/bess19/Yulin/BESSv2/Ancillary/fTreesInVeg.005d.mat'); 
        fTreesInC3 = importdata('/bess19/Yulin/BESSv2/Ancillary/fTreesInC3.005d.mat'); 
        fCropsInC4 = importdata('/bess19/Yulin/BESSv2/Ancillary/fCropsInC4.005d.mat'); 
        Water = importdata('/bess19/Yulin/BESSv2/Ancillary/Water.005d.mat'); 
        
%         IGBP = importdata(sprintf('/bess19/Yulin/BESSv2/LC_MCD12C1/LC_MCD12C1.%d.mat',year));
        IGBP = importdata(sprintf('/bess19/Yulin/BESSv2/LC_MCD12C1/LC_MCD12C1.%d.mat',2019));
        
        FNonVeg = importdata(sprintf('/bess19/Yulin/BESSv2/FNonVeg^_Trended/FNonVeg^_Trended.%d.mat',year));
         
        CI = importdata(sprintf('/bess19/Yulin/BESSv2/CI^_Clim/CI^_Clim.%02d.mat',month));
        v = importdata(sprintf('/bess19/Yulin/BESSv2/v_Clim/v_Clim.%02d.mat',month));
        
        fC4(IGBP<7|IGBP>10) = 0;
        mskC4 = fC4>0;
        fC4(~mskC4) = 0;
        hc(isnan(hc)&(IGBP<=5|IGBP==7)) = 10;
        hc(hc==0|(IGBP>5&IGBP~=7)) = 1;        
        hc(fC4>0.5) = 2;

        alf = nan(size(ALT),'single');
        % forest types (Collatz et al. 1991; Singsaas et al., 2001)
        alf(:) = 0.08;    
        % tropical forest (Leuning, 1995; Mercado et al., 2009)
        alf(IGBP==2&Climate<=2) = 0.06;
        % non-forest types (Long et al. 1993; Kromdijk et al., 2016)
        alf(IGBP==10) = 0.09;
        
        kn = nan(size(Climate),'single');
        % non-crop types (Hikosaka et al., 2016)
        kn(:) = 0.41;    
        % tropical forest (Wu et al., 2018)
        kn(IGBP==2&Climate<=2) = 0.12;
        % crop types (DePury and Farquhar, 1997)
        kn(IGBP==10) = 0.71;
        
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

        Ca = importdata(sprintf('/bess19/Yulin/BESSv2/Ca/Ca.%d.%02d.mat',year,month)); 

        GPP_ = nan(8774037,31,'single');
        LE_ = nan(8774037,31,'single');
        ET_ = nan(8774037,31,'single');
        PET_ = nan(8774037,31,'single');
        Rn_ = nan(8774037,31,'single');
 
        for day = 1:31
            vec = datevec(datenum(year,month,day));
            if vec(2) == month
                doy = datenum(year,month,day) - datenum(year,1,1) + 1;
                disp(sprintf('BESS Flux, %d%03d',year,doy));
    
                SZAAM = importdata(sprintf('/bess19/Yulin/BESSv2/SZA_AM/SZA_AM.%03d.mat',doy));
                SZAPM = importdata(sprintf('/bess19/Yulin/BESSv2/SZA_PM/SZA_PM.%03d.mat',doy));    
                LAI = importdata(sprintf('/bess19/Yulin/BESSv2/LAI_Daily^/LAI_Daily^.%d.%03d.mat',year,doy));   
                RVIS = importdata(sprintf('/bess19/Yulin/BESSv2/RVIS_Daily^/RVIS_Daily^.%d.%03d.mat',year,doy));                 
                RNIR = importdata(sprintf('/bess19/Yulin/BESSv2/RNIR_Daily^/RNIR_Daily^.%d.%03d.mat',year,doy));
                RSW = importdata(sprintf('/bess19/Yulin/BESSv2/RSW_Daily^/RSW_Daily^.%d.%03d.mat',year,doy));
 
                try
                    RgDaily = importdata(sprintf('/bess19/Yulin/BESSv2/Rg_Daily/Rg_Daily.%d.%03d.mat',year,doy)); 
                catch
                    try
                        RgDaily = importdata(sprintf('/bess19/Yulin/BESSv2/Rg_Daily/Rg_Daily.%d.%03d.mat',year,doy)); 
                    catch
                        RgDaily = importdata(sprintf('/bess19/Yulin/BESSv2/Rs_Daily/Rs_Daily.%d.%03d.mat',year,doy)); 
                    end
                end
                TaDaily = importdata(sprintf('/bess19/Yulin/BESSv2/Ta_Daily/Ta_Daily.%d.%03d.mat',year,doy)); 
                TdDaily = importdata(sprintf('/bess19/Yulin/BESSv2/Td_Daily/Td_Daily.%d.%03d.mat',year,doy));                          
                RgAM = importdata(sprintf('/bess19/Yulin/BESSv2/Rg_AM/Rg_AM.%d.%03d.mat',year,doy)); 
                RgPM = importdata(sprintf('/bess19/Yulin/BESSv2/Rg_PM/Rg_PM.%d.%03d.mat',year,doy));                
                UVAM = importdata(sprintf('/bess19/Yulin/BESSv2/UV_AM/UV_AM.%d.%03d.mat',year,doy));
                UVPM = importdata(sprintf('/bess19/Yulin/BESSv2/UV_PM/UV_PM.%d.%03d.mat',year,doy));
                PARDirAM = importdata(sprintf('/bess19/Yulin/BESSv2/PARDir_AM/PARDir_AM.%d.%03d.mat',year,doy));
                PARDirPM = importdata(sprintf('/bess19/Yulin/BESSv2/PARDir_PM/PARDir_PM.%d.%03d.mat',year,doy));
                PARDiffAM = importdata(sprintf('/bess19/Yulin/BESSv2/PARDiff_AM/PARDiff_AM.%d.%03d.mat',year,doy));
                PARDiffPM = importdata(sprintf('/bess19/Yulin/BESSv2/PARDiff_PM/PARDiff_PM.%d.%03d.mat',year,doy));
                NIRDirAM = importdata(sprintf('/bess19/Yulin/BESSv2/NIRDir_AM/NIRDir_AM.%d.%03d.mat',year,doy));
                NIRDirPM = importdata(sprintf('/bess19/Yulin/BESSv2/NIRDir_PM/NIRDir_PM.%d.%03d.mat',year,doy));
                NIRDiffAM = importdata(sprintf('/bess19/Yulin/BESSv2/NIRDiff_AM/NIRDiff_AM.%d.%03d.mat',year,doy));
                NIRDiffPM = importdata(sprintf('/bess19/Yulin/BESSv2/NIRDiff_PM/NIRDiff_PM.%d.%03d.mat',year,doy));
                TaAM = importdata(sprintf('/bess19/Yulin/BESSv2/Ta_AM/Ta_AM.%d.%03d.mat',year,doy));
                TaPM = importdata(sprintf('/bess19/Yulin/BESSv2/Ta_PM/Ta_PM.%d.%03d.mat',year,doy));
                TdAM = importdata(sprintf('/bess19/Yulin/BESSv2/Td_AM/Td_AM.%d.%03d.mat',year,doy));
                TdPM = importdata(sprintf('/bess19/Yulin/BESSv2/Td_PM/Td_PM.%d.%03d.mat',year,doy));
                
                Vcmax25 = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax25/Vcmax25/Vcmax25.%d.%03d.mat',year,doy));

                Vcmax25_C3Leaf = Vcmax25;
                Vcmax25_C4Leaf = Vcmax25_C3Leaf;
                Vcmax25_C4Leaf(:) = 27; 
                Vcmax25_C4Leaf(IGBP==10) = 37;             

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
                    msk = mskDay & isfinite(RVIS) & isfinite(RNIR);
                    [GPP0, LE0, Rn0, Gs0, LST0] = m_CarbonWaterFluxes(APAR_Sun(msk), APAR_Sh(msk), ASW_Sun(msk), ASW_Sh(msk), Vcmax25_C3Sun(msk), Vcmax25_C3Sh(msk), m_C3(msk), b0_C3(msk), fSun(msk), ASW_Soil(msk), G(msk), SZA(msk), LAI(msk), CI(msk), Ca(msk), Ps(msk), Ta(msk), gamma(msk), Cp(msk), rhoa(msk), VPD(msk), RH(msk), desTa(msk), ddesTa(msk), epsa(msk), Rc(msk), Rs(msk), alf(msk), fStress(msk), FNonVeg(msk),false);
                    GPP(msk) = GPP0;
                    LE(msk) = LE0;
                    Rn(msk) = Rn0;
                    LST(msk) = LST0;
                    msk = mskDay & isfinite(RVIS) & isfinite(RNIR) & mskC4;
                    [GPP0, LE0, Rn0, Gs0, LST0] = m_CarbonWaterFluxes(APAR_Sun(msk), APAR_Sh(msk), ASW_Sun(msk), ASW_Sh(msk), Vcmax25_C4Sun(msk), Vcmax25_C4Sh(msk), m_C4(msk), b0_C4(msk), fSun(msk), ASW_Soil(msk), G(msk), SZA(msk), LAI(msk), CI(msk), Ca(msk), Ps(msk), Ta(msk), gamma(msk), Cp(msk), rhoa(msk), VPD(msk), RH(msk), desTa(msk), ddesTa(msk), epsa(msk), Rc(msk), Rs(msk), alf(msk), fStress(msk), FNonVeg(msk),true);
                    GPP(msk) = GPP(msk).*(1-fC4(msk)) + GPP0.*fC4(msk);
                    LE(msk) = LE(msk).*(1-fC4(msk)) + LE0.*fC4(msk);
                    Rn(msk) = Rn(msk).*(1-fC4(msk)) + Rn0.*fC4(msk);
                    LST(msk) = LST(msk).*(1-fC4(msk)) + LST0.*fC4(msk);
                    
                    msk = NonVeg;
                    [ LE0, Rn0, LST0] = m_NonVeg(G(msk), Rg(msk), RSW(msk), Ta(msk), RH(msk), VPD(msk), desTa(msk), gamma(msk), epsa(msk), Cp(msk), rhoa(msk), R(msk));
                    GPP(msk) = 0;
                    LE(msk) = LE0;  
                    Rn(msk) = Rn0;  
                    LST(msk) = LST0;
                     
                    msk = isnan(ALT);
                    GPP(msk) = nan;
                    LE(msk) = nan;
                    Rn(msk) = nan;
                    
                    msk = Water;
                    [LE0,Rn0] = m_Water(doy, LAT(msk), ALT(msk), TaDaily(msk), TdDaily(msk), RgDaily(msk), RSW(msk), v(msk));
                    GPP(msk) = 0;
                    LE(msk) = LE0;  
                    Rn(msk) = Rn0;  
                    
                    msk = mskNight;
                    GPP(msk) = 0;
                    LE(msk) = 0;
                    Rn(msk) = 0;
                     
                    if k == 1
                        GPP_MOD = 1800 * GPP ./ SFd * 12*1e-6;
                        LE_MOD = 1800 * LE ./ SFd * 1e-6;
                        Rn_MOD = Rn .* SFd2 * 60*60*24*1e-6;               
                        GPP_MOD(GPP_MOD>25) = nan;
                        LE_MOD(LE_MOD>25) = nan;
                        Rn_MOD(Rn_MOD>25) = nan;
                        Rn_MOD(Rn_MOD<-25) = nan;
                        sprintf('../LST_AM^/LST_AM^.%d.%03d.mat',year,doy)
                        data = LST; save(sprintf('../LST_AM^/LST_AM^.%d.%03d.mat',year,doy),'data');
                    else
                        GPP_MYD = 1800 * GPP ./ SFd * 12*1e-6;
                        LE_MYD = 1800 * LE ./ SFd * 1e-6;
                        Rn_MYD = Rn .* SFd2 * 60*60*24*1e-6; 
                        GPP_MYD(GPP_MYD>25) = nan;
                        LE_MYD(LE_MYD>25) = nan;
                        Rn_MYD(Rn_MYD>25) = nan;
                        Rn_MYD(Rn_MYD<-25) = nan;
                        data = LST; save(sprintf('../LST_PM^/LST_PM^.%d.%03d.mat',year,doy),'data');
                    end
                end  
          
                GPP_Daily = nanmean(cat(2,GPP_MOD,GPP_MYD),2);
                LE_Daily = nanmean(cat(2,LE_MOD,LE_MYD),2);
                Rn_Daily = nanmean(cat(2,Rn_MOD,Rn_MYD),2); 
                
                [LE_Daily, ET_Daily, PET_Daily] = m_Byproduct(LE_Daily, Rn_Daily, TaDaily, ALT);                

                data = GPP_Daily; mkdir('../GPP_Daily^/'); save(sprintf('../GPP_Daily^/GPP_Daily^.%d.%03d.mat',year,doy),'data');
                data = LE_Daily; mkdir('../LE_Daily^/'); save(sprintf('../LE_Daily^/LE_Daily^.%d.%03d.mat',year,doy),'data');
                data = ET_Daily; mkdir('../ET_Daily^/'); save(sprintf('../ET_Daily^/ET_Daily^.%d.%03d.mat',year,doy),'data');
                data = PET_Daily; mkdir('../PET_Daily^/'); save(sprintf('../PET_Daily^/PET_Daily^.%d.%03d.mat',year,doy),'data');
                data = Rn_Daily; mkdir('../Rn_Daily^/'); save(sprintf('../Rn_Daily^/Rn_Daily^.%d.%03d.mat',year,doy),'data');
                
                GPP_(:,day) = GPP_Daily;
                LE_(:,day) = LE_Daily;
                ET_(:,day) = ET_Daily;
                PET_(:,day) = PET_Daily;
                Rn_(:,day) = Rn_Daily;
                
                GPP_(:,day) = importdata(sprintf('../GPP_Daily^/GPP_Daily^.%d.%03d.mat',year,doy));
                LE_(:,day) = importdata(sprintf('../LE_Daily^/LE_Daily^.%d.%03d.mat',year,doy));
                ET_(:,day) = importdata(sprintf('../ET_Daily^/ET_Daily^.%d.%03d.mat',year,doy));
                PET_(:,day) = importdata(sprintf('../PET_Daily^/PET_Daily^.%d.%03d.mat',year,doy));
                Rn_(:,day) = importdata(sprintf('../Rn_Daily^/Rn_Daily^.%d.%03d.mat',year,doy));
            end
        end
          
         data = nanmean(GPP_,2);
		 mkdir('../GPP_Monthly^/');
         save(sprintf('../GPP_Monthly^/GPP_Monthly^.%d.%02d.mat',year,month),'data');
         data = nanmean(LE_,2);
		 mkdir('../LE_Monthly^/');
         save(sprintf('../LE_Monthly^/LE_Monthly^.%d.%02d.mat',year,month),'data');
         data = nanmean(ET_,2);
		 mkdir('../ET_Monthly^/');
         save(sprintf('../ET_Monthly^/ET_Monthly^.%d.%02d.mat',year,month),'data');
         data = nanmean(PET_,2);
		 mkdir('../PET_Monthly^/');
         save(sprintf('../PET_Monthly^/PET_Monthly^.%d.%02d.mat',year,month),'data');
         data = nanmean(Rn_,2);
		 mkdir('../Rn_Monthly^/');
         save(sprintf('../Rn_Monthly^/Rn_Monthly^.%d.%02d.mat',year,month),'data');
     end    
          
     series = nan(8774037,12,'single');
     for month = 1:12
         series(:,month) = importdata(sprintf('../GPP_Monthly^/GPP_Monthly^.%d.%02d.mat',year,month));
     end
     data = nanmean(series,2);
	 mkdir('../GPP_Annual^/');
     save(sprintf('../GPP_Annual^/GPP_Annual^.%d.mat',year),'data');
     for month = 1:12
         series(:,month) = importdata(sprintf('../LE_Monthly^/LE_Monthly^.%d.%02d.mat',year,month));
     end
     data = nanmean(series,2);
	 mkdir('../LE_Annual^/');
     save(sprintf('../LE_Annual^/LE_Annual^.%d.mat',year),'data');
     for month = 1:12
         series(:,month) = importdata(sprintf('../ET_Monthly^/ET_Monthly^.%d.%02d.mat',year,month));
     end
     data = nanmean(series,2);
	 mkdir('../ET_Annual^/');
     save(sprintf('../ET_Annual^/ET_Annual^.%d.mat',year),'data');
     for month = 1:12
         series(:,month) = importdata(sprintf('../PET_Monthly^/PET_Monthly^.%d.%02d.mat',year,month));
     end
     data = nanmean(series,2);
	 mkdir('../PET_Annual^/');
     save(sprintf('../PET_Annual^/PET_Annual^.%d.mat',year),'data');
     for month = 1:12
         series(:,month) = importdata(sprintf('../Rn_Monthly^/Rn_Monthly^.%d.%02d.mat',year,month));
     end
     data = nanmean(series,2);
	 mkdir('../Rn_Annual^/');
     save(sprintf('../Rn_Annual^/Rn_Annual^.%d.mat',year),'data');
    
end   
end 
