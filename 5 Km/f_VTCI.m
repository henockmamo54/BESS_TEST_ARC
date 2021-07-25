function f_VTCI(year,month)
	
	year= double(year);
	month= double(month) ;
    MSK = importdata('/bess19/Yulin/BESSv2/Ancillary/Landmask.005d.mat'); 
     
    % 10 NDVI belts
    NDVI0 = 0.05:0.1:0.95;
     
    for day = 1:31
        vec = datevec(datenum(year,month,day));
        if vec(2) == month
            doy = datenum(year,month,day) - datenum(year,1,1) + 1;
            % Read data
            NDVI = importdata(sprintf('/bess19/Yulin/BESSv2/NDVI_Daily^/NDVI_Daily^.%d.%03d.mat',year,doy));
            LSTAM = importdata(sprintf('/bess19/Yulin/BESSv2/LST_AM^/LST_AM^.%d.%03d.mat',year,doy));
            LSTPM = importdata(sprintf('/bess19/Yulin/BESSv2/LST_PM^/LST_PM^.%d.%03d.mat',year,doy));
            LSTNight = importdata(sprintf('/bess19/Yulin/BESSv2/LST_Night/LST_Night.%d.%03d.mat',year,doy));
            LSTd = nanmean(cat(2,LSTAM,LSTPM),2) - LSTNight;
            % LSTd = importdata(sprintf('../LSTd/LSTd.%d.%03d.mat',year,doy));
            % Build NDVI-LSTd space
            msk = NDVI>=0;
            x = NDVI(msk);
            y = LSTd(msk);
            % Identify min and max LSTd for each NDVI belt
            tmax = nan(length(NDVI0),1);
            tmin = nan(length(NDVI0),1);
            for j = 1:length(NDVI0)
                % Use 99% and 1% percentile as max and min values to mitigate noise influence
                mskNDVI = x>=NDVI0(j)-0.05 & x<NDVI0(j)+0.05;
                tmax(j) = prctile(y(mskNDVI),99);
                tmin(j) = prctile(y(mskNDVI),1);   
            end
            % Fit dry edge
            p = polyfit(NDVI0',tmax,1);
            Tmax = p(1)*NDVI + p(2); 
            % Extract wet edge
            Tmin = median(tmin); 
            % Calculate VTCI 
            VTCI = (Tmax-LSTd) ./ (Tmax-Tmin);  
            % Constraints
            VTCI(VTCI>1) = 1;
            VTCI(VTCI<0) = 0;
            % Write result
            data = VTCI; 
            save(sprintf('/bess19/Yulin/BESSv2/VTCI/VTCI.%d.%03d.mat',year,doy),'data');              
        end
    end
  