% =============================================================================
%
% Module     : Canopy longwave radiation transfer
% Input      : leaf area index (LAI) [-],
%            : extinction coefficient for longwave radiation (kd) [m-1],
%            : extinction coefficient for beam radiation (kb) [m-1],
%            : air temperature (Ta) [K],
%            : soil temperature (Ts) [K],
%            : foliage temperature (Tf) [K],
%            : clear-sky emissivity (epsa) [-],
%            : soil emissivity (epss) [-],
%            : foliage emissivity (epsf) [-].
% Output     : total absorbed LW by sunlit leaves (Q_LSun),
%            : total absorbed LW by shade leaves (Q_LSh).
% References : Wang, Y., Law, R. M., Davies, H. L., McGregor, J. L., & Abramowitz, G. (2006). 
%              The CSIRO Atmosphere Biosphere Land Exchange (CABLE) model for use in climate models and as an offline model.
%
% =============================================================================

function [ALW_Sun, ALW_Sh, ALW_Soil, Ls, La] = m_CanopyLongwaveRadiation(LAI, SZA, Ts, Tf, Ta, epsa,epsf,epss)

    SZA(SZA>89) = 89;
    kb = 0.5 ./ cosd(SZA);    % Table A1 in Ryu et al 2011
    kd = 0.78;    % Table A1 in Ryu et al 2011
     
    % Stefan_Boltzmann_constant
    sigma = 5.670373e-8;    % [W m-2 K-4] (Wiki)  

    % Long wave radiation flux densities from air, soil and leaf
    La = epsa * sigma .* Ta.^4;
    Ls = epss * sigma .* Ts.^4;
    Lf = epsf * sigma .* Tf.^4;
    
    % For simplicity
    kd_LAI = kd .* LAI;

    % Absorbed longwave radiation by sunlit leaves
    ALW_Sun = (Ls-Lf).*kd.*(exp(-kd_LAI)-exp(-kb.*LAI))./(kd-kb) + kd.*(La-Lf).*(1-exp(-(kb+kd).*LAI))./(kd+kb);    % Eq. (44)
    % Absorbed longwave radiation by shade leaves
    ALW_Sh = (1-exp(-kd_LAI)) .* (Ls+La-2*Lf) - ALW_Sun;    % Eq. (45)
    % Absorbed longwave radiation by soil
    ALW_Soil = (1-exp(-kd_LAI)).*Lf + exp(-kd_LAI).*La;    % Eq. (41)
