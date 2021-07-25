% =============================================================================
%
% Module     : Meteorology
% Input      : day of year (DOY) [-],
%            : latitude (LAT) [degree],
%            : altitude (ALT) [m],
%            : solar zenith angle (SZA) [degree],
%            : MODIS overpass time (Overpass) [h],
%            : air temperature (Ta) [K],
%            : dew point temperature (Td) [K],
%            : shortwave radiation (Rs) [W m-2],
%            : wind speed (WS) [m s-1],
%            : canopy height (hc) [m],
%            : land surface temperature (LST) [K],
%            : land surface emissivity (EMIS) [-],
%            : shortwave albedo (ALB_SW) [-].
% Output     : surface pressure (Ps) [Pa],
%            : psychrometric constant (gamma) [pa K-1],
%            : air density (rhoa) [kg m-3],
%            : water vapour deficit (VPD) [Pa],
%            : relative humidity (RH) [-],
%            : 1st derivative of saturated vapour pressure (desTa) [pa K-1],
%            : 2nd derivative of saturated vapour pressure (ddesTa) [pa K-2],
%            : clear-sky emissivity (epsa) [-],
%            : aerodynamic resistance (ra) [s m-1],
%            : temporal upscaling factor for fluxes (SFd) [-],
%            : temporal upscaling factor for radiation (SFd2) [-],
%            : net radiation (Rnet) [W m-2].
%
% =============================================================================
      
function [Ps, VPD, RH, desTa, ddesTa, gamma,Cp,rhoa, epsa, R, Rc, Rs, SFd, SFd2, DL, Ra, fStress] = m_Meteorology(DOY, LAT, ALT, SZA, Overpass, Ta, Td, Rg, v, hc, LAI) 
            
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
    % 2nd derivative of saturated vapour pressure 
    ddesTa = 4098 * (desTa.*(TaC+237.3).^(-2)+(-2)*es.*(TaC+237.3).^(-3));    % [Pa K-2]
    % latent Heat of Vaporization
    lambda = 2.501 - (2.361e-3*TaC);    % [J kg-1]    
    % psychrometric constant
    gamma = 0.00163 * Ps./lambda;    % [Pa K-1]
    % specific heat 
    Cp = 0.24 * 4185.5 * (1+0.8*(0.622*ea./(Ps-ea)));   % [J kg-1 K-1]  
    % virtual temperature
    Tv = Ta .* (1-0.378*ea./Ps).^-1;    % [K]
    % air density
    rhoa = Ps ./ (287*Tv);    % [kg m-3]
    % inverse relative distance Earth-Sun
    dr = 1 + 0.033*cos(2*pi/365*DOY);    % [-]
    % solar declination
    delta = 0.409 * sin(2*pi/365*DOY-1.39);    % [rad]
    % sunset hour angle
    omegaS = acos(-tand(LAT).*tan(delta));    % [rad]
    omegaS(isnan(omegaS)|isinf(omegaS)) = 0;
    omegaS = real(omegaS); 
    % Day length
    DL = 24/pi * omegaS; 
    % snapshot radiation
    Ra = 1333.6 * dr .* cosd(SZA);
    % Daily mean radiation
    RaDaily = 1333.6/pi * dr .* (omegaS.*sind(LAT).*sin(delta)+cosd(LAT).*cos(delta).*sin(omegaS));
    % clear-sky solar radiation
    Rgo = (0.75+2e-5*ALT) .* Ra;    % [W m-2]
     
    %% Choi et al., 2008: The Crawford and Duchon’s cloudiness factor with Brunt equation is recommended.
     
    % cloudy index
    cloudy = 1 - Rg./Rgo;    % [-]
    cloudy(cloudy<0) = 0;
    cloudy(cloudy>1) = 1;
    % clear-sky emissivity
    epsa0 = 0.605 + 0.048*(ea/100).^0.5;    % [-]
    % all-sky emissivity
    epsa = epsa0.*(1-cloudy) + cloudy;    % [-]
    
    %% Ryu et al. 2008; 2012
    
    % Upscaling factor
    SFd = 1800*Ra ./ (RaDaily*3600*24);
    SFd(SZA>89) = 1;
    SFd(SFd>1) = 1;

    % bulk aerodynamic resistance
    k = 0.4;    % von Karman constant
    z0 = hc * 0.05; 
    ustar = v.*k ./ (log(10./z0));    % Stability item ignored
    R = v./ustar.^2 + 2./(k.*ustar);    % Eq. (2-4) in Ryu et al 2008
    R(R>1000) = 1000;  
      
    % bulk aerodynamic resistance
    k = 0.4;    % von Karman constant
    z0 = hc * 0.05; 
    ustar = v.*k ./ (log(10./z0));    % Stability item ignored
    R = v./ustar.^2 + 2./(k.*ustar);    % Eq. (2-4) in Ryu et al 2008
    R(R>1000) = 1000;  
    Rs = 0.5 * R;
    Rc = 0.5 * R * 2;
    
    %% Bisht et al., 2005
    DL = DL - 1.5;
    % Time difference between overpass and midday
    dT = abs(Overpass-12);   
    % Upscaling factor for net radiation
    SFd2 = 1.5 ./ (pi*sin((DL-2*dT)./(2*DL)*pi)) .* DL / 24; 
    
    
    fStress = (RH.^(VPD/1000));