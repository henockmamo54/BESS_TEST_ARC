% This function will update CO2 concentrations in file "co2_mm_gl.txt" based on different CO2 oberservations.
function data = f_NOAAbaseline(year,month)
	fileID = fopen('/bess19/Yulin/Data/NOAACO2/co2_mm_gl.txt','w');
	for year = 1980:2020
		for month =1:12
        
			% Prepare
			MSK = importdata('/bess19/Yulin/BESSv2/Ancillary/Landmask.005d.mat');
			r = 0.05;
			[~,LAT] = meshgrid(-180+r/2:r:180-r/2,90-r/2:-r:-90+r/2);
			LAT = LAT(MSK);
			 
			% Input raw data (brw: Barrow; mlo: Mauna Loa; smo: Samoa; spo: South Pole)
			brw = ncread('/bess19/Yulin/Data/NOAACO2/co2_brw_surface-insitu_1_ccgg_MonthlyData.nc','value');
			mlo = ncread('/bess19/Yulin/Data/NOAACO2/co2_mlo_surface-insitu_1_ccgg_MonthlyData.nc','value');
			smo = ncread('/bess19/Yulin/Data/NOAACO2/co2_smo_surface-insitu_1_ccgg_MonthlyData.nc','value');
			spo = ncread('/bess19/Yulin/Data/NOAACO2/co2_spo_surface-insitu_1_ccgg_MonthlyData.nc','value');
			brw0 = ncread('/bess19/Yulin/Data/NOAACO2/co2_brw_surface-insitu_1_ccgg_MonthlyData.nc','time_components');
			mlo0 = ncread('/bess19/Yulin/Data/NOAACO2/co2_mlo_surface-insitu_1_ccgg_MonthlyData.nc','time_components');
			smo0 = ncread('/bess19/Yulin/Data/NOAACO2/co2_smo_surface-insitu_1_ccgg_MonthlyData.nc','time_components');
			spo0 = ncread('/bess19/Yulin/Data/NOAACO2/co2_spo_surface-insitu_1_ccgg_MonthlyData.nc','time_components');
			% Extract data in current month
			brw_ = brw(brw0(1,:)==year&brw0(2,:)==month); 
			mlo_ = mlo(mlo0(1,:)==year&mlo0(2,:)==month);
			smo_ = smo(smo0(1,:)==year&smo0(2,:)==month); 
			spo_ = spo(spo0(1,:)==year&spo0(2,:)==month);
			% Constraints
			brw_(brw_<0) = nan;
			mlo_(mlo_<0) = nan;
			smo_(smo_<0) = nan;
			spo_(spo_<0) = nan;
			% Assignment
			avg = nanmean([brw_,mlo_,smo_,spo_]);
			data = nan(size(LAT),'single');
			data(LAT>=60) = brw_; 
			data(LAT<60&LAT>=0) = mlo_; 
			data(LAT<0&LAT>=-60) = smo_; 
			data(LAT<-60) = spo_;
			data(isnan(data)) = avg;
			
			
			
			fprintf(fileID,'%4d %2d %6f\n', [year month avg]');
			
		end
	end	
	fclose(fileID);