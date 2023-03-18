function alpha = calc_alpha(score)
    alpha = zeros(size(score));
    thresh = 0.5;
    for i=1:size(score,2)
        if score(i)>=thresh
            if score(i)>0.78
                alpha(i) = 1;
            else
                alpha(i) = score(i)+0.2;
            end
        elseif score(i)<thresh%% && score(i)>0.1
            alpha(i) = 0.4;%score(i)+0.3;
        else
            alpha(i) = 0;
        end
    end
end
