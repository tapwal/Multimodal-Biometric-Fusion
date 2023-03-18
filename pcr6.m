n=80;
n_sub = 80;
load('pcr5_train');load('pcr5_test');
%% normalizing values of graphs
graph_train_1 = graph_train_1./repmat(sum(graph_train_1,2),1,n);
graph_train_2 = graph_train_2./repmat(sum(graph_train_2,2),1,n);
graph_train_3 = graph_train_3./repmat(sum(graph_train_3,2),1,n);  
graph_test_1 = graph_test_1./repmat(sum(graph_test_1,2),1,n);
graph_test_2 = graph_test_2./repmat(sum(graph_test_2,2),1,n);
graph_test_3 = graph_test_3./repmat(sum(graph_test_3,2),1,n);
%%
g_t_1 = zeros(1,n_sub);g_t_2 = zeros(1,n_sub);g_t_3 = zeros(1,n_sub);
im_t_1 = zeros(1,n_sub*(n_sub-1));im_t_2 = zeros(1,n_sub*(n_sub-1));im_t_3 = zeros(1,n_sub*(n_sub-1));
l=1;k=1;
%% calculating track-values
for i = 1:n_sub
    for j = 1:n_sub
        if i == j
            g_t_1(l) = bhatacharya_distance2(graph_train_1(i,:),graph_test_1(j,:));
            g_t_2(l) = bhatacharya_distance1(graph_train_2(i,:),graph_test_2(j,:));
            g_t_3(l) = bhatacharya_distance(graph_train_3(i,:),graph_test_3(j,:));
            l=l+1;
        else
            im_t_1(k) = bhatacharya_distance2(graph_train_1(i,:),graph_test_1(j,:));
            im_t_2(k) = bhatacharya_distance1(graph_train_2(i,:),graph_test_2(j,:));
            im_t_3(k) = bhatacharya_distance(graph_train_3(i,:),graph_test_3(j,:));
            k=k+1;
        end
    end
end
%%
g_t_1 = cuckoo_main1(g_t_1).*g_t_1;g_t_2 = cuckoo_main(g_t_2).*g_t_2;g_t_3 = cuckoo_main(g_t_3).*g_t_3;
im_t_1 = cuckoo_main1(im_t_1).*im_t_1;im_t_2 = cuckoo_main(im_t_2).*im_t_2;im_t_3 = cuckoo_main(im_t_3).*im_t_3;
g_nt_1 = 1-g_t_1;g_nt_2 = 1-g_t_2;g_nt_3 = 1-g_t_3;  % non-track values for genuine
im_nt_1 = 1-im_t_1;im_nt_2 = 1-im_t_2;im_nt_3 = 1-im_t_3;  %non-track values for imposter
%% calculating x_values
% Genuine
xg_1 = (g_t_1.*(g_t_1.*g_nt_2.*g_nt_3))./(g_t_1+g_nt_2+g_nt_3);
xg_2 = (g_t_2.*(g_t_2.*g_nt_1.*g_nt_3))./(g_t_2+g_nt_1+g_nt_3);
xg_3 = (g_t_3.*(g_t_3.*g_nt_2.*g_nt_1))./(g_t_3+g_nt_2+g_nt_1);
xg_4 = (g_t_3.*(g_t_1.*g_t_2.*g_nt_3))./(g_t_1+g_t_2+g_nt_3);%3
xg_5 = (g_t_2.*(g_t_1.*g_t_2.*g_nt_3))./(g_t_1+g_t_2+g_nt_3);
xg_6 = (g_t_3.*(g_t_2.*g_nt_1.*g_t_3))./(g_t_2+g_nt_1+g_t_3);
xg_7 = (g_t_2.*(g_t_2.*g_nt_1.*g_t_3))./(g_t_2+g_nt_1+g_t_3);
xg_8 = (g_t_1.*(g_t_3.*g_nt_2.*g_t_1))./(g_t_3+g_nt_2+g_t_1);
xg_9 = (g_t_2.*(g_t_3.*g_nt_2.*g_t_1))./(g_t_3+g_nt_2+g_t_1);%2
x_g = g_t_1.*g_t_2.*g_t_3;
g = x_g+xg_1+xg_2+xg_3+xg_4+xg_5+xg_6+xg_7+xg_8+xg_9;
% Imposter
xim_1 = im_t_1.*(im_t_1.*im_nt_2.*im_nt_3)./(im_t_1+im_nt_2+im_nt_3);
xim_2 = im_t_2.*(im_t_2.*im_nt_1.*im_nt_3)./(im_t_2+im_nt_1+im_nt_3);
xim_3 = im_t_3.*(im_t_3.*im_nt_2.*im_nt_1)./(im_t_3+im_nt_2+im_nt_1);
xim_4 = im_t_3.*(im_t_1.*im_t_2.*im_nt_3)./(im_t_1+im_t_2+im_nt_3);%3
xim_5 = im_t_2.*(im_t_1.*im_t_2.*im_nt_3)./(im_t_1+im_t_2+im_nt_3);
xim_6 = im_t_3.*(im_t_2.*im_nt_1.*im_t_3)./(im_t_2+im_nt_1+im_t_3);
xim_7 = im_t_2.*(im_t_2.*im_nt_1.*im_t_3)./(im_t_2+im_nt_1+im_t_3);
xim_8 = im_t_1.*(im_t_3.*im_nt_2.*im_t_1)./(im_t_3+im_nt_2+im_t_1);
xim_9 = im_t_2.*(im_t_3.*im_nt_2.*im_t_1)./(im_t_3+im_nt_2+im_t_1);%2
%%
x_im = im_t_1.*im_t_3.*im_t_3;
im = x_im+xim_1+xim_2+xim_3+xim_4+xim_5+xim_6+xim_7+xim_8+xim_9;
save('graph_fusion.mat','g','im');
%% Decidability calculation
var_g=var(g); % variance
var_im=var(im);
avg_g=mean(g); %mean
avg_im=mean(im);
d=(avg_g-avg_im)/sqrt((var_g^2+var_im^2)/2); %decidability

