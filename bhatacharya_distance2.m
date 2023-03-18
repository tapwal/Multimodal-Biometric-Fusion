function likelihood = bhatacharya_distance2(f1,f2)
%{
mean_f1 = mean(f1);
mean_f2 = mean(f2);
var_f1 = var(f1);
var_f2 = var(f2);
f1_rep = repmat(f1,1,4);
%}
d_coef = sum(sqrt(f1.*f2));
d2_coef = sqrt(1-d_coef);
sigma = 0.04; % 0.04 %0.06
% likelihood = (1/(sigma*sqrt(2*pi)))*exp(-d2_coef^2/(2*sigma^2));
likelihood = exp(-d2_coef^2/(2*sigma^2));
% d = min(d);