% =============================================================================
%
% Module     : Photosynthesis for C3 plant 
% Input      : leaf temperature (Tf) [K],
%            : intercellular CO2 concentration (Ci) [umol mol-1],
%            : absorbed photosynthetically active radiation (APAR) [umol m-2 s-1],
%            : maximum carboxylation rate at 25C (Vcmax25) [umol m-2 s-1],
%            : surface pressure (Ps) [Pa].
% Output     : net assimilation (An) [umol m-2 s-1].
%
% =============================================================================

% Collatz et al., 1991  
function [An] = m_C3Photosynthesis(Tf, Ci, APAR, Vcmax25, Ps, alf) 
       
    % Gas constant
    R = 8.314e-3;    % [kJ K-1 mol-1] 
    % O2 concentration
    O = Ps * 0.21;    % [Pa]
    % Unit convertion
    Pi = Ci*1e-6 .* Ps;    % [umol mol-1] -> [Pa]
 
    % Temperature correction
    item = (Tf-298.15)/10;
    KC25 = 30;    % [Pa]
    KCQ10 = 2.1;    % [-]
    KO25 = 30000;    % [Pa]
    KOQ10 = 1.2;    % [-]
    tao25 = 2600;    % [Pa]
    taoQ10 = 0.57;    % [-]
    KC = KC25 .* KCQ10.^item;    % [Pa]
    KO = KO25 .* KOQ10.^item;    % [Pa]
    K = KC.*(1+O./KO);    % [Pa] 
    tao = tao25 .* taoQ10.^item;    % [Pa]
    GammaS = O ./ (2*tao);    % [Pa]
    VcmaxQ10 = 2.4;    % [-]
    Vcmax_o = Vcmax25 .* VcmaxQ10.^item;    % [umol m-2 s-1]
    Vcmax = Vcmax_o ./ (1+exp((-220+0.703*Tf)./(R*Tf)));    % [umol m-2 s-1]    
    Rd_o = 0.015*Vcmax;    % [umol m-2 s-1]
    Rd = Rd_o .* (1+exp(1.3*(Tf-273.15-55))).^(-1);    % [umol m-2 s-1]
        
    % Three limiting states
    JC = Vcmax .* (Pi-GammaS)./(Pi+K);
    JE = alf.*APAR .* (Pi-GammaS)./(Pi+2*GammaS); 
    JS = Vcmax / 2;
       
    % Colimitation (not the case at canopy level according to DePury and Farquhar)
    a = 0.98;
    b = -(JC+JE);
    c = JC .* JE;
    JCE = (-b + sign(b) .* sqrt(b.^2 - 4.*a.*c))./(2.*a);
    JCE = real(JCE);
    a = 0.95;
    b = -(JCE+JS);
    c = JCE .* JS;
    JCES = (-b + sign(b) .* sqrt(b.^2 - 4.*a.*c))./(2.*a);
    JCES = real(JCES);
     
    % Net assimilation
    % An = nanmin(cat(3,JC,JE,JS),[],3) - Rd;    % [umol m-2 s-1] 
    An = JCES - Rd;
    An(An<0) = 0;
  
  
    % % Gas constant
    % R = 8.314e-3;    % [kJ K-1 mol-1] 
    % % O2 concentration
    % O = Ps * 0.21;    % [Pa]
    % % Unit convertion
    % Ci = Ci*1e-6 .* Ps;    % [umol mol-1] -> [Pa]
    
    % % Kinetic variables
    % item = (Tf-298.15) ./ (R*Tf*298.15);
    % KC25 = 39.97;    % [Pa]
    % KCEa = 79.43;    % [kJ mol-1]
    % KO25 = 27480;    % [Pa]
    % KOEa = 36.38;    % [kJ mol-1]
    % GammaS25 = 4.22;    % [Pa]
    % GammaSEa = 37.830;    % [kJ mol-1]
    % KC = KC25 .* exp(KCEa*item);    % [Pa]
    % KO = KO25 .* exp(KOEa*item);    % [Pa]
    % K = KC.*(1+O./KO);    % [Pa] 
    % GammaS = GammaS25 .* exp(GammaSEa*item);    % [Pa]
    
    % % Vcmax, Jmax, J and Rd (if has one)
    % item_ = (1+exp((0.65*298.15-200)./(R*298.15))) ./ (1+exp((0.65*Tf-200)./(R*Tf)));
    % VcmaxEa = 72;    % [kJ mol-1]
    % Vcmax = Vcmax25 .* exp(VcmaxEa*item) .* item_;    % [umol m-2 s-1]
    % JmaxEa = 50;    % [kJ mol-1]
    % Jmax = (2.65-0.036*15)*Vcmax25 .* exp(JmaxEa*item) .* item_;    % [umol m-2 s-1]
    % % phi0 = 0.085;    % [mol CO2 mol photons-1]
    % J = alf.*APAR ./ sqrt(1+(4*alf.*APAR./Jmax).^2);    % [umol m-2 s-1]
    
    % % Farquhar's model
    % Ac = Vcmax .* (Ci-GammaS)./(Ci+K);
    % Aj = J .* (Ci-GammaS)./(Ci+2*GammaS);
    % a = 1;
    % b = -(Aj+Ac);
    % c = Aj.*Ac;
    % An = (-b + sign(b) .* sqrt(b.^2 - 4.*a.*c))./(2.*a);
    % An = real(An);
    % An(An<0) = 0;
    