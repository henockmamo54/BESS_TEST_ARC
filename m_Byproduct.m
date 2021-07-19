function [LE_Daily, ET_Daily, PET_Daily] = m_Byproduct(LE_Daily, Rn_Daily, TaDaily, ALT)

    % daily mean air temperature
    TaCDaily = TaDaily - 273.16;    % [Celsius]
    % TaCDaily(TaCDaily<-46) = -46;
    % TaCDaily(TaCDaily>62) = 62;
    % daily mean surface pressure (Allen 1998)        
    PsDaily = 101325*(1.0 - 0.0065*ALT./TaDaily).^(9.807/(0.0065*287));    % [Pa]   
    % daily mean saturated vapour pressure (Allen 1998)
    esDaily = 0.6108 * exp((17.27*TaCDaily)./(TaCDaily+237.3)) * 1000;    % [Pa]
    % 1st derivative of saturated vapour pressure (Allen 1998) 
    desTaDaily = esDaily .* 4098.*(TaCDaily+237.3).^(-2);    % [Pa K-1]
    % psychrometric constant (Allen 1998) 
    gammaDaily = 0.655e-3 * PsDaily;    % [Pa K-1]
    % latent heat of vaporization (Allen 1998) 
    lambdaDaily = 2.501 - (2.361e-3)*TaCDaily;    % [J kg-1]
    % potential latent heat (Priestley-Taylor equation)
    LEp_Daily = 1.26 * Rn_Daily .* desTaDaily./(desTaDaily+gammaDaily);    % [MJ m-2 d-1]
    % constraint 
    LEp_Daily(LE_Daily>LEp_Daily) = LE_Daily(LE_Daily>LEp_Daily); 
    % evapotranspiration
    ET_Daily = LE_Daily ./ lambdaDaily;    % [mm d-1]
    % potential evapotranspiration
    PET_Daily = LEp_Daily ./ lambdaDaily;    % [mm d-1]

    % if strcmp(dsVegetation,'MCD') 
        % % Recalibrated Mirco model coefficients over climate zones
        % C_Climate = [ 0.43281      0.72023     -0.21563      0.88738     0.069859;
                      % 0.48797      0.59542       79.348      0.79018      0.88627;
                      % 0.51866      0.54426       83.084      0.80909      0.47489;
                      % 0.44914      0.52293       61.528      0.83507      0.16923;
                      % 0.85472      0.51236        145.5      0.82918       1.1808];
        % % Recalibrated Mirco model coefficients over land cover types
        % C_IGBP = [0.43044      0.57486       115.29      0.84839      0.15498;
                    % 0.237      0.86671       78.189      0.75633       4.2672;
                  % 0.43044      0.57486       115.29      0.84839      0.15498;
                  % 0.43584      0.47535       50.924      0.78867      0.87293;
                  % 0.50705      0.59271       67.519        0.756       2.0774;
                  % 0.23734      0.81659       87.261      0.70482       1.0393;
                  % 0.31113      0.72032       1.1568      0.83778      0.25154;
                  % 0.56666      0.64226        83.66      0.82839      0.21803;
                   % 0.2441      0.68184       29.419      0.83261       0.7519;
                   % 0.8226      0.34675       141.76      0.86519     0.043625];
        % C_C3 = [0.85054      0.42894       177.27       0.7565      0.79823];                   
        % C_C4 = [0.91442      0.34228       75.177      0.94614   -0.0075911];                   
    % elseif strcmp(dsVegetation,'CPN')
        % % Recalibrated Mirco model coefficients over climate zones
        % C_Climate = [ 0.35212      0.76188      0.10715      0.88569     0.062065
                      % 0.50798      0.57522       84.505      0.80093      0.71688
                      % 0.41821       0.5652       77.334      0.80941      0.55065
                      % 0.41223      0.49792         67.6      0.84124       0.1284
                      % 0.79201      0.58339       144.94      0.75203       4.3819];          
        % % Recalibrated Mirco model coefficients over land cover types
        % C_IGBP = [0.35659      0.57849       117.07      0.85164      0.15137
                   % 0.1597      0.92043       74.709      0.75685       3.6644
                  % 0.35659      0.57849       117.07      0.85164      0.15137
                  % 0.41273       0.4375       61.599      0.80309      0.70444
                  % 0.47359      0.57099       74.744      0.75578       2.1948
                  % 0.21908      0.80567       89.992      0.71221      0.90583
                  % 0.25616       0.7343      0.20983      0.84622      0.28173
                  % 0.51617      0.63224       92.519       0.8277      0.27741
                  % 0.23771      0.68803       26.952      0.81754       1.0261
                  % 0.59305      0.34412       133.52      0.87134     0.030062];  
        % C_C3 = [0.68525      0.44436       181.59      0.73102       1.3046];
        % C_C4 = [0.67587      0.27451        145.2      0.89306     0.042081];
    % elseif strcmp(dsVegetation,'TCDR')
        % % Recalibrated Mirco model coefficients over climate zones
        % C_Climate = [ 0.30404      0.79066     0.010408      0.88241     0.052114
                      % 0.35228      0.54989        85.54      0.82648       0.1944
                      % 0.53199      0.53263       88.428      0.81162      0.31573
                      % 0.53237      0.49047        72.39       0.8393      0.11733
                      % 0.90368      0.56691        145.4      0.78358       2.3176];      
        % % Recalibrated Mirco model coefficients over land cover types
        % C_IGBP = [0.50156       0.5563       123.77      0.84254      0.23259
                  % 0.26583      0.79813       87.395      0.78775       2.0829
                  % 0.50156       0.5563       123.77      0.84254      0.23259
                  % 0.50809      0.46336       51.428      0.80453      0.61718
                  % 0.53992      0.60005       64.634      0.75171       1.8103
                  % 0.30719      0.79391       99.478      0.70491       1.0928
                  % 0.25048      0.67779       16.343      0.85004      0.12554
                  % 0.49728      0.67315       74.273      0.82227      0.21262
                  % 0.25267      0.67941       24.418      0.83371      0.53976
                  % 0.74608      0.33915       126.66      0.87425     0.011031];  
        % C_C3 = [0.82004      0.39596       172.04      0.79693      0.20632];
        % C_C4 = [0.77205      0.28357       140.91      0.88549      0.06132];
    % end                        
    % % Matriculated Mirco model coefficients over climate zones      
    % a_LAIMax_Climate = nan(size(Climate),'single');
    % k2_Climate = nan(size(Climate),'single');
    % E0_Climate = nan(size(Climate),'single');
    % alf_Climate = nan(size(Climate),'single');
    % K_Climate = nan(size(Climate),'single');
    % Climate(IGBP==2) = 1;        
    % for i = 1:5  
        % msk = Climate == i;
        % a_LAIMax_Climate(msk) = C_Climate(i,1);
        % k2_Climate(msk) = C_Climate(i,2);
        % E0_Climate(msk) = C_Climate(i,3);
        % alf_Climate(msk) = C_Climate(i,4);
        % K_Climate(msk) = C_Climate(i,5);
    % end  
    % % Matriculated Mirco model coefficients over land cover types 
    % a_LAIMax_IGBP = nan(size(IGBP),'single');
    % k2_IGBP = nan(size(IGBP),'single');
    % E0_IGBP = nan(size(IGBP),'single');
    % alf_IGBP = nan(size(IGBP),'single');
    % K_IGBP = nan(size(IGBP),'single');      
    % for i = 1:9  
        % msk = IGBP == i;
        % a_LAIMax_IGBP(msk) = C_IGBP(i,1);
        % k2_IGBP(msk) = C_IGBP(i,2);
        % E0_IGBP(msk) = C_IGBP(i,3);
        % alf_IGBP(msk) = C_IGBP(i,4);
        % K_IGBP(msk) = C_IGBP(i,5);
    % end
    % msk =(IGBP==10&~mskC4);
    % a_LAIMax_IGBP(msk) = C_C3(1);
    % k2_IGBP(msk) = C_C3(2);
    % E0_IGBP(msk) = C_C3(3);
    % alf_IGBP(msk) = C_C3(4);
    % K_IGBP(msk) = C_C3(5);   
    % msk = (IGBP==10&mskC4);
    % a_LAIMax_IGBP(msk) = C_C4(1);
    % k2_IGBP(msk) = C_C4(2);
    % E0_IGBP(msk) = C_C4(3);
    % alf_IGBP(msk) = C_C4(4);
    % K_IGBP(msk) = C_C4(5);           
    % % ecosystem respiration 
    % RECO_Climate = (a_LAIMax_Climate.*LAIMax+k2_Climate.*GPP_Daily) .* exp(E0_Climate.*(1./61.02-1./(TaCDaily+46.02))) .* (alf_Climate.*K_Climate+PPT.*(1-alf_Climate))./(K_Climate+PPT.*(1-alf_Climate));
    % RECO_IGBP = (a_LAIMax_IGBP.*LAIMax+k2_IGBP.*GPP_Daily) .* exp(E0_IGBP.*(1./61.02-1./(TaCDaily+46.02))) .* (alf_IGBP.*K_IGBP+PPT.*(1-alf_IGBP))./(K_IGBP+PPT.*(1-alf_IGBP));
    % RECO_Daily = nanmean(cat(3,RECO_Climate,RECO_IGBP),3);    
    % % net ecosystem exchange
    % NEE_Daily = RECO_Daily - GPP_Daily;