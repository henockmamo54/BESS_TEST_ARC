% =============================================================================
%
% Module     : Photosynthesis for C4 plant
% Input      : leaf temperature (Tf) [K],
%            : intercellular CO2 concentration (Ci) [umol mol-1],
%            : absorbed photosynthetically active radiation (APAR) [umol m-2 s-1],
%            : maximum carboxylation rate at 25C (Vcmax25) [umol m-2 s-1].
% Output     : net assimilation (An) [umol m-2 s-1].
%
% =============================================================================

% Collatz et al., 1992 
function [An] = m_C4Photosynthesis(Tf, Ci, APAR, Vcmax25)
   
    % Temperature correction
    item = (Tf-298.15)/10;
    Q10 = 2;
    k = 0.7 .* Q10.^item;    % [mol m-2 s-1]
    Vcmax_o = Vcmax25 .* Q10.^item;    % [umol m-2 s-1]
    Vcmax = Vcmax_o ./ ((1+exp(0.3*(286.15-Tf))).*(1+exp(0.3*(Tf-309.15))));    % [umol m-2 s-1] 
    Rd_o = 0.8 .* Q10.^item;    % [umol m-2 s-1]
    Rd = Rd_o ./ (1+exp(1.3*(Tf-328.15)));    % [umol m-2 s-1]
    
    % Three limiting states
    Je = Vcmax;    % [umol m-2 s-1] 
    alf = 0.067;    % [mol CO2 mol photons-1]
    Ji = alf * APAR;    % [umol m-2 s-1] 
    ci = Ci * 1e-6;    % [umol mol-1] -> [mol CO2 mol CO2-1]  
    Jc = ci .* k * 1e6;    % [umol m-2 s-1] 
      
    % Colimitation (not the case at canopy level according to DePury and Farquhar)
    a = 0.83;
    b = -(Je+Ji);
    c = Je .* Ji;
    Jei = (-b + sign(b) .* sqrt(b.^2 - 4.*a.*c))./(2.*a);
    Jei = real(Jei);
    a = 0.93;
    b = -(Jei+Jc);
    c = Jei .* Jc;
    Jeic = (-b + sign(b) .* sqrt(b.^2 - 4.*a.*c))./(2.*a);
    Jeic = real(Jeic);
       
    % Net assimilation
    % An = nanmin(cat(3,Je,Ji,Jc),[],3) - Rd;    % [umol m-2 s-1] 
    An = Jeic - Rd;
    An(An<0) = 0;
