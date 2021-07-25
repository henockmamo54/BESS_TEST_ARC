function f_SMDaily(year,month)
	
	year= double(year);
	month= double(month) ;
    MSK = importdata('/bess19/Yulin/BESSv2/Ancillary/Landmask.005d.mat');
    % DATA = nan(size(MSK),'single');
    % DATA(MSK) = importdata(sprintf('../SWI_Clim/SWI_Clim.%02d.mat',month));
    l = 0.25 / 0.05;
    r = floor(l/2);    
    for day = 1:31
        vec = datevec(datenum(year,month,day));
        if vec(2) == month
            doy = datenum(year,month,day) - datenum(year,1,1) + 1;  
            raw = importdata(sprintf('/bess19/Yulin/BESSv2/SM025/SM025.%d.%03d.mat',year,doy));
            temp = imresize(raw,size(MSK),'nearest');
            temp = ndnanfilter(temp,'hamming',[r,r]);
            
            % temp = temp(MSK);
            % mx = nanmax(temp);
                
            % proxy = f_Aggregate(DATA,5);
            % c = raw ./ proxy;
            % c(isinf(c)) = nan;
            % upper = prctile(c(:),95);
            % lower = prctile(c(:),5);
            % c(c>upper) = upper;
            % c(c<lower) = lower;
            % C = imresize(c,size(DATA),'nearest');
            % C = ndnanfilter(C,'hamming',[1,1]);
            % data = DATA .* C;
            % data = data(MSK);
            % data(data>mx) = mx;
              
            % msk = isnan(data);
            % data(msk) = temp(msk);
            
            data = temp(MSK);
            save(sprintf('/bess19/Yulin/BESSv2/SM025_Daily/SM025_Daily.%d.%03d.mat',year,doy),'data');
        end
    end
             