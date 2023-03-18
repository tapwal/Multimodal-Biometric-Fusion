function accuracy = recognition_rate(g,im)
    size_g = size(g(:),1);
    size_im = size(im(:),1);
    acc = zeros(1,10000);
    thresh = 0;
    for i = 1:10000
        TP = sum(g>=thresh)/size_g;
        TN = sum(im<thresh)/size_im;
        acc(i) = ((TP+TN)/2)*100;
        thresh = thresh + 0.0001;
        
    end
    accuracy = max(acc);
end