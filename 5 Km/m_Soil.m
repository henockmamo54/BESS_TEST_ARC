% =============================================================================
%
% Module     : Soil energy balance
% Input      : leaf area index (LAI) [-],
%            : extinction coefficient for longwave radiation (kd) [m-1],
%            : extinction coefficient for beam radiation (kb) [m-1],
%            : air temperature (Ta) [K],
%            : soil temperature (Ts) [K],
%            : foliage temperature (Tf) [K],
%            : clear-sky emissivity (epsa) [-],
%            : soil emissivity (epss) [-],
%            : foliage emissivity (epsf) [-],
%            : total absorbed PAR by soil (APAR) [umol m-2 s-1],
%            : total absorbed NIR by soil (ANIR) [umol m-2 s-1],
%            : 1st derivative of saturated vapour pressure (desTa),
%            : psychrometric constant (gamma) [pa K-1],
%            : relative humidity (RH) [-],
%            : water vapour deficit (VPD) [Pa],
%            : aerodynamic resistance (ra) [s m-1],
%            : air density (rhoa) [kg m-3],
%            : specific heat of air (Cp) [J kg-1 K-1].
% Output     : soil net radiation (Rn) [W m-2],
%            : soil latent heat (LE) [W m-2],
%            : soil sensible heat (H) [W m-2],
%            : ground storage (G) [W m-2],
%            : soil temperature (Ts) [K].
%
% =============================================================================
 
function [Rn, LE, H, Ts] = m_Soil(Ts, Ta, G, VPD, RH, gamma, Cp, rhoa, desTa, Rs, ASW_Soil, ALW_Soil, Ls, epsa)
    
    % Net radiation
    % Rn = Rnet - Rn_Sun - Rn_Sh;
    sigma = 5.670373e-8;    % [W m-2 K-4] (Wiki)
    Rn = ASW_Soil + ALW_Soil - Ls - 4*epsa*sigma.*Ta.^3.*(Ts-Ta); 
    % G = Rn * 0.35;    
    
    % Latent heat     
    LE = desTa./(desTa+gamma) .*(Rn-G) .* RH.^(VPD/1000);    % (Ryu et al., 2011)
    LE(LE>Rn) = Rn(LE>Rn);
    LE(Rn<0) = 0;
    LE(LE<0) = 0;
    % Sensible heat
    H = Rn - G - LE;
      
    % Update temperature
    dT = Rs./(rhoa.*Cp) .* H;
    dT(dT>20) = 20;
    dT(dT<-20) = -20;
    Ts = Ta + dT;
 