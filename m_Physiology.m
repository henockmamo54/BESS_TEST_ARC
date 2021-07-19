% =============================================================================
%
% Module     : Physiology 
% Input      : day of year (DOY) [-],
%            : latitude (LAT) [degree],
%            : altitude (ALT) [m],
%            : IGBP land cover type (IGBP) [-],
%            : climate type (Climate) [-], 
%            : 30 day mean air temperate (TaLag) [K],
%            : 30 day mean dew point temperate (TdLag) [K],
%            : 30 day mean shortwave radiation (RgLag) [MJ m-2 d-1],
%            : 30 day mean PAR radiation (PARLag) [umol m-2 d-1], 
%            : ambient CO2 concentration (Ca) [umol mol-1],
%            : fraction of sand (fSAND) [-],
%            : fraction of clay (fCLAY) [-],
%            : organic matter (OC) [-],
%            : soil moisture (SM) [-],
%            : anisohydry slope (isohydry) [-],
%            : scaled NDVI (NDVIS) [-],
%            : fraction of absorbed photosynthetically active radiation (FPAR) [-].
% Output     : ratio of intercellular CO2 concentration to ambient CO2 concentration (chi) [-],
%            : leaf maximum carboxylation rate at 25C (Vcmax25_Leaf) [umol m-2 s-1],
%            : Ball-Berry slope for C3 leaf (m_C3) [-],
%            : Ball-Berry slope for C4 leaf (m_C4) [-],
%
% =============================================================================
   
function [alf, chi, kn, b0, Vcmax, Vcmax25_C3Leaf, m_C3, Vcmax25_C4Leaf, m_C4] = m_Physiology(Climate, IGBP, FNonVeg, LAI, ALT, TaLag, TdLag, PARLag, FPAR, TaDaily, Ca, CI) 

%% Mean meteorological data over past 30 days 

% mean air temperature over past 30 days
TaCLag = TaLag - 273.16;    % [K] -> [C]
% mean due point temperature over past 30 days
TdCLag = TdLag - 273.16;    % [K] -> [C]
% mean saturated vapour pressure over past 30 days (Allen 1998)
esLag = 0.6108 * exp((17.27*TaCLag)./(TaCLag+237.3)) * 1000;    % [Pa]
% mean ambient vapour pressure over past 30 days (Allen 1998)
eaLag = 0.6108 * exp((17.27*TdCLag)./(TdCLag+237.3)) * 1000;    % [Pa]
% mean vapour pressure deficit over past 30 days
VPDLag = esLag - eaLag;    % [Pa]
VPDLag(VPDLag<0) = 0;
% mean relative humidity over past 30 days
RHLag = eaLag ./ esLag;    % [-]
% mean surface pressure over past 30 days (Allen 1998)
PsLag = 101325*(1.0 - 0.0065*ALT./TaLag).^(9.807/(0.0065*287));    % [Pa]

%% Stomatal behaviour with lag effect

% Canopy average leaf temperature (Michaletz et al., 2016)
% daily mean O2 partial pressure
O = PsLag * 0.21;    % [Pa]
% gas constant
R = 8.314e-3;    % [kJ K-1 mol-1] 
% Michaelis–Menten constant for CO2 (Bernacchi et al. 2001)
KC = exp(38.05-79.43./(R*TaLag)) * 1e-6 .* PsLag;    % [Pa]
% Michaelis–Menten constant for O2 (Bernacchi et al. 2001)
KO = exp(20.30-36.38./(R*TaLag)) * 1000 * 1e-6 .* PsLag;    % [Pa]
% CO2 compensation point (Bernacchi et al. 2001)
GammaS = exp(19.02-37.83./(R*TaLag)) * 1e-6 .* PsLag;    % [Pa]
% Michaelis–Menten coefficient for Rubisco-limited photosynthesis (Bernacchi et al. 2001)
K = KC.*(1+O./KO);    % [Pa] 
% viscosity of water relative to its value at 25 degree (Wang et al. 2017)
etaS = exp(-580./(-138+TaLag).^2.*(TaLag-298));    % [-]
% sensitivity of chi to VPD (Wang et al. 2017)
ksi = sqrt(200*(K+GammaS)./(1.6*etaS*2.4));
% ratio of intercellular CO2 concentration to ambient CO2 concentration (Wang et al. 2017)
chi = (ksi+GammaS.*sqrt(VPDLag)./Ca)./(ksi+sqrt(VPDLag));    % [-]

%% Photosynthetic capacity with lag effect

% Canopy-level FPAR
msk = IGBP~=8 & IGBP~=10;
FPAR(msk) = FPAR(msk) ./ (1-FNonVeg(msk));
msk = IGBP==8 | IGBP==10;
FPAR(msk) = FPAR(msk) ./ (1-exp(-0.5*LAI(msk)));
FPAR(FPAR>1) = 1;    
% Intrinsic quantum yield
alf = nan(size(ALT),'single');
% forest types (Collatz et al. 1991; Singsaas et al., 2001)
alf(:) = 0.08;    
% tropical forest (Leuning, 1995; Mercado et al., 2009)
alf(IGBP==2&Climate<=2) = 0.06;
% non-forest types (Long et al. 1993; Kromdijk et al., 2016)
alf(IGBP==10) = 0.09;
% intercellular CO2 concentration
Ci = Ca .* chi * 1e-6 .* PsLag;    % [Pa] 
% CO2 limitation term (Wang et al. 2017)
m = (Ci-GammaS) ./ (Ci+2*GammaS);
% refined CO2 limitation term (Wang et al. 2017)
c = sqrt(1-(0.41./m).^(2/3));
c = real(c);
m_ = m .* c;
% LUE GPP model (Wang et al. 2017)  
A = alf *12 .* PARLag .* FPAR .* m_;    % [gC m-2 d-1] 
% Vcmax model (Wang et al. 2017) 
V = A ./ ((Ci-GammaS)./(Ci+K)) / (60*60*24*1e-6*12);    % [umol m-2 s-1]
 
%% Corrections for Vcmax
 
% coefficient of photosynthetic nitrogen distribution
kn = nan(size(Climate),'single');
% non-crop types (Hikosaka et al., 2016)
kn(:) = 0.41;    
% tropical forest (Wu et al., 2018)
kn(IGBP==2&Climate<=2) = 0.12;
% crop types (DePury and Farquhar, 1997)
kn(IGBP==10) = 0.71;
% vertical correction
fC = ((1-exp(-kn.*CI)) ./ (kn.*CI));
Vtop = V ./ fC;
% sunlit leaf temperature (Michaletz et al., 2016)
Tcorr = 0.74*(TaDaily-273.16) + 7.215 + 273.16;
% temperate correction (Kattge et al. 2007)
fT = exp(72*(Tcorr-298.15)./(R*Tcorr*298.15)) .* (1+exp((0.65*298.15-200)./(R*298.15)))./(1+exp((0.65*Tcorr-200)./(R*Tcorr)));
fT(fT<0.2) = 0.2;
Vtop25 = Vtop ./ fT;
% constraint
Vtop25(Vtop25>180) = 180;
Vtop25(Vtop25<0) = 0;

Vcmax = Vtop;
Vcmax25_C3Leaf = Vtop25;
Vcmax25_C4Leaf = nan(size(Vtop25),'single');
 
%% 
m_C3 = nan(size(Vtop25),'single');
m_C3(Climate<4) = 9.5;
m_C3(Climate>=4) = 7.5;
m_C3(IGBP>=8&IGBP<=10)  = 13.5;
m_C4 = nan(size(Vtop25),'single');

%%
b0 = nan(size(Vtop25),'single');
b0(:) = 0.005;
b0(IGBP==8)= 0.012;
b0(IGBP==10)= 0.015;
fStress = (RHLag.^(VPDLag/1000));
b0 = b0 .* fStress;
