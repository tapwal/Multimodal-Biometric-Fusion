%load('graph_fusion.mat')
[count bins] = hist(g,35);
[count1 bins1] = hist(im,35);
count = smooth(count);
count1 = smooth(count1);
plot(bins,count/80*100,'-s',bins1,count1/6320*100,'-d');xlabel('score');ylabel('normalized frequency');legend('genuine','imposter');
axis([0,1,1,12]);
%axis([0 1 0 16]);