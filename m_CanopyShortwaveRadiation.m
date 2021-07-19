% =============================================================================
%
% Module     : Canopy radiative transfer
% Input      : diffuse PAR radiation (PARDiff) [W m-2],
%            : direct PAR radiation (PARDir) [W m-2],
%            : diffuse NIR radiation (NIRDiff) [W m-2],
%            : direct NIR radiation (NIRDir) [W m-2],
%            : ultroviolet radiation (UV) [W m-2],
%            : solar zenith angle (SZA) [degree],
%            : leaf area index (LAI) [-],
%            : clumping index (CI) [-],
%            : VIS albedo (ALB_VIS) [-],
%            : NIR albedo (ALB_NIR) [-],
%            : leaf maximum carboxylation rate at 25C for C3 plant (Vcmax25_C3Leaf) [umol m-2 s-1],
%            : leaf maximum carboxylation rate at 25C for C4 plant (Vcmax25_C4Leaf) [umol m-2 s-1].
% Output     : total absorbed PAR by sunlit leaves (APAR_Sun) [umol m-2 s-1],
%            : total absorbed PAR by shade leaves (APAR_Sh) [umol m-2 s-1],
%            : total absorbed SW by sunlit leaves (ASW_Sun) [W m-2],
%            : total absorbed SW by shade leaves (ASW_Sh) [W m-2],
%            : sunlit canopy maximum carboxylation rate at 25C for C3 plant (Vcmax25_C3Sun) [umol m-2 s-1],
%            : shade canopy maximum carboxylation rate at 25C for C3 plant (Vcmax25_C3Sh) [umol m-2 s-1],
%            : sunlit canopy maximum carboxylation rate at 25C for C4 plant (Vcmax25_C4Sun) [umol m-2 s-1],
%            : shade canopy maximum carboxylation rate at 25C for C4 plant (Vcmax25_C4Sh) [umol m-2 s-1],
%            : fraction of sunlit canopy (fSun) [-],
%            : ground heat storage (G) [W m-2], 
%            : total absorbed SW by soil (ASW_Soil) [W m-2].
% References : Ryu, Y., Baldocchi, D. D., Kobayashi, H., Van Ingen, C., Li, J., Black, T. A., Beringer, J., Van Gorsel, E., Knohl, A., Law, B. E., & Roupsard, O. (2011). 
%              Integration of MODIS land and atmosphere products with a coupled-process model to estimate gross primary productivity and evapotranspiration from 1 km to global scales. 
%              Global Biogeochemical Cycles, 25(GB4017), 1–24. doi:10.1029/2011GB004053.1.
% 
% ============================================================================= 
  
function [fSun, APAR_Sun, APAR_Sh, ASW_Sun, ASW_Sh, ASW_Soil, G, Vcmax25_C3Sun, Vcmax25_C3Sh, Vcmax25_C4Sun, Vcmax25_C4Sh] = m_CanopyShortwaveRadiation(Rg,PARDiff, PARDir, NIRDiff, NIRDir, UV, SZA, LAI, CI, RVIS, RNIR, Vcmax25_C3Leaf, Vcmax25_C4Leaf, kn)

    mskDay = SZA <= 89; 
    mskNight = SZA > 89; 
 
    % Leaf scattering coefficients and soil reflectance (Sellers 1985)
    sigma_P = 0.175;
    rho_PSoil = 0.15;
    sigma_N = 0.825;
    rho_NSoil = 0.30;
             
    % Beam radiation extinction coefficient of canopy
    kb = 0.5 ./ cosd(SZA);    % Table A1
    kb(mskNight) = 50;
    % Extinction coefficient for beam and scattered beam PAR
    kk_Pb = 0.46 ./ cosd(SZA);    % Table A1
    kk_Pb(mskNight) = 50; 
    % Extinction coefficient for diffuse and scattered diffuse PAR
    kk_Pd = 0.72;    % Table A1
    % Extinction coefficient for beam and scattered beam NIR
    kk_Nb = kb .* sqrt(1-sigma_N);    % Table A1
    % Extinction coefficient for diffuse and scattered diffuse NIR
    kk_Nd = 0.35 * sqrt(1-sigma_N);    % Table A1
    % Sunlit fraction 
    fSun = 1./kb .* (1-exp(-kb.*LAI.*CI)) ./ LAI;    % Integration of Eq. (1)
    fSun(fSun>1) = 1;
    fSun(LAI==0) = 0;
          
    % For simplicity
    L_CI = LAI.*CI;
    exp__kk_Pd_L_CI = exp(-kk_Pd.*L_CI);
    exp__kk_Nd_L_CI = exp(-kk_Nd.*L_CI);
      
    % Total absorbed incoming PAR
    Q_PDn = (1-RVIS).*PARDir.*(1-exp(-kk_Pb.*L_CI)) + (1-RVIS).*PARDiff.*(1-exp__kk_Pd_L_CI);    % Eq. (2)
    % Absorbed incoming beam PAR by sunlit leaves
    Q_PbSunDn = PARDir.*(1-sigma_P).*(1-exp(-kb.*L_CI));    % Eq. (3)
    % Absorbed incoming diffuse PAR by sunlit leaves
    Q_PdSunDn = PARDiff.*(1-RVIS).*(1-exp(-(kk_Pd+kb).*L_CI)).*kk_Pd./(kk_Pd+kb);    % Eq. (4)
    % Absorbed incoming scattered PAR by sunlit leaves
    Q_PsSunDn = PARDir.*((1-RVIS).*(1-exp(-(kk_Pb+kb).*L_CI)).*kk_Pb./(kk_Pb+kb)-(1-sigma_P).*(1-exp(-2.*kb.*L_CI))/2);    % Eq. (5)
    Q_PsSunDn(Q_PsSunDn<0) = 0;
    % Absorbed incoming PAR by sunlit leaves
    Q_PSunDn = Q_PbSunDn + Q_PdSunDn + Q_PsSunDn;    % Eq. (6)
    % Absorbed incoming PAR by shade leaves
    Q_PShDn = Q_PDn - Q_PSunDn;    % Eq. (7)
    Q_PShDn(Q_PShDn<0) = 0;
    % Incoming PAR at soil surface
    I_PSoil = (1-RVIS).*PARDir + (1-RVIS).*PARDiff - (Q_PSunDn+Q_PShDn);
    % Absorbed PAR by soil
    APAR_Soil = (1-rho_PSoil) .* I_PSoil;
    % Absorbed outgoing PAR by sunlit leaves
    Q_PSunUp = I_PSoil .* rho_PSoil .* exp__kk_Pd_L_CI;    % Eq. (8)
    % Absorbed outgoing PAR by shade leaves
    Q_PShUp = I_PSoil .* rho_PSoil .* (1-exp__kk_Pd_L_CI);    % Eq. (9)
    % Total absorbed PAR by sunlit leaves
    APAR_Sun = Q_PSunDn + Q_PSunUp;    % Eq. (10)
    % Total absorbed PAR by shade leaves
    APAR_Sh = Q_PShDn + Q_PShUp;    % Eq. (11)  
      
    % Absorbed incoming NIR by sunlit leaves
    Q_NSunDn = NIRDir.*(1-sigma_N).*(1-exp(-kb.*L_CI)) + NIRDiff.*(1-RNIR).*(1-exp(-(kk_Nd+kb).*L_CI)).*kk_Nd./(kk_Nd+kb) + NIRDir.*((1-RNIR).*(1-exp(-(kk_Nb+kb).*L_CI)).*kk_Nb./(kk_Nb+kb)-(1-sigma_N).*(1-exp(-2*kb.*L_CI))/2);    % Eq. (14)
    % Absorbed incoming NIR by shade leaves
    Q_NShDn = (1-RNIR).*NIRDir.*(1-exp(-kk_Nb.*L_CI)) + (1-RNIR).*NIRDiff.*(1-exp__kk_Nd_L_CI) - Q_NSunDn;    % Eq. (15)
    % Incoming NIR at soil surface
    I_NSoil = (1-RNIR).*NIRDir + (1-RNIR).*NIRDiff - (Q_NSunDn+Q_NShDn);
    % Absorbed NIR by soil
    ANIR_Soil = (1-rho_NSoil) .* I_NSoil;
    % Absorbed outgoing NIR by sunlit leaves
    Q_NSunUp = I_NSoil .* rho_NSoil .* exp__kk_Nd_L_CI;    % Eq. (16)
    % Absorbed outgoing NIR by shade leaves
    Q_NShUp = I_NSoil .* rho_NSoil .* (1-exp__kk_Nd_L_CI);    % Eq. (17)
    % Total absorbed NIR by sunlit leaves
    ANIR_Sun = Q_NSunDn + Q_NSunUp;    % Eq. (18)
    % Total absorbed NIR by shade leaves
    ANIR_Sh = Q_NShDn + Q_NShUp;     % Eq. (19)
 
    % UV  
    UVDir = UV .* PARDir./(PARDir+PARDiff+1e-5); 
    UVDiff = UV - UVDir;
    Q_U = (1-0.05)*UVDiff.*(1-exp(-kk_Pb.*L_CI))  + (1-0.05).*UVDiff.*(1-exp__kk_Pd_L_CI);;
    AUV_Sun = Q_U .* fSun;
    AUV_Sh = Q_U .* (1-fSun); 
    AUV_Soil = (1-0.05)*UV - Q_U; 
             
    % Canopy Vcmax25
    % kn = 0.713;
    kn_kb_Lc = kn + kb.*LAI; 
    LAI_Vcmax25 = LAI .* Vcmax25_C3Leaf;
    Vcmax25_C3Tot =  LAI_Vcmax25 .* (1-exp(-kn.*CI)) ./ (kn.*CI);    % Eq. (32) modified for CI
    Vcmax25_C3Sun = LAI_Vcmax25 .* (1-exp(-CI.*kn_kb_Lc)) ./ kn_kb_Lc;    % Eq. (33) modified for CI
    Vcmax25_C3Sh = Vcmax25_C3Tot - Vcmax25_C3Sun;    % Eq. (34) modified for CI
    LAI_Vcmax25 = LAI .* Vcmax25_C4Leaf;
    Vcmax25_C4Tot =  LAI_Vcmax25 .* (1-exp(-kn.*CI)) ./ (kn.*CI);    % Eq. (32) modified for CI
    Vcmax25_C4Sun = LAI_Vcmax25 .* (1-exp(-CI.*kn_kb_Lc)) ./ kn_kb_Lc;    % Eq. (33) modified for CI
    Vcmax25_C4Sh = Vcmax25_C4Tot - Vcmax25_C4Sun;    % Eq. (34) modified for CI
  
    % Ground heat storage
    G = APAR_Soil * 0.28; 
                
    % Summary
    ASW_Sun = APAR_Sun + ANIR_Sun + AUV_Sun;
    ASW_Sh = APAR_Sh + ANIR_Sh + AUV_Sh;
    ASW_Soil = APAR_Soil + ANIR_Soil + AUV_Soil;
    APAR_Sun = APAR_Sun * 4.56;
    APAR_Sh = APAR_Sh * 4.56;
    
    % Constraints
    APAR_Sun(LAI==0) = 0;
    APAR_Sh(LAI==0) = 0;
    ASW_Sun(LAI==0) = 0;
    ASW_Sh(LAI==0) = 0;
    