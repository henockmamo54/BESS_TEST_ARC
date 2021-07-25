function hdf = readHDF(url,URL,dataset)
    i = 0;
    while i < 1000
        try 
            hdf = hdfread(url,dataset);
            break;
        catch
            system(sprintf('rm -f %s',url));
            ind = regexp(url,'/');
            path = url(1:ind(end));
            system(sprintf('aria2c -c %s -d %s',URL,path));
            i = i + 1;
        end 
    end
    