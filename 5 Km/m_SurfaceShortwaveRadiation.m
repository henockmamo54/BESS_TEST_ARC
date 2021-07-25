% =============================================================================
%
% Module     : Surface shortwave Radiation
% Input      : solar zenith angle (SZA),
%            : cloud optical thickness (COT),
%            : aerosol optical depth (AOD),
%            : shortwave albedo (ALB),
%            : digital elevation model (DEM),
%            : climate type (Climate),
%            : latitude (LAT),
%            : day of year (doyM),
%            : ANN for total shortwave radiation (ANN_SWTOT),
%            : ANN for ratio of photosynthetically active radiation to total shortwave radiation (ANN_RATIO),
%            : ANN for ratio of diffuse shortwave radiation to total shortwave radiation (ANN_SWFRAC),
%            : ANN for ratio of diffuse photosynthetically active radiation to photosynthetically active radiation (ANN_PARFRAC)
% Output     : downward shortwave radiation (Rg_tot)
%            : direct shortwave radiation (Rg_dir),
%            : diffuse shortwave radiation (Rg_diff),
%            : photosynthetically active radiation (PAR_tot),
%            : direct photosynthetically active radiation (PAR_dir),
%            : diffuse photosynthetically active radiation (PAR_diff),
%            : near infrared radiation (NIR_tot),
%            : direct near infrared radiation (NIR_dir),
%            : diffuse near infrared radiation (NIR_diff)
% References : Youngryel, R., Jiang, C., Kobayashi, H., Detto, M. (2018).
%              MODIS-derived global products of solar radiation, photosynthetically active radiation, and diffuse photosynthetically active radiation at 1-5 km resolutions.    
%              Remote Sensing of Environment, 204(1), 812-825. doi:10.1016/j.rse.2017.09.021
%              Kobayashi, H., & Iwabuchi, H. (2008). 
%              A coupled 1-D atmosphere and 3-D canopy radiative transfer model for canopy reflectance, light environment, and photosynthesis simulation in a heterogeneous landscape. 
%              Remote Sensing of Environment, 112(1), 173–185. doi:10.1016/j.rse.2007.04.010
%
% =============================================================================
 
function [Ra,Rg,UV,VISdir,VISdiff,NIRdir,NIRdiff] = m_SurfaceShortwaveRadiation(SZA, COT, AOD, WV, OZ, ALB, DEM, Climate, doy)
 
    %% Prepare
 
    ANN_ctype0_atype1 = importdata('/bess19/Yulin/BESSv2/Ancillary/ANN_ctype0_atype1.mat');
    ANN_ctype0_atype2 = importdata('/bess19/Yulin/BESSv2/Ancillary/ANN_ctype0_atype2.mat');
    ANN_ctype0_atype4 = importdata('/bess19/Yulin/BESSv2/Ancillary/ANN_ctype0_atype4.mat');
    ANN_ctype0_atype5 = importdata('/bess19/Yulin/BESSv2/Ancillary/ANN_ctype0_atype5.mat');

    ANN_ctype1_atype1 = importdata('/bess19/Yulin/BESSv2/Ancillary/ANN_ctype1_atype1.mat');
    ANN_ctype1_atype2 = importdata('/bess19/Yulin/BESSv2/Ancillary/ANN_ctype1_atype2.mat');
    ANN_ctype1_atype5 = importdata('/bess19/Yulin/BESSv2/Ancillary/ANN_ctype1_atype5.mat');
    ANN_ctype3_atype4 = importdata('/bess19/Yulin/BESSv2/Ancillary/ANN_ctype3_atype4.mat');
    
    COT(isnan(COT)|(COT<0.001)) = 0;
    ALB(isnan(ALB)) = nanmean(ALB(:)); 
    input = cat(2,COT(:),AOD(:),WV(:),OZ(:),ALB(:),DEM(:),SZA(:))';
    output = nan(size(input));
      
    %% ANN  
    
    msk = (COT==0) & ((Climate==5)|(Climate==6));
    ANN = ANN_ctype0_atype1;
    output(:,msk) = sim(ANN,input(:,msk));
      
    msk = (COT==0) & ((Climate==3)|(Climate==4));
    ANN = ANN_ctype0_atype2;
    output(:,msk) = sim(ANN,input(:,msk));
    
    msk = (COT==0) & (Climate==1);
    ANN = ANN_ctype0_atype4;
    output(:,msk) = sim(ANN,input(:,msk));
    
    msk = (COT==0) & (Climate==2);
    ANN = ANN_ctype0_atype5;
    output(:,msk) = sim(ANN,input(:,msk));
    
    msk = (COT>0) & ((Climate==5)|(Climate==6));
    ANN = ANN_ctype1_atype1;
    output(:,msk) = sim(ANN,input(:,msk));
    
    msk = (COT>0) & ((Climate==3)|(Climate==4));
    ANN = ANN_ctype1_atype2;
    output(:,msk) = sim(ANN,input(:,msk));
    
    msk = (COT>0) & (Climate==2);
    ANN = ANN_ctype1_atype5;
    output(:,msk) = sim(ANN,input(:,msk));
    
    msk = (COT>0) & (Climate==1);
    ANN = ANN_ctype3_atype4;
    output(:,msk) = sim(ANN,input(:,msk));
        
    %% Constraints
    
    tm = reshape(output(1,:)',size(SZA));
    tm(tm<0) = 0;
    tm(tm>1) = 1;
    puv = reshape(output(2,:)',size(SZA));
    puv(puv<0) = 0;
    puv(puv>1) = 1;
    pvis = reshape(output(3,:)',size(SZA));
    pvis(pvis<0) = 0;
    pvis(pvis>1) = 1;
    pnir = reshape(output(4,:)',size(SZA));
    pnir(pnir<0) = 0;
    pnir(pnir>1) = 1;
    fduv = reshape(output(5,:)',size(SZA));
    fduv(fduv<0) = 0;
    fduv(fduv>1) = 1;
    fdvis = reshape(output(6,:)',size(SZA));
    fdvis(fdvis<0) = 0;
    fdvis(fdvis>1) = 1;
    fdnir = reshape(output(7,:)',size(SZA));
    fdnir(fdnir<0) = 0;
    fdnir(fdnir>1) = 1;
    
    %%  Correction for diffuse PAR
    
    COT(COT==0) = nan;
    x = log(COT);
    p1 = 0.05088;
    p2 = 0.04909;
    p3 = 0.5017;      
    corr = p1*x.^2 + p2*x + p3;
    corr(isnan(corr)|corr>1) = 1;
    fdvis = fdvis .* corr * 0.915;
    
    %% Radiation components
    
    dr = 1 + 0.033*cos(2*pi/365*doy);
    Ra = 1333.6 * dr .* cosd(SZA);
    Ra(SZA>90) = 0;   
    Rg = Ra .* tm;
    UV = Rg .* puv;
    VIS = Rg .* pvis;
    NIR = Rg .* pnir;
    UVdiff = UV .* fduv;
    VISdiff = VIS .* fdvis;
    NIRdiff = NIR .* fdnir;
    UVdir = UV - UVdiff;
    VISdir = VIS - VISdiff;
    NIRdir = NIR - NIRdiff;
    