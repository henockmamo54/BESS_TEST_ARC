function [GPP, LE, Rn, Gs, LST] = m_CarbonWaterFluxes(APAR_Sun, APAR_Sh, ASW_Sun, ASW_Sh, Vcmax25_Sun, Vcmax25_Sh, m, b0, fSun, ASW_Soil, G, SZA, LAI, CI, Ca, Ps, Ta, gamma, Cp, rhoa, VPD, RH, desTa, ddesTa, epsa, Rc, Rs, alf, fStress, FNonVeg,flgC4) 
       
    %% Initialization

    Tf_Sun = Ta;
    Tf_Sh = Ta;
    Ts = Ta;
    Tf = Ta;
    if flgC4
        chi = 0.4;
    else   
        chi = 0.7;
    end
    Ci_Sun = Ca .* chi;
    Ci_Sh = Ca .* chi;  
    b0 = b0 .* fStress;
    epsf = 0.98;    %   
    epss = 0.96;    %   
    sigma = 5.670373e-8;    % [W m-2 K-4] (Wiki)    
               
    %% Iteration  
    for iter = 1:3  
  
        % Longwave radiation
        [ALW_Sun, ALW_Sh, ALW_Soil, Ls, La] = m_CanopyLongwaveRadiation(LAI, SZA, Ts, Tf, Ta, epsa,epsf,epss);

        % Photosynthesis (sunlit)  
        if flgC4
            [An_Sun] = m_C4Photosynthesis(Tf_Sun, Ci_Sun, APAR_Sun, Vcmax25_Sun);
        else 
            [An_Sun] = m_C3Photosynthesis(Tf_Sun, Ci_Sun, APAR_Sun, Vcmax25_Sun, Ps, alf);
        end
        % Energy balance (sunlit)
        [Rn_Sun, LE_Sun, H_Sun, Tf_Sun, gs_Sun, Ci_Sun] = m_EnergyBalance(An_Sun, ASW_Sun, ALW_Sun, Tf_Sun, Ps, Ca, Ta, RH, VPD, desTa, ddesTa, gamma, Cp, rhoa, Rc, m, b0, flgC4);

        % Photosynthesis (shade)
        if flgC4
            [An_Sh] = m_C4Photosynthesis(Tf_Sh, Ci_Sh, APAR_Sh, Vcmax25_Sh);
        else
            [An_Sh] = m_C3Photosynthesis(Tf_Sh, Ci_Sh, APAR_Sh, Vcmax25_Sh, Ps, alf);
        end
        % Energy balance (shade)
        [Rn_Sh, LE_Sh, H_Sh, Tf_Sh, gs_Sh, Ci_Sh] = m_EnergyBalance(An_Sh, ASW_Sh, ALW_Sh, Tf_Sh, Ps, Ca, Ta, RH, VPD, desTa, ddesTa, gamma, Cp, rhoa, Rc, m, b0, flgC4);
        
        % Soil 
        [Rn_Soil, LE_Soil, H_Soil, Ts] = m_Soil(Ts, Ta, G, VPD, RH, gamma, Cp, rhoa, desTa, Rs, ASW_Soil, ALW_Soil, Ls, epsa);
        
        % Composite components
        Tf = (Tf_Sun.^4.*fSun + Tf_Sh.^4.*(1-fSun)).^0.25;
    end 

    LE = LE_Sun + LE_Sh + LE_Soil;    % [W m-2] 
    GPP = An_Sun + An_Sh;    % [umol m-2 s-1]      
    Rn = Rn_Sun + Rn_Sh + Rn_Soil;    % [W m-2]
    Gs = (gs_Sun.*fSun + gs_Sh.*(1-fSun)) * 1000;    % [mm s-1]
    
    % Meng et al., 2009
    FVC = 1 - FNonVeg;
    Lsoil = (1-FVC).*(1-epss).*La + (1-FVC).*sigma.*epss.*Ts.^4;
    Lcanopy = FVC.*(1-epsf).*La + FVC.*sigma.*epsf .* Tf.^4 ;
    L = Lcanopy + Lsoil;
    E = FVC.*epsf + (1-FVC).*epss;
    LST = (L./E./sigma) .^ 0.25;
    LST(LST<=273.16-60) = nan; 
    LST(LST>=273.16+60) = nan; 

    % Constraints
    if flgC4
        GPP(GPP>50) = 50; 
    else
        GPP(GPP>40) = 40; 
    end    
    LE(LE>1000) = 1000; 
    Rn(Rn>1000) = 1000; 
  