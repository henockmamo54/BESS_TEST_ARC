
function f_Vcmax25(year,month)

	years = double(year);  
	month = double(month);  
     
	
	% doys = 1:366;


	LAT = importdata('/bess19/Yulin/BESSv2/Ancillary/LAT.005d.mat');
	ALT = importdata('/bess19/Yulin/BESSv2/Ancillary/ALT.005d.mat');
	Climate = importdata('/bess19/Yulin/BESSv2/Ancillary/Climate.005d.mat');

	for year = years
		
		try
			IGBP = importdata(sprintf('/bess19/Yulin/BESSv2/LC_MCD12C1/LC_MCD12C1.%d.mat',year));
		catch
			IGBP = importdata(sprintf('/bess19/Yulin/BESSv2/LC_MCD12C1/LC_MCD12C1.%d.mat',2019));
		end 
		
		FNonVeg = importdata(sprintf('/bess19/Yulin/BESSv2/FNonVeg^_Trended/FNonVeg^_Trended.%d.mat',year));
		
		for day = 1:31
			
			doy = datenum(year,month,day) - datenum(year,1,1) + 1;
			
			if doy == 366 & ~leapyear(year)
				continue;
			end
			disp(sprintf('%d%03d',year,doy));
			vec = datevec(datenum(year,1,doy));
			month = vec(2);
			sprintf('/bess19/Yulin/BESSv2/Ca/Ca.%d.%02d.mat',year,month)
			CI = importdata(sprintf('/bess19/Yulin/BESSv2/CI^_Clim/CI^_Clim.%02d.mat',month));
			Ca = importdata(sprintf('/bess19/Yulin/BESSv2/Ca/Ca.%d.%02d.mat',year,month));         
			
			LAI = importdata(sprintf('/bess19/Yulin/BESSv2/LAI_Daily^/LAI_Daily^.%d.%03d.mat',year,doy));         
			FPAR = importdata(sprintf('/bess19/Yulin/BESSv2/FPAR_Daily^/FPAR_Daily^.%d.%03d.mat',year,doy));         
			TaDaily = importdata(sprintf('/bess19/Yulin/BESSv2/Ta_Daily/Ta_Daily.%d.%03d.mat',year,doy)); 
			TaLag = importdata(sprintf('/bess19/Yulin/BESSv2/Ta_Lag30/Ta_Lag30.%d.%03d.mat',year,doy)); 
			TdLag = importdata(sprintf('/bess19/Yulin/BESSv2/Td_Lag30/Td_Lag30.%d.%03d.mat',year,doy)); 
			PARLag = importdata(sprintf('/bess19/Yulin/BESSv2/PAR_Lag30/PAR_Lag30.%d.%03d.mat',year,doy)); 
		  
			[alf, chi, kn, b0, Vcmax, Vcmax25_C3Leaf, m_C3, Vcmax25_C4Leaf, m_C4] = m_Physiology(Climate, IGBP, FNonVeg, LAI, ALT, TaLag, TdLag, PARLag, FPAR, TaDaily, Ca, CI);
		 
			data = chi; mkdir('/bess19/Yulin/BESSv2/Vcmax25/chi/'); save(sprintf('/bess19/Yulin/BESSv2/Vcmax25/chi/chi.%d.%03d.mat',year,doy),'data');
			data = b0;  mkdir('/bess19/Yulin/BESSv2/Vcmax25/b0/'); save(sprintf('/bess19/Yulin/BESSv2/Vcmax25/b0/b0.%d.%03d.mat',year,doy),'data');
			data= Vcmax;  mkdir('/bess19/Yulin/BESSv2/Vcmax25/Vcmax/'); save(sprintf('/bess19/Yulin/BESSv2/Vcmax25/Vcmax/Vcmax.%d.%03d.mat',year,doy),'data');
			data= Vcmax25_C3Leaf;  mkdir('/bess19/Yulin/BESSv2/Vcmax25/Vcmax25/'); save(sprintf('/bess19/Yulin/BESSv2/Vcmax25/Vcmax25/Vcmax25.%d.%03d.mat',year,doy),'data');
		end    
	end    
end

% 
% % series = nan(8774037,12,'single');
% % for month = 1:12
%     % T = importdata(sprintf('/bess/JCY/BESSv2/Ta_Clim/Ta_Clim.%02d.mat',month));
%     % series(:,month) = T;
% % end
% % [sorted,index] = sort(series,2,'descend');
% % data = index(:,1);
% % Month1 = data;
% % save('/bess19/Yulin/BESSv2/Month_Ta1.mat','data');
% % data = index(:,2);
% % Month2 = data;
% % save('/bess19/Yulin/BESSv2/Month_Ta2.mat','data');
% % data = index(:,3);
% % Month3 = data;
% % save('/bess19/Yulin/BESSv2/Month_Ta3.mat','data');
% 
% 
% 
% Month1 = importdata('/bess19/Yulin/BESSv2/Month_Ta1.mat');
% Month2 = importdata('/bess19/Yulin/BESSv2/Month_Ta2.mat');
% Month3 = importdata('/bess19/Yulin/BESSv2/Month_Ta3.mat');
% 
% 
% Vcmax251 = nan(8774037,1,'single');
% Vcmax252 = nan(8774037,1,'single');
% Vcmax253 = nan(8774037,1,'single');
% 
% % series = nan(8774037,31,'single');
% for year = years
%     % for month = 1:12
%         % disp(sprintf('%d%02d',year,month));
%         % series(:) = nan;
%         % for day = 1:31
%             % vec = datevec(datenum(year,month,day));
%             % if vec(2) == month
%                 % doy = datenum(year,month,day) - datenum(year,1,1) + 1;
%                 % raw = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax25/Vcmax25.%d.%03d.mat',year,doy));
%             % end
%             % series(:,day) = raw;
%         % end
%         % data = nanmean(series,2);
%         % save(sprintf('/bess19/Yulin/BESSv2/Vcmax25_Monthly/Vcmax25_Monthly.%d.%02d.mat',year,month),'data');
%         % data = nanstd(series,[],2);
%         % save(sprintf('/bess19/Yulin/BESSv2/Vcmax25_Monthly0/Vcmax25_Monthly0.%d.%02d.mat',year,month),'data');
%     % end
%     for month = 1:12
%         raw = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax25_Monthly/Vcmax25_Monthly.%d.%02d.mat',year,month));
%         msk = Month1 == month;
%         Vcmax251(msk) = raw(msk);
%         msk = Month2 == month;
%         Vcmax252(msk) = raw(msk);
%         msk = Month3 == month;
%         Vcmax253(msk) = raw(msk);
%     end
%     data = nanmean(cat(2,Vcmax251,Vcmax252,Vcmax253),2);
%     save(sprintf('/bess19/Yulin/BESSv2/Vcmax25_Ta3/Vcmax25_Ta3.%d.mat',year),'data');
% end
% 
% 
% MSK = importdata('/bess/JCY/BESSv2/Ancillary/Landmask.005d.mat');
% DATA = nan(size(MSK),'single');
% data = nan(366,360,720,'single');
% vars = {'Vcmax25','chi','b0','Vcmax'};
% for k = 1:length(vars)                       
%     ds = vars{k};   
%     for year = years
%         disp(sprintf('%s, %d',ds,year));
%         data(:) = nan;
%         for doy = 1:366
%             if ~leapyear(year) & doy==366
%                 continue;
%             end
%             try
%                 DATA(MSK) = importdata(sprintf('/bess19/Yulin/BESSv2/%s/%s.%d.%03d.mat',ds,ds,year,doy));
%                 data(doy,:,:) = f_Aggregate(DATA,10);
%             end
%         end
%         save(sprintf('/bess/JCY/BESSv2/05D/%s.%d.mat',ds,year),'data'); 
%     end
% end 
% 
% 
% 
% SERIES = nan(8774037,12,'single');
% series = nan(8774037,31,'single');
% for year = years
%     for month = 1:12
%         disp(sprintf('%d%02d',year,month));
%         series(:) = nan;
%         for day = 1:31
%             vec = datevec(datenum(year,month,day));
%             if vec(2) == month
%                 doy = datenum(year,month,day) - datenum(year,1,1) + 1;
%                 raw = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax/Vcmax.%d.%03d.mat',year,doy));
%             end
%             series(:,day) = raw;
%         end
%         data = nanmean(series,2);
%         save(sprintf('/bess19/Yulin/BESSv2/Vcmax_Monthly/Vcmax_Monthly.%d.%02d.mat',year,month),'data');
%         SERIES(:,month) = data;
%         data = nanstd(series,[],2);
%         save(sprintf('/bess19/Yulin/BESSv2/Vcmax_Monthly0/Vcmax_Monthly0.%d.%02d.mat',year,month),'data');
%     end
% end
% for month = 1:12
%     raw = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax_Monthly/Vcmax_Monthly.%d.%02d.mat',year,month));
%     msk = Month1 == month;
%     Vcmax1(msk) = raw(msk);
%     msk = Month2 == month;
%     Vcmax2(msk) = raw(msk);
%     msk = Month3 == month;
%     Vcmax3(msk) = raw(msk);
% end
% data = nanmean(cat(2,Vcmax1,Vcmax2,Vcmax3),2);
% save(sprintf('/bess19/Yulin/BESSv2/Vcmax_Ta3/Vcmax_Ta3.%d.mat',year),'data');
% 
% 
% 
% series = nan(8774037,17,'single');
% for month = 1:12
%     series(:) = nan;
%     month
%     for year = 2001:2017
%         series(:,year-2000) = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax25_Monthly/Vcmax25_Monthly.%d.%02d.mat',year,month));
%     end
%     data = nanmedian(series,2);
%     save(sprintf('/bess19/Yulin/BESSv2/Vcmax25_Clim/Vcmax25_Clim.%02d.mat',month),'data');
% end  
% 
% 
% 
% series = nan(8774037,31,'single');
% for year = years
%     for month = 1:12
%         disp(sprintf('%d%02d',year,month));
%         series(:) = nan;
%         for day = 1:31
%             vec = datevec(datenum(year,month,day));
%             if vec(2) == month
%                 doy = datenum(year,month,day) - datenum(year,1,1) + 1;
%                 raw = importdata(sprintf('/bess19/Yulin/BESSv2/chi/chi.%d.%03d.mat',year,doy));
%             end
%             series(:,day) = raw;
%         end
%         data = nanmean(series,2);
%         save(sprintf('/bess19/Yulin/BESSv2/chi_Monthly/chi_Monthly.%d.%02d.mat',year,month),'data');
%     end
% end
% 
% 
% 
% Vcmax251 = nan(8774037,1,'single');
% Vcmax252 = nan(8774037,1,'single');
% Vcmax253 = nan(8774037,1,'single');
% for month = 1:12
%     month
%     raw = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax25_Clim/Vcmax25_Clim.%02d.mat',month));
%     msk = Month1 == month;
%     Vcmax251(msk) = raw(msk);
%     msk = Month2 == month;
%     Vcmax252(msk) = raw(msk);
%     msk = Month3 == month;
%     Vcmax253(msk) = raw(msk);
% end
% data = Vcmax251;
% save('/bess19/Yulin/BESSv2/Vcmax25_Ta1.mat','data');
% data = nanmean(cat(2,Vcmax251,Vcmax252),2);
% save('/bess19/Yulin/BESSv2/Vcmax25_Ta2.mat','data');
% data = nanmean(cat(2,Vcmax251,Vcmax252,Vcmax253),2);
% save('/bess19/Yulin/BESSv2/Vcmax25_Ta3.mat','data');
% 
% 
% 
% raw = importdata('/bess19/Yulin/BESSv2/Vcmax25_Ta3.mat');
% pft = importdata('/bess19/Yulin/BESSv2/PFT.005d.mat');
% MSK = importdata('/bess/JCY/BESSv2/Ancillary/Landmask.005d.mat');
% DATA = nan(size(MSK),'single');
% data = nan(size(raw),'single');
% for i = [1:8,11,14]
%     msk = pft == i;
%     data(msk) = nanmean(raw(msk(:)));
% end
% msk = (pft==9) | (pft==10);
% data(msk) = nanmean(raw(msk(:)));
% msk = (pft==12) | (pft==13);
% data(msk) = nanmean(raw(msk(:)));
% DATA(MSK) = data;
% msk = isnan(DATA);
% [~,ind] = bwdist(~msk);
% DATA(msk) = DATA(ind(msk));
% data = DATA(MSK);
% save('/bess19/Yulin/BESSv2/Vcmax25_PFT.mat','data');
% data = importdata('/bess19/Yulin/BESSv2/Vcmax25_PFT.mat');
% DATA = nan(size(MSK),'single');
% DATA(MSK) = data;
% data = f_Aggregate(DATA,10);
% save('/bess/JCY/BESSv2/05D/Vcmax25_PFT.mat','data'); 
% 
% 
% 
% % avg = importdata('/bess19/Yulin/BESSv2/Vcmax25_Ta3.mat');
% % Month1 = importdata('/bess19/Yulin/BESSv2/Month_Ta1.mat');
% % Month2 = importdata('/bess19/Yulin/BESSv2/Month_Ta2.mat');
% % Month3 = importdata('/bess19/Yulin/BESSv2/Month_Ta3.mat');
% % sum = zeros(8774037,1,'single');
% % cnt = zeros(8774037,1,'single');
% % i = 1;
% % for year = 2001:2017
%     % for month = 1:12
%         % [year,month]
%         % msk = (Month1==month) | (Month2==month) | (Month3==month);
%         % for day = 1:31
%             % vec = datevec(datenum(year,month,day));
%             % if vec(2) == month
%                 % doy = datenum(year,month,day) - datenum(year,1,1) + 1;
%                 % raw = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax25/Vcmax25.%d.%03d.mat',year,doy));
%                 % cnt = cnt + single(msk);
%                 % raw(~msk) = 0;
%                 % sum = sum + (avg-raw).^2;
%                 % i = i + 1;
%             % end
%         % end
%     % end
% % end
% % data = sqrt(sum ./ cnt);
% % data(cnt==0) = nan;
% % save('/bess19/Yulin/BESSv2/Vcmax25_Ta30.mat','data');
% 
% 
% 
% % Vcmax1 = nan(8774037,1,'single');
% % Vcmax2 = nan(8774037,1,'single');
% % Vcmax3 = nan(8774037,1,'single');
% % Ta1 = nan(8774037,1,'single');
% % Ta2 = nan(8774037,1,'single');
% % Ta3 = nan(8774037,1,'single');
% % Td1 = nan(8774037,1,'single');
% % Td2 = nan(8774037,1,'single');
% % Td3 = nan(8774037,1,'single');
% % Pr1 = nan(8774037,1,'single');
% % Pr2 = nan(8774037,1,'single');
% % Pr3 = nan(8774037,1,'single');
% % Rs1 = nan(8774037,1,'single');
% % Rs2 = nan(8774037,1,'single');
% % Rs3 = nan(8774037,1,'single');
% % Rg1 = nan(8774037,1,'single');
% % Rg2 = nan(8774037,1,'single');
% % Rg3 = nan(8774037,1,'single');
% % PAR1 = nan(8774037,1,'single');
% % PAR2 = nan(8774037,1,'single');
% % PAR3 = nan(8774037,1,'single');
% % Ca1 = nan(8774037,1,'single');
% % Ca2 = nan(8774037,1,'single');
% % Ca3 = nan(8774037,1,'single');
% chi1 = nan(8774037,1,'single');
% chi2 = nan(8774037,1,'single');
% chi3 = nan(8774037,1,'single');
% % NDVI1 = nan(8774037,1,'single');
% % NDVI2 = nan(8774037,1,'single');
% % NDVI3 = nan(8774037,1,'single');
% % DOY1 = nan(8774037,1,'single');
% % DOY2 = nan(8774037,1,'single');
% % DOY3 = nan(8774037,1,'single');
% Month1 = importdata('/bess19/Yulin/BESSv2/Month_Ta1.mat');
% Month2 = importdata('/bess19/Yulin/BESSv2/Month_Ta2.mat');
% Month3 = importdata('/bess19/Yulin/BESSv2/Month_Ta3.mat');
% % LAT = importdata('/bess/JCY/BESSv2/Ancillary/LAT.005d.mat');
% for month = 1:12
%     month
%     % raw = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax_Clim_/Vcmax_Clim_.%02d.mat',month));
%     % msk = Month1 == month;
%     % Vcmax1(msk) = raw(msk);
%     % msk = Month2 == month;
%     % Vcmax2(msk) = raw(msk);
%     % msk = Month3 == month;
%     % Vcmax3(msk) = raw(msk);
%     % raw = importdata(sprintf('/bess/JCY/BESSv2/Ta_Clim/Ta_Clim.%02d.mat',month));
%     % msk = Month1 == month;
%     % Ta1(msk) = raw(msk);
%     % msk = Month2 == month;
%     % Ta2(msk) = raw(msk);
%     % msk = Month3 == month;
%     % Ta3(msk) = raw(msk);
%     % raw = importdata(sprintf('/bess/JCY/BESSv2/Td_Clim/Td_Clim.%02d.mat',month));
%     % msk = Month1 == month;
%     % Td1(msk) = raw(msk);
%     % msk = Month2 == month;
%     % Td2(msk) = raw(msk);
%     % msk = Month3 == month;
%     % Td3(msk) = raw(msk);
%     % raw = importdata(sprintf('/bess/JCY/BESSv2/Pr_Clim/Pr_Clim.%02d.mat',month));
%     % msk = Month1 == month;
%     % Pr1(msk) = raw(msk);
%     % msk = Month2 == month;
%     % Pr2(msk) = raw(msk);
%     % msk = Month3 == month;
%     % Pr3(msk) = raw(msk);
%     % raw = importdata(sprintf('/bess/JCY/BESSv2/Rs_Clim/Rs_Clim.%02d.mat',month));
%     % msk = Month1 == month;
%     % Rs1(msk) = raw(msk);
%     % msk = Month2 == month;
%     % Rs2(msk) = raw(msk);
%     % msk = Month3 == month;
%     % Rs3(msk) = raw(msk);
%     % raw = importdata(sprintf('/bess/JCY/Radiation/Rg_Clim/Rg_Clim.%02d.mat',month));
%     % msk = Month1 == month;
%     % Rg1(msk) = raw(msk);
%     % msk = Month2 == month;
%     % Rg2(msk) = raw(msk);
%     % msk = Month3 == month;
%     % Rg3(msk) = raw(msk);
%     % raw = importdata(sprintf('/bess/JCY/Radiation/PAR_Clim/PAR_Clim.%02d.mat',month));
%     % msk = Month1 == month;
%     % PAR1(msk) = raw(msk);
%     % msk = Month2 == month;
%     % PAR2(msk) = raw(msk);
%     % msk = Month3 == month;
%     % PAR3(msk) = raw(msk);
%     % raw = importdata(sprintf('/bess/JCY/BESSv2/Ca_Clim/Ca_Clim.%02d.mat',month));
%     % msk = Month1 == month;
%     % Ca1(msk) = raw(msk);
%     % msk = Month2 == month;
%     % Ca2(msk) = raw(msk);
%     % msk = Month3 == month;
%     % Ca3(msk) = raw(msk);
%     % raw = importdata(sprintf('/bess/JCY/BESSv2/NDVI_MCD^_Climatology/NDVI_MCD^_Climatology.%02d.mat',month));
%     % msk = Month1 == month;
%     % NDVI1(msk) = raw(msk);
%     % msk = Month2 == month;
%     % NDVI2(msk) = raw(msk);
%     % msk = Month3 == month;
%     % NDVI3(msk) = raw(msk);
%     % doy = [16.0,45.5,75.0,105.5,136.0,166.5,197.0,228.0,258.5,289.0,319.5,350.0];
%     % msk = Month1 == month;
%     % DOY1(msk) = doy(month);
%     % msk = Month2 == month;
%     % DOY2(msk) = doy(month);
%     % msk = Month3 == month;
%     % DOY3(msk) = doy(month);
% % end
% % data = nanmean(cat(2,Vcmax1,Vcmax2,Vcmax3),2);
% % save('/bess19/Yulin/BESSv2/Vcmax_Peak.mat','data');
% % data = nanmean(cat(2,Ta1,Ta2,Ta3),2);
% % save('/bess19/Yulin/BESSv2/Ta_Peak.mat','data');
% % data = nanmean(cat(2,Pr1,Pr2,Pr3),2);
% % save('/bess19/Yulin/BESSv2/Pr_Peak.mat','data');
% % data = nanmean(cat(2,Rs1,Rs2,Rs3),2);
% % save('/bess19/Yulin/BESSv2/Rs_Peak.mat','data');
% % data = nanmean(cat(2,Rg1,Rg2,Rg3),2);
% % save('/bess19/Yulin/BESSv2/Rg_Peak.mat','data');
% % data = nanmean(cat(2,PAR1,PAR2,PAR3),2);
% % save('/bess19/Yulin/BESSv2/PAR_Peak.mat','data');
% % data = nanmean(cat(2,Ca1,Ca2,Ca3),2);
% % save('/bess19/Yulin/BESSv2/Ca_Peak.mat','data');
% % data = nanmean(cat(2,NDVI1,NDVI2,NDVI3),2);
% % save('/bess19/Yulin/BESSv2/NDVI_Peak.mat','data');
% % % air temperature in Celsius
% % TaC1 = Ta1 - 273.16;    % [Celsius]
% % % dewpoint temperature in Celsius
% % TdC1 = Td1 - 273.16;    % [Celsius]
% % % ambient vapour pressure
% % ea1 = 0.6108 * exp((17.27*TdC1)./(TdC1+237.3)) * 1000;    % [Pa]
% % % saturated vapour pressure
% % es1 = 0.6108 * exp((17.27*TaC1)./(TaC1+237.3)) * 1000;    % [Pa]
% % % water vapour deficit
% % VPD1 = es1 - ea1;    % [Pa]
% % % relative humidity
% % RH1 = ea1 ./ es1;    % [-]
% % % air temperature in Celsius
% % TaC2 = Ta2 - 273.16;    % [Celsius]
% % % dewpoint temperature in Celsius
% % TdC2 = Td2 - 273.16;    % [Celsius]
% % % ambient vapour pressure
% % ea2 = 0.6108 * exp((17.27*TdC2)./(TdC2+237.3)) * 1000;    % [Pa]
% % % saturated vapour pressure
% % es2 = 0.6108 * exp((17.27*TaC2)./(TaC2+237.3)) * 1000;    % [Pa]
% % % water vapour deficit
% % VPD2 = es2 - ea2;    % [Pa]
% % % relative humidity
% % RH2 = ea2 ./ es2;    % [-]
% % % air temperature in Celsius
% % TaC3 = Ta3 - 273.16;    % [Celsius]
% % % dewpoint temperature in Celsius
% % TdC3 = Td3 - 273.16;    % [Celsius]
% % % ambient vapour pressure
% % ea3 = 0.6108 * exp((17.27*TdC3)./(TdC3+237.3)) * 1000;    % [Pa]
% % % saturated vapour pressure
% % es3 = 0.6108 * exp((17.27*TaC3)./(TaC3+237.3)) * 1000;    % [Pa]
% % % water vapour deficit
% % VPD3 = es3 - ea3;    % [Pa]
% % % relative humidity
% % RH3 = ea3 ./ es3;    % [-]
% % data = nanmean(cat(2,VPD1,VPD2,VPD3),2);
% % save('/bess19/Yulin/BESSv2/VPD_Peak.mat','data');
% % data = nanmean(cat(2,RH1,RH2,RH3),2);
% % save('/bess19/Yulin/BESSv2/RH_Peak.mat','data');
% % % inverse relative distance Earth-Sun
% % dr1 = 1 + 0.033*cos(2*pi/365*DOY1);    % [-]
% % % solar declination
% % delta1 = 0.409 * sin(2*pi/365*DOY1-1.39);    % [rad]
% % % sunset hour angle
% % omegaS1 = acos(-tand(LAT).*tan(delta1));    % [rad]
% % omegaS1(isnan(omegaS1)|isinf(omegaS1)) = 0;
% % omegaS1 = real(omegaS1); 
% % % Day length
% % DL1 = 24/pi * omegaS1; 
% % % inverse relative distance Earth-Sun
% % dr2 = 1 + 0.033*cos(2*pi/365*DOY2);    % [-]
% % % solar declination
% % delta2 = 0.409 * sin(2*pi/365*DOY2-1.39);    % [rad]
% % % sunset hour angle
% % omegaS2 = acos(-tand(LAT).*tan(delta2));    % [rad]
% % omegaS2(isnan(omegaS2)|isinf(omegaS2)) = 0;
% % omegaS2 = real(omegaS2); 
% % % Day length
% % DL2 = 24/pi * omegaS2; 
% % % inverse relative distance Earth-Sun
% % dr3 = 1 + 0.033*cos(2*pi/365*DOY3);    % [-]
% % % solar declination
% % delta3 = 0.409 * sin(2*pi/365*DOY3-1.39);    % [rad]
% % % sunset hour angle
% % omegaS3 = acos(-tand(LAT).*tan(delta3));    % [rad]
% % omegaS3(isnan(omegaS3)|isinf(omegaS3)) = 0;
% % omegaS3 = real(omegaS3); 
% % % Day length
% % DL3 = 24/pi * omegaS3; 
% % data = nanmean(cat(2,DL1,DL2,DL3),2);
% % save('/bess19/Yulin/BESSv2/DL_Peak.mat','data');
% 
% 
% 
% 
% 
%  
%         
% 
% % series = nan(8774037,17,'single');
% % for year = 2001:2017
%     % series(:,year-2000) = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax25_Max/Vcmax25_Max.%d.mat',year));
% % end 
% 
% % series = nan(8774037,17,'single');
% % for year = 2001:2017
%     % series(:,year-2000) = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax25_Peak/Vcmax25_Peak.%d.mat',year));
% % end 
% 
% % series = nan(8774037,17,'single');
% % for year = 2001:2017
%     % series(:,year-2000) = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax25_Top3/Vcmax25_Top3.%d.mat',year));
% % end  
% 
% 
% 
% 
% 
% % series = nan(8774037,17,'single');
% % for year = 2001:2017
%     % series(:,year-2000) = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax_Peak/Vcmax_Peak.%d.mat',year));
% % end
% % data = nanmedian(series,2);
% % save('/bess19/Yulin/BESSv2/Vcmax_Peak.mat','data');   
% 
% 
% % series = nan(8774037,17,'single');
% % for year = 2001:2017
%     % series(:,year-2000) = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax25_Top3/Vcmax25_Top3.%d.mat',year));
% % end
% % data = nanmedian(series,2);
% % save('/bess19/Yulin/BESSv2/Vcmax25_Top3.mat','data');    
% 
% % series = nan(8774037,17,'single');
% % for year = 2001:2017
%     % series(:,year-2000) = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax_Top3/Vcmax_Top3.%d.mat',year));
% % end
% % data = nanmedian(series,2);
% % save('/bess19/Yulin/BESSv2/Vcmax_Top3.mat','data');   
% 
% 
% 
% 
% % series = nan(8774037,12,'single');
% % for year = years
%     % series(:) = nan;
%     % for month = 1:12
%         % [year,month]
%         % raw = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax25_Monthly/Vcmax25_Monthly.%d.%02d.mat',year,month));
%         % T = importdata(sprintf('/bess/JCY/BESSv2/Ta_Monthly/Ta_Monthly.%d.%02d.mat',year,month)) - 273.16;
%         % raw(T<=10) = nan;
%         % series(:,month) = raw;
%     % end
%     % data = nanmean(series,2);
%     % save(sprintf('/bess19/Yulin/BESSv2/Vcmax25_Annual10/Vcmax25_Annual10.%d.mat',year),'data');
% % end 
% 
% % series = nan(8774037,12,'single');
% % for year = years
%     % series(:) = nan;
%     % for month = 1:12
%         % [year,month]
%         % raw = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax25_Monthly/Vcmax25_Monthly.%d.%02d.mat',year,month));
%         % T = importdata(sprintf('/bess/JCY/BESSv2/Ta_Monthly/Ta_Monthly.%d.%02d.mat',year,month)) - 273.16;
%         % raw(T<=5) = nan;
%         % series(:,month) = raw;
%     % end
%     % data = nanmean(series,2);
%     % save(sprintf('/bess19/Yulin/BESSv2/Vcmax25_Annual5/Vcmax25_Annual5.%d.mat',year),'data');
% % end 
% 
% % series = nan(8774037,12,'single');
% % for year = years
%     % series(:) = nan;
%     % for month = 1:12
%         % [year,month]
%         % raw = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax25_Monthly/Vcmax25_Monthly.%d.%02d.mat',year,month));
%         % T = importdata(sprintf('/bess/JCY/BESSv2/Ta_Monthly/Ta_Monthly.%d.%02d.mat',year,month)) - 273.16;
%         % raw(T<=0) = nan;
%         % series(:,month) = raw;
%     % end
%     % data = nanmean(series,2);
%     % save(sprintf('/bess19/Yulin/BESSv2/Vcmax25_Annual0/Vcmax25_Annual0.%d.mat',year),'data');
% % end 
% 
% 
% 
% % for year = years
%     % data1 = nan(8774037,1,'single');
%     % data2 = nan(8774037,1,'single');
%     % data3 = nan(8774037,1,'single');
%     % month1 = importdata(sprintf('/bess19/Yulin/BESSv2/Ta_Month1/Ta_Month1.%d.mat',year));
%     % month2 = importdata(sprintf('/bess19/Yulin/BESSv2/Ta_Month2/Ta_Month2.%d.mat',year));
%     % month3 = importdata(sprintf('/bess19/Yulin/BESSv2/Ta_Month3/Ta_Month3.%d.mat',year));
%     % for month = 1:12
%         % [year,month]
%         % raw = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax25_Monthly/Vcmax25_Monthly.%d.%02d.mat',year,month));    
%         % data1(month1==month) = raw(month1==month);
%         % data2(month2==month) = raw(month2==month);
%         % data3(month3==month) = raw(month3==month);
%     % end
%     % data = nanmean(cat(2,data1,data2,data3),2);
%     % save(sprintf('/bess19/Yulin/BESSv2/Vcmax25_Ta3/Vcmax25_Ta3.%d.mat',year),'data');
% % end 
% 
% % for year = years
%     % data1 = nan(8774037,1,'single');
%     % data2 = nan(8774037,1,'single');
%     % data3 = nan(8774037,1,'single');
%     % month1 = importdata(sprintf('/bess19/Yulin/BESSv2/Ta_Month1/Ta_Month1.%d.mat',year));
%     % month2 = importdata(sprintf('/bess19/Yulin/BESSv2/Ta_Month2/Ta_Month2.%d.mat',year));
%     % month3 = importdata(sprintf('/bess19/Yulin/BESSv2/Ta_Month3/Ta_Month3.%d.mat',year));
%     % for month = 1:12
%         % [year,month]
%         % raw = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax_Monthly/Vcmax_Monthly.%d.%02d.mat',year,month));    
%         % data1(month1==month) = raw(month1==month);
%         % data2(month2==month) = raw(month2==month);
%         % data3(month3==month) = raw(month3==month);
%     % end
%     % data = nanmean(cat(2,data1,data2,data3),2);
%     % save(sprintf('/bess19/Yulin/BESSv2/Vcmax_Ta3/Vcmax_Ta3.%d.mat',year),'data');
% % end 
% 
% % series = nan(8774037,17,'single');
% % for year = 2001:2017
%     % series(:,year-2000) = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax25_Ta3/Vcmax25_Ta3.%d.mat',year));
% % end
% % data = nanmedian(series,2);
% % save('/bess19/Yulin/BESSv2/Vcmax25_Ta3.mat','data');    
% 
% % series = nan(8774037,17,'single');
% % for year = 2001:2017
%     % series(:,year-2000) = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax_Ta3/Vcmax_Ta3.%d.mat',year));
% % end
% % data = nanmedian(series,2);
% % save('/bess19/Yulin/BESSv2/Vcmax_Ta3.mat','data');    
% 
% 
% 
% % for year = years
%     % data1 = nan(8774037,1,'single');
%     % data2 = nan(8774037,1,'single');
%     % data3 = nan(8774037,1,'single');
%     % month1 = importdata(sprintf('/bess19/Yulin/BESSv2/NDVI_Month1/NDVI_Month1.%d.mat',year));
%     % month2 = importdata(sprintf('/bess19/Yulin/BESSv2/NDVI_Month2/NDVI_Month2.%d.mat',year));
%     % month3 = importdata(sprintf('/bess19/Yulin/BESSv2/NDVI_Month3/NDVI_Month3.%d.mat',year));
%     % for month = 1:12
%         % [year,month]
%         % raw = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax25_Monthly/Vcmax25_Monthly.%d.%02d.mat',year,month));    
%         % data1(month1==month) = raw(month1==month);
%         % data2(month2==month) = raw(month2==month);
%         % data3(month3==month) = raw(month3==month);
%     % end
%     % data = nanmean(cat(2,data1,data2,data3),2);
%     % save(sprintf('/bess19/Yulin/BESSv2/Vcmax25_NDVI3/Vcmax25_NDVI3.%d.mat',year),'data');
% % end 
% 
% % for year = years
%     % data1 = nan(8774037,1,'single');
%     % data2 = nan(8774037,1,'single');
%     % data3 = nan(8774037,1,'single');
%     % month1 = importdata(sprintf('/bess19/Yulin/BESSv2/NDVI_Month1/NDVI_Month1.%d.mat',year));
%     % month2 = importdata(sprintf('/bess19/Yulin/BESSv2/NDVI_Month2/NDVI_Month2.%d.mat',year));
%     % month3 = importdata(sprintf('/bess19/Yulin/BESSv2/NDVI_Month3/NDVI_Month3.%d.mat',year));
%     % for month = 1:12
%         % [year,month]
%         % raw = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax_Monthly/Vcmax_Monthly.%d.%02d.mat',year,month));    
%         % data1(month1==month) = raw(month1==month);
%         % data2(month2==month) = raw(month2==month);
%         % data3(month3==month) = raw(month3==month);
%     % end
%     % data = nanmean(cat(2,data1,data2,data3),2);
%     % save(sprintf('/bess19/Yulin/BESSv2/Vcmax_NDVI3/Vcmax_NDVI3.%d.mat',year),'data');
% % end 
% 
% % series = nan(8774037,17,'single');
% % for year = 2001:2017
%     % series(:,year-2000) = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax25_NDVI3/Vcmax25_NDVI3.%d.mat',year));
% % end
% % data = nanmedian(series,2);
% % save('/bess19/Yulin/BESSv2/Vcmax25_NDVI3.mat','data');    
% 
% % series = nan(8774037,17,'single');
% % for year = 2001:2017
%     % series(:,year-2000) = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax_NDVI3/Vcmax_NDVI3.%d.mat',year));
% % end
% % data = nanmedian(series,2);
% % save('/bess19/Yulin/BESSv2/Vcmax_NDVI3.mat','data');    
% 
% 
% % for year = years
%     % sum = zeros(8774037,1,'single');
%     % cnt = zeros(8774037,1,'single');
%     % for doy = 1:366
%         % if doy == 366 & ~leapyear(year)
%             % continue;
%         % end
%         % disp(sprintf('%d%03d',year,doy));
%         % raw = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax25/Vcmax25.%d.%03d.mat',year,doy));
%         % msk = importdata(sprintf('/bess19/Yulin/BESSv2/GS_VIPEVI2/GS_VIPEVI2.%d.%03d.mat',year,doy));
%         % raw(~msk|isnan(raw)) = 0;
%         % sum = sum + raw;
%         % cnt = cnt + (raw>0);
%     % end
%     % data = sum ./ cnt;
%     % save(sprintf('/bess19/Yulin/BESSv2/Vcmax25_VIPEVI2/Vcmax25_VIPEVI2.%d.mat',year),'data');
% % end
% 
% % for year = years
%     % sum = zeros(8774037,1,'single');
%     % cnt = zeros(8774037,1,'single');
%     % for doy = 1:366
%         % if doy == 366 & ~leapyear(year)
%             % continue;
%         % end
%         % disp(sprintf('%d%03d',year,doy));
%         % raw = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax25/Vcmax25.%d.%03d.mat',year,doy));
%         % msk = importdata(sprintf('/bess19/Yulin/BESSv2/GS_VIPNDVI/GS_VIPNDVI.%d.%03d.mat',year,doy));
%         % raw(~msk|isnan(raw)) = 0;
%         % sum = sum + raw;
%         % cnt = cnt + (raw>0);
%     % end
%     % data = sum ./ cnt;
%     % save(sprintf('/bess19/Yulin/BESSv2/Vcmax25_VIPNDVI/Vcmax25_VIPNDVI.%d.mat',year),'data');
% % end
% 
% 
% % series = nan(8774037,17,'single');
% % for year = 2001:2017
%     % series(:,year-2000) = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax25_Annual10/Vcmax25_Annual10.%d.mat',year));
% % end
% % data = nanmedian(series,2);
% % save('/bess19/Yulin/BESSv2/Vcmax25_Annual10.mat','data');    
% 
% % series = nan(8774037,17,'single');
% % for year = 2001:2017
%     % series(:,year-2000) = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax25_Annual5/Vcmax25_Annual5.%d.mat',year));
% % end
% % data = nanmedian(series,2);
% % save('/bess19/Yulin/BESSv2/Vcmax25_Annual5.mat','data');    
% 
% % series = nan(8774037,17,'single');
% % for year = 2001:2017
%     % series(:,year-2000) = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax25_Annual0/Vcmax25_Annual0.%d.mat',year));
% % end
% % data = nanmedian(series,2);
% % save('/bess19/Yulin/BESSv2/Vcmax25_Annual0.mat','data');    
% 
% 
% % series = nan(8774037,14,'single');
% % for year = 2001:2014
%     % series(:,year-2000) = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax25_VIPEVI2/Vcmax25_VIPEVI2.%d.mat',year));
% % end
% % data = nanmedian(series,2);
% % save('/bess19/Yulin/BESSv2/Vcmax25_VIPEVI2.mat','data');    
% 
% % series = nan(8774037,14,'single');
% % for year = 2001:2014
%     % series(:,year-2000) = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax25_VIPNDVI/Vcmax25_VIPNDVI.%d.mat',year));
% % end
% % data = nanmedian(series,2);
% % save('/bess19/Yulin/BESSv2/Vcmax25_VIPNDVI.mat','data');    
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% % SERIES = nan(8774037,12,'single');
% % series = nan(8774037,17,'single');
% % for month = 1:12
%     % series(:) = nan;
%     % for year = 2001:2017
%         % [year,month]
%         % raw = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax25_Monthly/Vcmax25_Monthly.%d.%02d.mat',year,month));
%         % T = importdata(sprintf('/bess/JCY/BESSv2/Ta_Monthly/Ta_Monthly.%d.%02d.mat',year,month)) - 273.16;
%         % raw(T<=10) = nan;
%         % series(:,year-2000) = raw;
%     % end
%     % data = nanmean(series,2);
%     % save(sprintf('/bess19/Yulin/BESSv2/Vcmax25_Clim10/Vcmax25_Clim10.%02d.mat',month),'data');
%     % SERIES(:,month) = data;
% % end  
% % data = nanmax(SERIES,[],2);
% % save('/bess19/Yulin/BESSv2/Vcmax25_Max10.mat','data');  
%  
% % series = nan(8774037,14,'single');
% % for year = 2001:2014
%     % series(:,year-2000) = importdata(sprintf('/environment/Chongya/Vcmax25/Vcmax25_VIPEVI2/Vcmax25_VIPEVI2.%d.mat',year));
% % end
% % data = nanmean(series,2); 
% % save('/environment/Chongya/Vcmax25/Vcmax25_VIPEVI2/Vcmax25_VIPEVI2.mat','data');
%     
% % for year = 2001:2014
%     % sum = zeros(8774037,1,'single');
%     % cnt = zeros(8774037,1,'single');
%     % for doy = 1:366
%         % if doy == 366 & ~leapyear(year)
%             % continue;
%         % end
%         % disp(sprintf('%d%03d',year,doy));
%         % raw = importdata(sprintf('/environment/Chongya/Vcmax25/Vcmax25/Vcmax25.%d.%03d.mat',year,doy));
%         % msk = importdata(sprintf('/environment/Chongya/Vcmax25/GS_VIPNDVI/GS_VIPNDVI.%d.%03d.mat',year,doy));
%         % raw(~msk|isnan(raw)) = 0;
%         % sum = sum + raw;
%         % cnt = cnt + (raw>0);
%     % end
%     % data = sum ./ cnt;
%     % save(sprintf('/environment/Chongya/Vcmax25/Vcmax25_VIPNDVI/Vcmax25_VIPNDVI.%d.mat',year),'data');
% % end
% % series = nan(8774037,14,'single');
% % for year = 2001:2014
%     % series(:,year-2000) = importdata(sprintf('/environment/Chongya/Vcmax25/Vcmax25_VIPNDVI/Vcmax25_VIPNDVI.%d.mat',year));
% % end
% % data = nanmean(series,2);  
% % save('/environment/Chongya/Vcmax25/Vcmax25_VIPNDVI/Vcmax25_VIPNDVI.mat','data');
% 
% 
% 
% 
% % years = 2001:2017;
% % months = 1:12;
% 
% % series = nan(8774037,31,'single');
% % Climate = importdata('/bess/JCY/BESSv2/Ancillary/Climate.005d.mat');
% % for year = years
%     % for month = months
%         % disp(sprintf('%d%02d',year,month));
%         % series(:) = nan;
%         % for day = 1:31
%             % vec = datevec(datenum(year,month,day));
%             % if vec(2) == month
%                 % doy = datenum(year,month,day) - datenum(year,1,1) + 1;
%                 % raw = importdata(sprintf('/environment/Chongya/Vcmax25/Vcmax/Vcmax.%d.%03d.mat',year,doy));
%             % end
%             % series(:,day) = raw;
%         % end
%         % data = nanmean(series,2);
%         % save(sprintf('/bess19/Yulin/BESSv2/Vcmax_Monthly/Vcmax_Monthly.%d.%02d.mat',year,month),'data');
%     % end
% % end
% 
% % SERIES = nan(8774037,17,'single');
% % series = nan(8774037,12,'single');
% % for year = 2001:2017
%     % series(:) = nan;
%     % for month = 1:12
%         % [year,month]
%         % raw = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax_Monthly/Vcmax_Monthly.%d.%02d.mat',year,month));
%         % T = importdata(sprintf('/bess/JCY/BESSv2/Ta_Monthly/Ta_Monthly.%d.%02d.mat',year,month)) - 273.16;
%         % raw(T<=10) = nan;
%         % series(:,month) = raw;
%     % end
%     % data = nanmean(series,2);
%     % save(sprintf('/bess19/Yulin/BESSv2/Vcmax_Annual10/Vcmax_Annual10.%d.mat',year),'data');
%     % SERIES(:,year-2000) = data;
% % end    
% % data = nanmean(SERIES,2);
% % save('/bess19/Yulin/BESSv2/Vcmax_Mean10.mat','data');
% 
% % SERIES = nan(8774037,12,'single');
% % series = nan(8774037,17,'single');
% % for month = 1:12
%     % series(:) = nan;
%     % for year = 2001:2017
%         % [year,month]
%         % raw = importdata(sprintf('/bess19/Yulin/BESSv2/Vcmax_Monthly/Vcmax_Monthly.%d.%02d.mat',year,month));
%         % T = importdata(sprintf('/bess/JCY/BESSv2/Ta_Monthly/Ta_Monthly.%d.%02d.mat',year,month)) - 273.16;
%         % raw(T<=10) = nan;
%         % series(:,year-2000) = raw;
%     % end
%     % data = nanmean(series,2);
%     % save(sprintf('/bess19/Yulin/BESSv2/Vcmax_Clim10/Vcmax_Clim10.%02d.mat',month),'data');
%     % SERIES(:,month) = data;
% % end  
% % data = nanmax(SERIES,[],2);
% % save('/bess19/Yulin/BESSv2/Vcmax_Max10.mat','data');  
%  
% 
% 
% % years = 2001:2017;
% % months = 1:12;
% 
% % series = nan(8774037,31,'single');
% % Climate = importdata('/bess/JCY/BESSv2/Ancillary/Climate.005d.mat');
% % for year = years
%     % for month = months
%         % disp(sprintf('%d%02d',year,month));
%         % series(:) = nan;
%         % for day = 1:31
%             % vec = datevec(datenum(year,month,day));
%             % if vec(2) == month
%                 % doy = datenum(year,month,day) - datenum(year,1,1) + 1;
%                 % raw = importdata(sprintf('/environment/Chongya/Vcmax25/chi/chi.%d.%03d.mat',year,doy));
%             % end
%             % series(:,day) = raw;
%         % end
%         % data = nanmean(series,2);
%         % save(sprintf('/bess19/Yulin/BESSv2/chi_Monthly/chi_Monthly.%d.%02d.mat',year,month),'data');
%     % end
% % end
% 
% % SERIES = nan(8774037,17,'single');
% % series = nan(8774037,12,'single');
% % for year = 2001:2017
%     % series(:) = nan;
%     % for month = 1:12
%         % [year,month]
%         % raw = importdata(sprintf('/bess19/Yulin/BESSv2/chi_Monthly/chi_Monthly.%d.%02d.mat',year,month));
%         % T = importdata(sprintf('/bess/JCY/BESSv2/Ta_Monthly/Ta_Monthly.%d.%02d.mat',year,month)) - 273.16;
%         % raw(T<=10) = nan;
%         % series(:,month) = raw;
%     % end
%     % data = nanmean(series,2);
%     % save(sprintf('/bess19/Yulin/BESSv2/chi_Annual10/chi_Annual10.%d.mat',year),'data');
%     % SERIES(:,year-2000) = data;
% % end    
% % data = nanmean(SERIES,2);
% % save('/bess19/Yulin/BESSv2/chi_Mean10.mat','data');
% 
% % vars = {'PAR','Ta','VPD','FPARCorr'};
% % for i = 1:length(vars)
%     % ds = vars{i};
%     % series = nan(8774037,17,'single');
%     % for year = 2001:2017
%         % [year,month]
%         % series(:,year-2000) = importdata(sprintf('/bess19/Yulin/BESSv2/%s_Ta3/%s_Ta3.%d.mat',year));
%     % end
% % end  
% % data = nanmean(series,2);
% 
% 
% Month1 = importdata('/bess19/Yulin/BESSv2/Month_Ta1.mat');
% Month2 = importdata('/bess19/Yulin/BESSv2/Month_Ta2.mat');
% Month3 = importdata('/bess19/Yulin/BESSv2/Month_Ta3.mat');
% 
% vars = {'PAR','Ta','VPD','FPARCorr'};
% for i = 4%1:length(vars)
%     ds = vars{i};
%     clim1 = nan(8774037,1,'single');
%     clim2 = nan(8774037,1,'single');
%     clim3 = nan(8774037,1,'single');
%     for month = 1:12
%         month
%         if i ==4 
%             raw = importdata(sprintf('/bess19/Yulin/BESSv2/%s_Clim/%s_Clim.%02d.mat',ds,ds,month));
%         else    
%             raw = importdata(sprintf('/bess/JCY/BESSv2/%s_Clim/%s_Clim.%02d.mat',ds,ds,month));
%         end   
%         msk = Month1 == month;
%         clim1(msk) = raw(msk);
%         msk = Month2 == month;
%         clim2(msk) = raw(msk);
%         msk = Month3 == month;
%         clim3(msk) = raw(msk);
%     end
%     data = nanmean(cat(2,clim1,clim2,clim3),2);
%     save(sprintf('/bess19/Yulin/BESSv2/%s_Ta3.mat',ds),'data');
% end
