% =============================================================================
%
% Module     : Canopy energy balance
% Input      : net assimulation (An) [umol m-2 s-1],
%            : total absorbed shortwave radiation by sunlit/shade canopy (ASW) [umol m-2 s-1],
%            : total absorbed longwave radiation by sunlit/shade canopy (ALW) [umol m-2 s-1],
%            : sunlit/shade leaf temperature (Tf) [K],
%            : surface pressure (Ps) [Pa],
%            : ambient CO2 concentration (Ca) [umol mol-1],
%            : air temperature (Ta) [K],
%            : relative humidity (RH) [-],
%            : water vapour deficit (VPD) [Pa],
%            : 1st derivative of saturated vapour pressure (desTa),
%            : 2nd derivative of saturated vapour pressure (ddesTa),
%            : psychrometric constant (gamma) [pa K-1],
%            : air density (rhoa) [kg m-3],
%            : aerodynamic resistance (ra) [s m-1],
%            : Ball-Berry slope (m) [-],
%            : Ball-Berry intercept (b0) [-].
% Output     : sunlit/shade canopy net radiation (Rn) [W m-2],
%            : sunlit/shade canopy latent heat (LE) [W m-2],
%            : sunlit/shade canopy sensible heat (H) [W m-2],
%            : sunlit/shade leaf temperature (Tl) [K],
%            : stomatal resistance to vapour transfer from cell to leaf surface (rs) [s m-1],
%            : inter-cellular CO2 concentration (Ci) [umol mol-1].
% References : Paw U, K. T., & Gao, W. (1988). Applications of solutions to non-linear energy budget equations. 
%              Agricultural and Forest Meteorology, 43(2), 121–145. doi:10.1016/0168-1923(88)90087-1
%
% =============================================================================
 
function [Rn, LE, H, Tf, gs, Ci] = m_EnergyBalance(An, ASW, ALW, Tf, Ps, Ca, Ta, RH, VPD, desTa, ddesTa, gamma, Cp, rhoa, Rc, m, b0, flgC4)

    % Convert factor
    cf = 0.446 * (273.15./Tf) .* (Ps/101325);
    % Stefan_Boltzmann_constant
    sigma = 5.670373e-8;    % [W m-2 K-4] (Wiki)
    
    % Stomatal H2O conductance
    gs = m.*RH.*An./Ca + b0;    % [mol m-2 s-1]
 
    % Intercellular CO2 concentration
    Ci = Ca - 1.6*An./gs;    % [umol./mol]
    if flgC4
        Ci(Ci<0.2*Ca) = 0.2*Ca(Ci<0.2*Ca);
        Ci(Ci>0.6*Ca) = 0.6*Ca(Ci>0.6*Ca);
    else
        Ci(Ci<0.5*Ca) = 0.5*Ca(Ci<0.5*Ca);
        Ci(Ci>0.9*Ca) = 0.9*Ca(Ci>0.9*Ca);
    end  
       
    % Stomatal resistance to vapour transfer from cell to leaf surface
    rs = 1./(gs./cf*1e-2);    % [s m-1]
    
    % Stomatal H2O conductance
    gs = 1 ./ rs;    % [m s-1]

    % Canopy net radiation
    Rn = ASW + ALW - 4*0.98*sigma*Ta.^3.*(Tf-Ta);

    % To reduce redundant computation
    rc = rs;
    ddesTa_Rc2 = ddesTa .* Rc.^2;
    gamma_Rc_rc = gamma .* (Rc+rc);
    rhoa_Cp_gamma_Rc_rc = rhoa .* Cp .* gamma_Rc_rc;
 
    % Solution (Paw and Gao 1988)
    a = 1/2 .* ddesTa_Rc2./rhoa_Cp_gamma_Rc_rc;    % Eq. (10b)
    b = -1 - Rc.*desTa./gamma_Rc_rc - ddesTa_Rc2.*Rn./rhoa_Cp_gamma_Rc_rc;    % Eq. (10c)
    c = rhoa .* Cp./gamma_Rc_rc.*VPD + desTa.*Rc./gamma_Rc_rc.*Rn + 1/2*ddesTa_Rc2./rhoa_Cp_gamma_Rc_rc.*Rn.^2;    % Eq. (10d) in Paw and Gao (1988)
    LE = (-b+sign(b).*sqrt(b.^2-4*a.*c))./(2.*a);    % Eq. (10a)
    LE = real(LE);
    
    % Constraints 
    LE(LE>Rn) = Rn(LE>Rn);
    LE(Rn<0) = 0;
    LE(LE<0) = 0;
    LE(Ta<273.15) = 0;
    
    % Update
    H = Rn - LE;
    dT = Rc./(rhoa.*Cp) .* H;    % Eq. (6)
    dT(dT>20) = 20; 
    dT(dT<-20) = -20;    
    Tf = Ta + dT;
 