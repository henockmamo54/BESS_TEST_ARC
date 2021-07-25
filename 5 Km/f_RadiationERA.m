%this function compute Radiation_ERA_AM/PM
function f_RadiationERA(year,month,opt) %opt: AM/PM
	year= double(year);
	month= double(month) ;

		
	% Prepare
	LAT = importdata('/bess19/Yulin/BESSv2/Ancillary/LAT.005d.mat');
	load(sprintf('/bess/JCY/BESSv2/0Calibration/SFd_%s_ERA_FLiES.mat',opt));  % produced by c_SFd.m
 
	% The ratio of actual to sea level pressure
	ALT = importdata('/bess19/Yulin/BESSv2/Ancillary/ALT.005d.mat');
	PP0 = (1-2.25577e-5*ALT).^5.25588;
	for day = 1:31
		vec = datevec(datenum(year,month,day));
		if vec(2) == month
			doy = datenum(year,month,day) - datenum(year,1,1) + 1;
			
			% Input data
			sprintf('/bess19/Yulin/BESSv2/Rs_Daily/Rs_Daily.%d.%03d.mat',year,doy)
			RsDaily = importdata(sprintf('/bess19/Yulin/BESSv2/Rs_Daily/Rs_Daily.%d.%03d.mat',year,doy));
			SZA = importdata(sprintf('/bess19/Yulin/BESSv2/SZA_%s/SZA_%s.%03d.mat',opt,opt,doy)); 
 
			% Daily - > Snapshot
			Rs = slope .* RsDaily + intercept;
			Rs(Rs<0) = 0;
			% (IARC, 2012) https://www.ncbi.nlm.nih.gov/books/NBK304366/
			UV = Rs * 0.05;
			% Actual visible and near-infrared radiation
			RT = Rs - UV;
			% Cosine of solar zenith angle
			cth = cosd(SZA);
			% Optical air mass
			m = 1 ./ cth;
			m(SZA>90) = 0; 
			% Potential visible direct radiation
			RDV = 600 * exp(-0.185*PP0.*m) .* cth; 
			RDV(RDV<0) = 0;
			% Potential visible diffuse radiation
			RdV = 0.4 * (600-RDV.*m) .* cth;
			RdV(RdV<0) = 0;
			% Potential visible radiation
			RV = RDV + RdV;
			% Water absorption in the near infrared for 10 mm of precipitable water
			w = 1320*10.^(-1.1950+0.4459*log10(m)-0.0345*log10(m).^2);
			% Potential near-infrared direct radiation
			RDN = (720*exp(-0.06*PP0.*m)-w) .* cth; 
			RDN(RDN<0) = 0;
			% Potential near-infrared diffuse radiation
			RdN = 0.6 * (720-RDN.*m-w) .* cth;
			RdN(RdN<0) = 0;
			% Potential visible radiation
			RN = RDN + RdN;
			% Ratio of actual to potential solar radiation
			RATIO = RT ./ (RV+RN);
			RATIO(isinf(RATIO)) = 0;
			% Actual visible radiation
			VIS = RV .* RATIO; 
			% Actual near-infrared radiation
			NIR = RN .* RATIO;
			% Fraction of visible direct radiation
			RATIO_V = RATIO;
			RATIO_V(RATIO_V>0.9) = 0.9;
			fV = RDV./RV .* (1-((0.9-RATIO_V)/0.7).^(2/3.));
			% Fraction of near-infrared direct radiation
			RATIO_N = RATIO;
			RATIO_N(RATIO_N>0.88) = 0.88;
			fN = RDN./RN .* (1-((0.88-RATIO_N)/0.68).^(2/3.));

			% Output
			data = Rs;
			data(data<0|SZA>=90) = 0;
			mkdir(sprintf('/bess19/Yulin/BESSv2/Rg_ERA_%s',opt));
			save(sprintf('/bess19/Yulin/BESSv2/Rg_ERA_%s/Rg_ERA_%s.%d.%03d.mat',opt,opt,year,doy),'data');
			data = UV;
			data(data<0|SZA>=90) = 0;
			mkdir(sprintf('/bess19/Yulin/BESSv2/UV_ERA_%s',opt));
			save(sprintf('/bess19/Yulin/BESSv2/UV_ERA_%s/UV_ERA_%s.%d.%03d.mat',opt,opt,year,doy),'data');
			data = VIS .* fV; 
			data(data<0|SZA>=90) = 0;
			mkdir(sprintf('/bess19/Yulin/BESSv2/PARDir_ERA_%s',opt))
			save(sprintf('/bess19/Yulin/BESSv2/PARDir_ERA_%s/PARDir_ERA_%s.%d.%03d.mat',opt,opt,year,doy),'data');
			data = VIS .* (1-fV);
			data(data<0|SZA>=90) = 0;
			mkdir(sprintf('/bess19/Yulin/BESSv2/PARDiff_ERA_%s',opt))
			save(sprintf('/bess19/Yulin/BESSv2/PARDiff_ERA_%s/PARDiff_ERA_%s.%d.%03d.mat',opt,opt,year,doy),'data');
			data = NIR .* fV; 
			data(data<0|SZA>=90) = 0;
			mkdir(sprintf('/bess19/Yulin/BESSv2/NIRDir_ERA_%s',opt))
			save(sprintf('/bess19/Yulin/BESSv2/NIRDir_ERA_%s/NIRDir_ERA_%s.%d.%03d.mat',opt,opt,year,doy),'data');
			data = NIR .* (1-fV);
			data(data<0|SZA>=90) = 0;
			mkdir(sprintf('/bess19/Yulin/BESSv2/NIRDiff_ERA_%s',opt))
			save(sprintf('/bess19/Yulin/BESSv2/NIRDiff_ERA_%s/NIRDiff_ERA_%s.%d.%03d.mat',opt,opt,year,doy),'data');
		end
	end
