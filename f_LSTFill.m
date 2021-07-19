function f_LSTFill(ds,year,month,opt) 
	year=double(year)
	month = double(month)
    % Prepare
    MSK = importdata('/bess19/Yulin/BESSv2/Ancillary/Landmask.005d.mat');
    DATA = nan(size(MSK),'single');
    snapshots = nan(720,1440,9,'single');
    snapshot = nan(720,1440,'single'); 
    path = '/bess19/Yulin/BESSv2/NOAH21';
    path_ = '/bess19/Yulin/BESSv2/NOAH20';
    var = 'AvgSurfT_inst';
    r = 0.25;
    l = r / 0.05;
    if strfind(ds,'MOD')
        sate = 'MOD';
        time = 'AM';
    elseif strfind(ds,'MYD')
        sate = 'MYD';
        time = 'PM';
    end
     
    % Overpass time (local time)
    msk = importdata('/bess19/Yulin/BESSv2/Ancillary/Landmask.005d.mat');
    DATA = nan(size(msk),'single');
    DATA(msk) = importdata(sprintf('/bess19/Yulin/BESSv2/Ancillary/Overpass%s.005d.mat',sate));
    overpass = f_Aggregate(DATA,l);
    
    % Overpass time (UTC)
    [LON,~] = meshgrid(-180+r/2:r:180-r/2,90-r/2:-r:-90+r/2);
    UTC = overpass - LON/15; 
    UTC(UTC>=24) = UTC(UTC>=24) - 24;
    UTC(UTC<0) = UTC(UTC<0) + 24;
    
    % Calculate slope for linear interpolation
    scale = UTC / 3 + 1;
    alf = scale - floor(scale);
    
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
            % Read reanalysis data (0:00 ~ 24:00)
            snapshots(:) = nan;
            try
                raw = importdata(sprintf('%s/%d.%02d/%s.%d.%02d.%02d.mat',path,year,month,var,year,month,day));
                raw_ = importdata(sprintf('%s/%d.%02d/%s.%d.%02d.%02d.mat',path,year_,month_,var,year_,month_,day_));
                version = 21;
            catch
                load(sprintf('/bess/JCY/BESSv2/0Calibration/LST_NOAH20_NOAH21.mat'));
                raw = importdata(sprintf('%s/%d.%02d/%s.%d.%02d.%02d.mat',path_,year,month,var,year,month,day));
                raw_ = importdata(sprintf('%s/%d.%02d/%s.%d.%02d.%02d.mat',path_,year_,month_,var,year_,month_,day_));
                version = 20;
            end 
            for i = 1:8
                if version == 21
                    temp = squeeze(raw(i,:,:));
                elseif version == 20
                    temp = slope(1:600,:).*squeeze(raw(i,:,:)) + intercept(1:600,:);
                    upper = prctile(temp(:),99);
                    lower = prctile(temp(:),1);
                    temp(temp>upper) = upper;
                    temp(temp<lower) = lower;
                end
                snapshots(1:600,:,i) = temp;
            end
            if version == 21
                temp = squeeze(raw(i,:,:));
            elseif version == 20
                temp = slope(1:600,:).*squeeze(raw(i,:,:)) + intercept(1:600,:);
                upper = prctile(temp(:),99);
                lower = prctile(temp(:),1);
                temp(temp>upper) = upper;
                temp(temp<lower) = lower;
            end    
            snapshots(1:600,:,9) = temp;
            
            % Temporally interpolate to MODIS overpass time
            for i = 1:8 
                msk = floor(scale) == i;
                snapshot0 = snapshots(:,:,i);
                snapshot_ = snapshots(:,:,i+1);
                snapshot(msk) = snapshot0(msk) + alf(msk).*(snapshot_(msk)-snapshot0(msk));
            end
            % Fill gaps using nearest neighbour sampling
            msk = isnan(snapshot);
            [~,ind] = bwdist(~msk);
            snapshot(msk) = snapshot(ind(msk));
            snapshot(601:end,:) = nan;
            % 
            temp = snapshot;
            % Spatially interpolate to MODIS resolution
            data = imresize(temp,size(MSK),'nearest');
            data = ndnanfilter(data,'hamming',[l,l]); 
            data = data(MSK);
            % Read MODIS data
            MODIS = nan(size(MSK(MSK)),'single');
            try
                daily = importdata(sprintf('/bess19/Yulin/BESSv2/LST_%s^/LST_%s^.%d.%03d.mat',sate,sate,year,doy));
                MODIS = daily;
            end
            try
                monthly = importdata(sprintf('/bess19/Yulin/BESSv2/LST_%s^_Monthly/LST_%s^_Monthly.%d.%02d.mat',sate,sate,year,month));
                msk = isnan(MODIS);
                MODIS(msk) = monthly(msk);
            end 
            sprintf('/bess19/Yulin/BESSv2/LST_%s^_Climatology/LST_%s^_Climatology.%02d.mat',sate,sate,month)
			climatology = importdata(sprintf('/bess19/Yulin/BESSv2/LST_%s^_Climatology/LST_%s^_Climatology.%02d.mat',sate,sate,month));
            msk = isnan(MODIS);
            MODIS(msk) = climatology(msk);
            DATA(MSK) = MODIS;
            % Aggregate to reanalysis resolution
            TEMP = f_Aggregate(DATA,l);
            c = temp ./ TEMP; 
            upper = prctile(c(:),99);
            lower = prctile(c(:),1);
            c(c>upper) = upper;
            c(c<lower) = lower;
            C = imresize(c,size(DATA),'nearest');
            C = ndnanfilter(C,'hamming',[l,l]); 
            raw = DATA .* C;
            % Fill Antarctica using interpolation
            Antarctica = double(TEMP(601:end,:));
            [col,row] = meshgrid(1:size(Antarctica,2),1:size(Antarctica,1));
            msk = isfinite(Antarctica);
            Antarctica = griddata(col(msk),row(msk),Antarctica(msk),col,row);
            raw(3001:end,:) = imresize(Antarctica,l);
            raw = raw(MSK);                  
            % Fill with MODIS data
            msk = isfinite(raw);
            data(msk) = raw(msk);
            % Write gap-filled data 
            save(sprintf('/bess19/Yulin/BESSv2/LST_%s^/LST_%s^.%d.%03d.mat',time,time,year,doy),'data');
        end
    end 
  