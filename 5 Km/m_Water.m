function [LE, Rn] = m_Water(DOY, LAT, ALT, Ta, Td, Rg, RSW, v) 
            
    %% Allen et al., 1998 (FAO)

    % surface pressure
    Ps = 101325*(1.0 - 0.0065*ALT./Ta).^(9.807/(0.0065*287));    % [Pa]  
    % air temperature in Celsius
    TaC = Ta - 273.16;    % [Celsius]
    % dewpoint temperature in Celsius
    TdC = Td - 273.16;    % [Celsius]
    % ambient vapour pressure
    ea = 0.6108 * exp((17.27*TdC)./(TdC+237.3)) * 1000;    % [Pa]
    % saturated vapour pressure
    es = 0.6108 * exp((17.27*TaC)./(TaC+237.3)) * 1000;    % [Pa]
    % water vapour deficit
    VPD = es - ea;    % [Pa]
    % relative humidity
    RH = ea ./ es;    % [-]
    % 1st derivative of saturated vapour pressure
    desTa = es .* 4098.*(TaC+237.3).^(-2);    % [Pa K-1]
    % latent Heat of Vaporization
    lambda = 2.501 - (2.361e-3*TaC);    % [J kg-1]   
    % psychrometric constant
    gamma = 0.00163 * Ps./lambda;    % [Pa K-1]
    % inverse relative distance Earth-Sun
    dr = 1 + 0.033*cos(2*pi/365*DOY);    % [-]
    % solar declination
    delta = 0.409 * sin(2*pi/365*DOY-1.39);    % [rad]
    % sunset hour angle
    omegaS = acos(-tand(LAT).*tan(delta));    % [rad]
    omegaS(isnan(omegaS)|isinf(omegaS)) = 0;
    omegaS = real(omegaS); 
    % Daily mean radiation
    RA = 1362/pi * dr .* (omegaS.*sind(LAT).*sin(delta)+cosd(LAT).*cos(delta).*sin(omegaS));
    
    RS = Rg;
    fU = 1 + 0.536*v;
    msk = TaC < -9.5;
    TaC(msk) = -9.5;
    Epen = 0.051*(1-RSW).*RS.*sqrt(TaC+9.5) - 2.4*(RS./RA).^2 + 0.052*(TaC+20).*(1-RH).*fU + 0.00012*ALT;
    Epen(msk|Epen<0) = 0;
    LE = Epen .* lambda;
    Rn = (LE-gamma./(desTa+gamma) .* 6.43.*fU.*VPD) ./ (desTa./(desTa+gamma));
    LE = LE / (60*60*24*1e-6);
    Rn = Rn / (60*60*24*1e-6);
    