function likelihood = histogram_intersection(f1,f2)
f1 = f1/sum(f1);
f2 = f2/sum(f2);
%{
mean_f1 = mean(f1);
mean_f2 = mean(f2);
var_f1 = var(f1);
var_f2 = var(f2);
f1_rep = repmat(f1,1,4);
%}

hist_inter = sum(min(f1,f2));
hist_inter = sqrt(1-hist_inter);
%d_coef = sum(sqrt(f1.*f2));
%d2_coef = sqrt(1-d_coef);
sigma = 0.344;
% likelihood = (1/(sigma*sqrt(2*pi)))*exp(-hist_inter^2/(2*sigma^2));
likelihood = exp(-hist_inter^2/(2*sigma^2));
% d = min(d);