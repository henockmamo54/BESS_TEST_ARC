% set opt=0 process then opt=1 process again, it's time consuming recommend parallel works
% to run this function annualy please prepare all the necessary data until the first month of next year 

%list =["RSW", "RVIS","RNIR"];

function f_RefDaily(ds0,year,month,opt) 
	     
    year = double(year)
	month = double(month)

       
%     for month = 1:13
        % Load NDVI ~ LAI relationship
        if opt == 0
            ds = strcat(ds0,'_MCD^');
            ds_ = strcat(ds0,'_temp^');
        else
            ds = strcat(ds0,'_temp^');
            ds_ = strcat(ds0,'_Daily^');
            LAT = importdata('/bess19/Yulin/BESSv2/Ancillary/LAT.005d.mat');
            LON = importdata('/bess19/Yulin/BESSv2/Ancillary/LON.005d.mat');
        end

        % Define moving window 	

        r = 15;
        win = -r:r;
        n = length(win); 
        series = nan(8774037,n,'single');

        for day = 1:31
            vec = datevec(datenum(year,month,day));
            if vec(2) == month
                doy = datenum(year,month,day) - datenum(year,1,1) + 1;

                % Read all data within the moving window
                disp("Read all data within the moving window")
                if day == 1
                    for i = 1:n
                        vec_ = datevec(datenum(year,1,doy+win(i)));
                        year_ = vec_(1);
                        month_ = vec_(2);
                        day_ = vec_(3);
                        doy_ = datenum(year_,month_,day_) - datenum(year_,1,1) + 1;
                        try
                            sprintf('/bess19/Yulin/BESSv2/%s/%s.%d.%03d.mat',ds,ds,year_,doy_)
                            series(:,i) = importdata(sprintf('/bess19/Yulin/BESSv2/%s/%s.%d.%03d.mat',ds,ds,year_,doy_));
                        catch exception
                            throw(exception)             
                        end
                    end
                    disp("A = 1")
                else
                    i = n;
                    vec_ = datevec(datenum(year,1,doy+win(i)));
                    year_ = vec_(1);
                    month_ = vec_(2);
                    day_ = vec_(3);
                    doy_ = datenum(year_,month_,day_) - datenum(year_,1,1) + 1;
                    try
                        sprintf('/bess19/Yulin/BESSv2/%s/%s.%d.%03d.mat',ds,ds,year_,doy_)
                        temp = importdata(sprintf('/bess19/Yulin/BESSv2/%s/%s.%d.%03d.mat',ds,ds,year_,doy_));
                    catch exception
                        throw(exception)             
                    end
                    series = [series(:,2:end),temp];

                    disp("B = "+ day)
                end
                series(series<0) = 0;
                temp = series;
                % % Remove outlies
                disp("Remove outlies")
                upper = prctile(series,75,2);
                lower = prctile(series,25,2);
                temp(temp>upper) = nan;
                temp(temp<lower) = nan;
                % Apply filter
                disp("Apply filter")
                data = temp(:,r+1);
                mn = nanmean(temp,2);
                msk = isnan(data);
                data(msk) = mn(msk);
                if opt == 1
                    msk = isnan(data);
                    temp = griddata(double(LON(~msk)),double(LAT(~msk)),double(data(~msk)),double(LON(msk)),double(LAT(msk)));
                    data(msk) = temp;
                end 
                % Write results	
                disp("Write results	")
                mkdir(sprintf('/bess19/Yulin/BESSv2/%s/',ds_));	
                save(sprintf('/bess19/Yulin/BESSv2/%s/%s.%d.%03d.mat',ds_,ds_,year,doy),'data'); 
                sprintf('/bess19/Yulin/BESSv2/%s/%s.%d.%03d.mat',ds_,ds_,year,doy)
            end    
        end 

%     end 