function alpha = cuckoo_main(score)
    alpha = zeros(size(score));
    for ii = 1:size(score,2)
        sprintf(num2str(ii))
        score(ii);
        alpha(ii) = cuckoo_search(100,score(ii));
    end
   %plot(1:50,score(1:50),1:50,alpha(1:50));legend('score','alpha');
end