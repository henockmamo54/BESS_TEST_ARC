function f_MERRA(year,month)
     
    vars = {'AODANA','TQV','TO3'};
    pathIn = '/bess19/Yulin/Data/MERRA';
    pathOut = sprintf('/bess19/Yulin/BESSv2/MERRA/%d.%02d',year,month);
    if ~exist(pathOut)
        mkdir(pathOut)
    end
    
    for i = 1:length(vars)
        if i == 1
            path = sprintf('%s/GAS/%d/%02d',pathIn,year,month);
            files = dir([path,'/*.nc4']);
            data = nan(8,361,576,'single');
        else 
            path = sprintf('/bess19/Yulin/Data/MERRA/SLV/%d/%02d',year,month);
            files = dir([path,'/*.nc4']);
            data = nan(24,361,576,'single');
        end
        names = {files.name};
        for j = 1:length(names)
            name = names{j};
            day = str2num(name(end-5:end-4));
            raw = ncread(sprintf('%s/%s',path,name),vars{i});
            for k = 1:size(data,1)
                data(k,:,:) = rot90(raw(:,:,k));
            end
            save(sprintf('%s/%s.%d.%02d.%02d.mat',pathOut,vars{i},year,month,day),'data');
        end
    end
