function f_LSTNight(year,month)
    
	year= double(year);
	month= double(month) ;
    paths = {'/bess19/Yulin/Data/MOD11C1','/bess19/Yulin/Data/MYD11C1'};
    MSK = importdata('/bess19/Yulin/BESSv2/Ancillary/Landmask.005d.mat');
    snapshots = nan(720,1440,9,'single');
    series = nan(8774037,2,'single');
    r = 0.5;
    l = r / 0.05;
    try
        IGBP = importdata(sprintf('/bess19/Yulin/BESSv2/IGBP^/IGBP^.%d.mat',year));
    catch
        try
            IGBP = importdata(sprintf('/bess19/Yulin/BESSv2/IGBP^/IGBP^.%d.mat',year-1));
        catch    
            IGBP = importdata(sprintf('/bess19/Yulin/BESSv2/IGBP^/IGBP^.%d.mat',year-2));
        end    
    end
          
    % Process day by day    
    for day = 1:31   
        % Current day
        vec = datevec(datenum(year,month,day));
        if vec(2) == month
            doy = datenum(year,month,day) - datenum(year,1,1) + 1;
            % Next day
            vec_ = datevec(datenum(year,1,doy+1)); 
            year_ = vec_(1);
            month_ = vec_(2);
            day_ = vec_(3);
            
            % Read MOD/MYD data
            for k = 1:2 
                directory = dir(sprintf('%s/%d/%03d/*.hdf',paths{k},year,doy)); 
                if length(directory) > 0
                    name = directory.name;
                    raw = hdfread(sprintf('%s/%d/%03d/%s',paths{k},year,doy,name),'LST_Night_CMG');
                    temp = single(raw(MSK));
                    temp(temp==0) = nan;
                    temp = temp * 0.02;
                    series(:,k) = temp;
                end
            end
            % Average as nighttime data
            data = nanmean(series,2);
            
            % Read reanalysis data (0:00 ~ 24:00)
            snapshots(:) = nan;
            raw = importdata(sprintf('/bess19/Yulin/BESSv2/NOAH21/%d.%02d/AvgSurfT_inst.%d.%02d.%02d.mat',year,month,year,month,day));
            raw_ = importdata(sprintf('/bess19/Yulin/BESSv2/NOAH21/%d.%02d/AvgSurfT_inst.%d.%02d.%02d.mat',year_,month_,year_,month_,day_));
            for i = 1:8
                snapshots(1:600,:,i) = squeeze(raw(i,:,:));
            end
            snapshots(1:600,:,9) = squeeze(raw_(1,:,:));
            % Calculate minimum LST
            temp = nanmin(snapshots,[],3);
            % Fill gaps using nearest neighbour sampling
            msk = isnan(temp);
            [~,ind] = bwdist(~msk);
            temp(msk) = temp(ind(msk));
            temp(601:end,:) = nan; 
            % Interpolate to MODIS resolution
            temp = imresize(temp,size(MSK),'nearest');
            temp = ndnanfilter(temp,'hamming',[l,l]); 
            temp = temp(MSK);
            
            % Fill gaps in MODIS data
            coef = nan(14,1);
            mi = nan(14,1);
            ma = nan(14,1);
            msk0 = isfinite(data) & isfinite(temp); 
            if sum(msk0) > 0
                mi0 = min(data(msk0));
                ma0 = max(data(msk0));
                x = temp(msk0);
                y = data(msk0);
                coef0 = median(y) / median(x); 
                mi(:) = mi0;
                ma(:) = ma0; 
                coef(:) = coef0;  
                for i = 1:14
                    mski = IGBP==i-1;
                    msk = msk0 & mski;
                    if sum(msk) > 2 
                        mi(i) = min(data(msk));
                        ma(i) = max(data(msk));
                        x = temp(msk); 
                        y = data(msk); 
                        coef(i) = median(y) / median(x);
                    end    
                end
                msk0 = isnan(data);
                for i = 1:14
                    mski = IGBP==i-1;
                    msk = msk0 & mski;
                    yy = coef(i) * temp(msk);
                    yy(yy<mi(i)) = mi(i);
                    yy(yy>ma(i)) = ma(i);
                    data(msk) = yy;
                end
            else
                data = temp;
            end
                
            save(sprintf('/bess19/Yulin/BESSv2/LST_Night/LST_Night.%d.%03d.mat',year,doy),'data');
        end
    end
    