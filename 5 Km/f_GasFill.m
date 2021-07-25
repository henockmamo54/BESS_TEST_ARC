function f_GasFill(year,month,opt1,opt2)
  
    Climate = importdata('/bess19/Yulin/BESSv2/Ancillary/Climate.005d.mat');
    MSK = importdata('/bess19/Yulin/BESSv2/Ancillary/Landmask.005d.mat');
    DATA = nan(size(MSK),'single');
    snapshot = nan(240,480,'single'); 
    path = '/bess19/Yulin/BESSv2/MERRA';    
    r = 0.5;
    l = r / 0.05;
  
    if strcmp(opt1,'AOD')
        snapshots = nan(360,720,8,'single');
        var = 'AODANA';
    elseif strcmp(opt1,'WV')
        snapshots = nan(360,720,24,'single');
        var = 'TQV';
    elseif strcmp(opt1,'OZ')
        snapshots = nan(360,720,24,'single');
        var = 'TO3';
    end
    if strcmp(opt2,'MOD')
        time = 'AM';
    elseif strcmp(opt2,'MYD')
        time = 'PM';
    end
     
    % Overpass time (local time)
    DATA(MSK) = importdata(sprintf('/bess19/Yulin/BESSv2/Ancillary/Overpass%s.005d.mat',opt2));
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
            try
                % Read MODIS data
                data = importdata(sprintf('/bess19/Yulin/BESSv2/%s_%s/%s_%s.%d.%03d.mat',opt1,opt2,opt1,opt2,year,doy));
                data(data<0) = nan;
                if strcmp(opt1,'OZ')
                    data(data>prctile(data,99)) = nan;
                end
                 
                % Read reanalysis data (0:00 ~ 24:00)
                snapshots(:) = nan; 
                raw = importdata(sprintf('%s/%d.%02d/%s.%d.%02d.%02d.mat',path,year,month,var,year,month,day));
                for i = 1:size(raw,1)
                    snapshots(:,:,i) = imresize(squeeze(raw(i,:,:)),[360,720]);
                end
                % Diurnal to snapshot
                temp = nan(size(UTC),'single');
                if strcmp(opt1,'AOD')
                    id = round(UTC/3+1.5) - 1;
                    for i = 1:8
                        msk = id == i;
                        snapshot = snapshots(:,:,i);
                        temp(msk) = snapshot(msk);
                    end
                else
                    id = floor(UTC) + 1;
                    for i = 1:24
                        msk = id == i;
                        snapshot = snapshots(:,:,i);
                        temp(msk) = snapshot(msk);
                    end
                end   
                % Interpolate to MODIS resolution
                temp = imresize(temp,size(MSK),'nearest');
                temp = ndnanfilter(temp,'hamming',[l,l]); 
                temp = temp(MSK); 
                % Fill gaps in MODIS data
                coef = nan(6,1);
                mi = nan(6,1);
                ma = nan(6,1);
                msk0 = isfinite(data);
                mi0 = min(data(msk0));
                ma0 = max(data(msk0));
                x = temp(msk0);
                y = data(msk0);
                coef0 = median(y) / median(x);
                mi(:) = mi0;
                ma(:) = ma0; 
                coef(:) = coef0;  
                for i = 1:6
                    mski = Climate==i;
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
                for i = 1:6
                    mski = Climate==i;
                    msk = msk0 & mski;
                    yy = coef(i) * temp(msk);
                    yy(yy<mi(i)) = mi(i);
                    yy(yy>ma(i)) = ma(i);
                    data(msk) = yy;
                end
                % Write results
				%mkdir(sprintf('/bess19/Yulin/BESSv2/%s_%s',opt1,time));
                save(sprintf('/bess19/Yulin/BESSv2/%s_%s/%s_%s.%d.%03d.mat',opt1,time,opt1,time,year,doy),'data');
            end
        end
    end
      
                 