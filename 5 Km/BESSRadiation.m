function BESSRadiation(year,month) 
	year= double(2020);
	month= double(09) ;  
 
                                                                     
LAT = importdata('/bess19/Yulin/BESSv2/Ancillary/LAT.005d.mat');
ALT = importdata('/bess19/Yulin/BESSv2/Ancillary/ALT.005d.mat') / 1000;
Climate = importdata('/bess19/Yulin/BESSv2/Ancillary/Climate.005d.mat');  
                                                         
% Process MODIS atmosphere product
for day = 1:31
	vec = datevec(datenum(year,month,day));
	if vec(2) == month
		doy = datenum(year,month,day) - datenum(year,1,1) + 1;
		disp(sprintf('ExtractTerraSwaths, %d%03d',year,doy)); 
		f_ExtractTerraSwaths(year,doy);
		disp(sprintf('ExtractAquaSwaths, %d%03d',year,doy)); 
		f_ExtractAquaSwaths(year,doy);  
		disp(sprintf('ReprojectTerraSwaths, %d%03d',year,doy)); 
		f_ReprojectTerraSwaths(year,doy);
		disp(sprintf('ReprojectAquaSwaths, %d%03d',year,doy));
		f_ReprojectAquaSwaths(year,doy);
		disp(sprintf('ProcessTerraSwaths, %d%03d',year,doy)); 
		f_ProcessTerraSwaths(year,doy);
		disp(sprintf('ProcessAquaSwaths, %d%03d',year,doy));
		f_ProcessAquaSwaths(year,doy); 
	end 
end   

 
%% Fill atmosphere data gaps using MERRA data

disp(sprintf('MERRA, %d%02d',year,month));  
f_MERRA(year,month);      
disp(sprintf('AOD_AM, %d%02d',year,month));  
f_GasFill(year,month,'AOD','MOD');
disp(sprintf('AOD_PM, %d%02d',year,month));  
f_GasFill(year,month,'AOD','MYD');
disp(sprintf('WV_AM, %d%02d',year,month));  
f_GasFill(year,month,'WV','MOD');
disp(sprintf('WV_PM, %d%02d',year,month));  
f_GasFill(year,month,'WV','MYD');
disp(sprintf('OZ_AM, %d%02d',year,month));  
f_GasFill(year,month,'OZ','MOD'); 
disp(sprintf('OZ_PM, %d%02d',year,month));  
f_GasFill(year,month,'OZ','MYD');
disp(sprintf('RSW_MCD, %d%02d',year,month));  



%% Process of MODIS albedo product
f_ALB(year,month,'SW'); 
disp(sprintf('RSW_MCD^_Monthly, %d%02d',year,month)); 
f_AverageMonthly('RSW_MCD^',year,month,0); 
disp(sprintf('RSW_MCD^_Monthly0, %d%02d',year,month)); 
f_VariationMonthly('RSW_MCD^',year,month,0);
disp(sprintf('RSW_Daily^, %d%02d',year,month)); 
	 

%% Compute morning and afternoon snapshots radiation
for day = 1:31
	vec = datevec(datenum(year,month,day));
	if vec(2) == month
		doy = datenum(year,month,day) - datenum(year,1,1) + 1;
		disp(sprintf('m_SurfaceShortwaveRadiation, %d%03d',year,doy));  
		sprintf('/bess19/Yulin/BESSv2/RSW_Daily^/RSW_Daily^.%d.%03d.mat',year,doy)
		ALB = importdata(sprintf('/bess19/Yulin/BESSv2/RSW_Daily^/RSW_Daily^.%d.%03d.mat',year,doy));
		for k = 1:2
			if k == 1
				sate = 'MOD';
				time = 'AM';
			else
				sate = 'MYD';
				time = 'PM';
			end
			SZA = importdata(sprintf('/bess19/Yulin/BESSv2/SZA_%s/SZA_%s.%03d.mat',time,time,doy));
			try  
				UTC = importdata(sprintf('/bess19/Yulin/BESSv2/UTC_%s/UTC_%s.%d.%03d.mat',sate,sate,year,doy));
				COT = importdata(sprintf('/bess19/Yulin/BESSv2/COT_%s/COT_%s.%d.%03d.mat',sate,sate,year,doy));
				AOD = importdata(sprintf('/bess19/Yulin/BESSv2/AOD_%s/AOD_%s.%d.%03d.mat',time,time,year,doy));
				WV = importdata(sprintf('/bess19/Yulin/BESSv2/WV_%s/WV_%s.%d.%03d.mat',time,time,year,doy));
				try
					OZ = importdata(sprintf('/bess19/Yulin/BESSv2/OZ_%s/OZ_%s.%d.%03d.mat','PM','PM',year,doy)) / 1000;
				catch
					OZ = importdata(sprintf('/bess19/Yulin/BESSv2/OZ_%s/OZ_%s.%d.%03d.mat','AM','AM',year,doy)) / 1000;
				end    
				[~,Rg,UV,VISdir,VISdiff,NIRdir,NIRdiff] = m_SurfaceShortwaveRadiation(SZA, COT, AOD, WV, OZ, ALB, ALT, Climate, doy);
				data = Rg; data(isnan(UTC)) = nan; save(sprintf('/bess19/Yulin/BESSv2/Rg_%s/Rg_%s.%d.%03d.mat',sate,sate,year,doy),'data');
				data = UV; data(isnan(UTC)) = nan; save(sprintf('/bess19/Yulin/BESSv2/UV_%s/UV_%s.%d.%03d.mat',sate,sate,year,doy),'data');
				data = VISdir; data(isnan(UTC)) = nan; save(sprintf('/bess19/Yulin/BESSv2/PARDir_%s/PARDir_%s.%d.%03d.mat',sate,sate,year,doy),'data');
				data = VISdiff; data(isnan(UTC)) = nan; save(sprintf('/bess19/Yulin/BESSv2/PARDiff_%s/PARDiff_%s.%d.%03d.mat',sate,sate,year,doy),'data');
				data = NIRdir; data(isnan(UTC)) = nan; save(sprintf('/bess19/Yulin/BESSv2/NIRDir_%s/NIRDir_%s.%d.%03d.mat',sate,sate,year,doy),'data');
				data = NIRdiff; data(isnan(UTC)) = nan; save(sprintf('/bess19/Yulin/BESSv2/NIRDiff_%s/NIRDiff_%s.%d.%03d.mat',sate,sate,year,doy),'data');
			end 
		end
	end    
end    


%% Compute daily mean radiation
for day = 1:31
	vec = datevec(datenum(year,month,day));
	if vec(2) == month
		doy = datenum(year,month,day) - datenum(year,1,1) + 1;
		disp(sprintf('BESS Radiation, %d%03d',year,doy)); 
		ALB = importdata(sprintf('/bess19/Yulin/BESSv2/RSW_Daily^/RSW_Daily^.%d.%03d.mat',year,doy));
		if doy < 366
			% SZA_ = importdata(sprintf('/bess/JCY/Radiation/SZA1h/SZA1h.%03d.mat',doy));
			SZA_ = importdata(sprintf('/bess19/Yulin/BESSv2/SZA1h/SZA1h.%03d.mat',doy));
		else     
			% SZA_ = importdata(sprintf('/bess/JCY/Radiation/SZA1h/SZA1h.%03d.mat',doy-1));
			SZA_ = importdata(sprintf('/bess19/Yulin/BESSv2/SZA1h/SZA1h.%03d.mat',doy-1));
		end
		SZA_ = SZA_(:,2:3:end);
 
		% MOD (Terra)
		try
			sate = 'MOD';
			time = 'AM';
			UTC = importdata(sprintf('/bess19/Yulin/BESSv2/UTC_%s/UTC_%s.%d.%03d.mat',sate,sate,year,doy));
			COT = importdata(sprintf('/bess19/Yulin/BESSv2/COT_%s/COT_%s.%d.%03d.mat',sate,sate,year,doy));
			AOD = importdata(sprintf('/bess19/Yulin/BESSv2/AOD_%s/AOD_%s.%d.%03d.mat',time,time,year,doy));
			WV = importdata(sprintf('/bess19/Yulin/BESSv2/WV_%s/WV_%s.%d.%03d.mat',time,time,year,doy));
			OZ = importdata(sprintf('/bess19/Yulin/BESSv2/OZ_%s/OZ_%s.%d.%03d.mat','PM','PM',year,doy)) / 1000;
			Rg_ = zeros(size(SZA_),'single');
			PAR_ = zeros(size(SZA_),'single');
			PARDiff_ = zeros(size(SZA_),'single');
			for i = 1:size(SZA_,2)
				msk = SZA_(:,i) <= 90;
				[~,Rg,~,VISdir,VISdiff,~,~] = m_SurfaceShortwaveRadiation(SZA_(msk,i), COT(msk), AOD(msk), WV(msk), OZ(msk), ALB(msk), ALT(msk), Climate(msk), doy);
				Rg_(msk,i) = Rg;
				PAR_(msk,i) = VISdir+VISdiff;
				PARDiff_(msk,i) = VISdiff;
			end
			Rg_MOD = nanmean(Rg_,2);
			PAR_MOD = nanmean(PAR_,2);
			PARDiff_MOD = nanmean(PARDiff_,2);
			msk = isnan(UTC) & (abs(LAT)<60);
			Rg_MOD(msk) = nan;
			PAR_MOD(msk) = nan;
			PARDiff_MOD(msk) = nan;
		catch
			Rg_MOD = nan(size(LAT),'single');
			PAR_MOD = nan(size(LAT),'single');
			PARDiff_MOD = nan(size(LAT),'single');
		end

		% MYD (Aqua)
		try
			sate = 'MYD';
			time = 'PM';
			UTC = importdata(sprintf('/bess19/Yulin/BESSv2/UTC_%s/UTC_%s.%d.%03d.mat',sate,sate,year,doy));
			COT = importdata(sprintf('/bess19/Yulin/BESSv2/COT_%s/COT_%s.%d.%03d.mat',sate,sate,year,doy));
			AOD = importdata(sprintf('/bess19/Yulin/BESSv2/AOD_%s/AOD_%s.%d.%03d.mat',time,time,year,doy));
			WV = importdata(sprintf('/bess19/Yulin/BESSv2/WV_%s/WV_%s.%d.%03d.mat',time,time,year,doy));
			OZ = importdata(sprintf('/bess19/Yulin/BESSv2/OZ_%s/OZ_%s.%d.%03d.mat','PM','PM',year,doy)) / 1000;
			Rg_ = zeros(size(SZA_),'single');
			PAR_ = zeros(size(SZA_),'single');
			PARDiff_ = zeros(size(SZA_),'single');
			for i = 1:size(SZA_,2)
				msk = SZA_(:,i) <= 90;
				[~,Rg,~,VISdir,VISdiff,~,~] = m_SurfaceShortwaveRadiation(SZA_(msk,i), COT(msk), AOD(msk), WV(msk), OZ(msk), ALB(msk), ALT(msk), Climate(msk), doy);
				Rg_(msk,i) = Rg;
				PAR_(msk,i) = VISdir+VISdiff;
				PARDiff_(msk,i) = VISdiff;
			end 
			Rg_MYD = nanmean(Rg_,2);
			PAR_MYD = nanmean(PAR_,2);
			PARDiff_MYD = nanmean(PARDiff_,2);
			msk = isnan(UTC) & (abs(LAT)<60);
			Rg_MYD(msk) = nan;
			PAR_MYD(msk) = nan;
			PARDiff_MYD(msk) = nan;
		catch
			Rg_MYD = nan(size(LAT),'single');
			PAR_MYD = nan(size(LAT),'single');
			PARDiff_MYD = nan(size(LAT),'single');
		end

		% MCD (Terra & Aqua)
		Rg_Daily = nanmean(cat(2,Rg_MOD,Rg_MYD),2) * 60*60*24 * 1e-6;
		PAR_Daily = nanmean(cat(2,PAR_MOD,PAR_MYD),2) * 4.56 * 60*60*24 * 1e-6;
		PARDiff_Daily = nanmean(cat(2,PARDiff_MOD,PARDiff_MYD),2) * 4.56 * 60*60*24 * 1e-6;
		data = Rg_Daily; save(sprintf('/bess19/Yulin/BESSv2/Rg_Daily/Rg_Daily.%d.%03d.mat',year,doy),'data');
		data = PAR_Daily; save(sprintf('/bess19/Yulin/BESSv2/PAR_Daily/PAR_Daily.%d.%03d.mat',year,doy),'data');
		data = PARDiff_Daily; save(sprintf('/bess19/Yulin/BESSv2/PARDiff_Daily/PARDiff_Daily.%d.%03d.mat',year,doy),'data'); 
	end
end
  
% Compute monthly mean radiation
disp(sprintf('Monthly, %d%02d',year,month));
vars = {'Rg','PAR','PARDiff'};
series = nan(8774037,31,'single');
for i = 1:3
	ds = vars{i};
	series(:) = nan;
	for day = 1:31
		vec = datevec(datenum(year,month,day));
		if vec(2) == month
			doy = datenum(year,month,day) - datenum(year,1,1) + 1;
			try
				series(:,day) = importdata(sprintf('/bess19/Yulin/BESSv2/%s_Daily/%s_Daily.%d.%03d.mat',ds,ds,year,doy));
			end
		end
	end
	data = nanmean(series,2); 
	save(sprintf('/bess19/Yulin/BESSv2/%s_Monthly/%s_Monthly.%d.%02d.mat',ds,ds,year,month),'data');
end
end
	