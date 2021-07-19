function coarse = f_Aggregate(fine,l)
    height = size(fine,1) / l;
    width = size(fine,2) / l;
    n = l * l;
    series = nan(height,width,n,'single');
    for i = 1:l
        for j = 1:l
            idx = (i-1)*l + j;
            series(:,:,idx) = fine(i:l:end,j:l:end);
        end
    end
    coarse = nanmean(series,3);
    