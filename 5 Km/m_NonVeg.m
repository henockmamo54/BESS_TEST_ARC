function [LE, Rn, LST] = m_NonVeg(G, Rs, RSW, Ta, RH, VPD, desTa, gamma, epsa, Cp, rhoa, R)

    Soil = RSW <= 0.5;
    Snow = RSW > 0.5;
    EMIS = nan(size(RSW),'single');
    EMIS(Soil) = 0.96;
    EMIS(Snow) = 0.98;
    Ts = Ta;
    
    for i = 1:3
        sigma = 5.670373e-8;
        Ldown = epsa * sigma .* Ta.^4;
        Lup = EMIS * sigma .* Ts.^4; 
        Rn = Rs.*(1-RSW) + Ldown - Lup - 4*epsa*sigma.*Ta.^3.*(Ts-Ta);
        LE = desTa./(desTa+gamma) .*(Rn-G) .* RH.^(VPD/1000);
        LE(LE>Rn) = Rn(LE>Rn);
        LE(Rn<0) = 0;
        LE(LE<0) = 0;
        H = Rn - G - LE;
        dT = R./(rhoa.*Cp) .* H;
        dT(dT>20) = 20;
        dT(dT<-20) = -20;
        Ts = Ta + dT;
    end
    
    L = (1-EMIS).*Ldown + sigma.*EMIS.*Ts.^4;
    LST = (L./EMIS./sigma) .^ 0.25;
    LST(LST<=273.16-60) = nan; 
    LST(LST>=273.16+60) = nan;     
    