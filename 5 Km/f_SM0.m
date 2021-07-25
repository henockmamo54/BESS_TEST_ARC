function f_SM0(year,month)
	
	year= double(year);
	month= double(month) ;
    vars = {'SMAP','AMSRE','AMSR2','TMI','WINDSAT','NOAH21','NOAH20'};
    series = nan(720,1440,31,length(vars)+1,'single');
    for i = 1:length(vars)
        ds = vars{i};
        load(sprintf('/bess/JCY/BESSv2/0Calibration/SM_%s_SMOS.mat',ds));
        for day = 1:31
            vec = datevec(datenum(year,month,day));
            if vec(2) == month
                doy = datenum(year,month,day) - datenum(year,1,1) + 1;
                if i < 6
                    try
                        raw = importdata(sprintf('../Microwave/%s-SM/%s-SM.%d.%03d.mat',ds,ds,year,doy));
                        series(:,:,day,i) = slope .* raw + intercept;
                    end
                else
                    try
                        raw = squeeze(nanmean(importdata(sprintf('../%s/%d.%02d/SoilMoi0_10cm_inst.%d.%02d.%02d.mat',ds,year,month,year,month,day)),1)) / 100;
                        series(1:600,:,day,i) = slope(1:600,:) .* raw + intercept(1:600,:);
                    end
                end    
            end
        end
    end
     
    ds = 'SMOS';
    for day = 1:31
        vec = datevec(datenum(year,month,day));
        if vec(2) == month
            doy = datenum(year,month,day) - datenum(year,1,1) + 1; 
            try
                raw = importdata(sprintf('../Microwave/%s-SM/%s-SM.%d.%03d.mat',ds,ds,year,doy));
                series(:,:,day,end) = raw;
            end
        end
    end

    series(series>0.5) = 0.5;
    series(series<0) = 0;
    series = nanmedian(series,4);
    
    for day = 1:31
        vec = datevec(datenum(year,month,day));
        if vec(2) == month
            doy = datenum(year,month,day) - datenum(year,1,1) + 1;
            data = series(:,:,day); 
            save(sprintf('/bess19/Yulin/BESSv2/SM025/SM025.%d.%03d.mat',year,doy),'data');    
        end
    end
      