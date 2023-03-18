g2 = sort(g);
im2 = sort(im);
f = exp(-(g2-avg_g).^2./(2*var_g))./(sqrt(var_g)*sqrt(2*pi));
f1 = exp(-(im2-avg_im).^2./(2*var_im))./(sqrt(var_im)*sqrt(2*pi));
plot(g2,f,im2,f1);xlabel('scores');ylabel('distribution');legend('genuine','imposter');