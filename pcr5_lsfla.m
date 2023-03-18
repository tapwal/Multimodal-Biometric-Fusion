load('final_scores.mat');
n = 50;
n_sub = 60;
g_t_1 = zeros(1,n_sub);g_t_2 = zeros(1,n_sub);g_t_3 = zeros(1,n_sub);
im_t_1 = zeros(1,n_sub*(n_sub-1));im_t_2 = zeros(1,n_sub*(n_sub-1));im_t_3 = zeros(1,n_sub*(n_sub-1));
l=1;k=1;
for i=1:60
    for j=1:60
        if i==j
            g_t_1(l) = face_scores(i,j);
            g_t_2(l) = iris_scores(i,j);
            g_t_3(l) = ear_scores(i,j);
            l=l+1;
        else
            im_t_1(k) = face_scores(i,j);
            im_t_2(k) = iris_scores(i,j);
            im_t_3(k) = ear_scores(i,j);
            k=k+1;
        end
    end
end
%%
g_nt_1 = 1-g_t_1;g_nt_2 = 1-g_t_2;g_nt_3 = 1-g_t_3;  % non-track values for genuine
im_nt_1 = 1-im_t_1;im_nt_2 = 1-im_t_2;im_nt_3 = 1-im_t_3;  %non-track values for imposter
%% calculating x_values
% Genuine
xg_1 = g_t_1.*(g_t_1.*g_nt_2.*g_nt_3)./(g_t_1+g_nt_2.*g_nt_3);
xg_2 = g_t_2.*(g_t_2.*g_nt_1.*g_nt_3)./(g_t_2+g_nt_1.*g_nt_3);
xg_3 = g_t_3.*(g_t_3.*g_nt_2.*g_nt_1)./(g_t_3+g_nt_2.*g_nt_1);
xg_4 = (g_t_2.*g_t_3).*(g_nt_1.*g_t_2.*g_t_3)./(g_nt_1+g_t_2.*g_t_3);
xg_5 = (g_t_1.*g_t_3).*(g_nt_2.*g_t_1.*g_t_3)./(g_nt_2+g_t_1.*g_t_3);
xg_6 = (g_t_3.*g_t_2).*(g_nt_3.*g_t_2.*g_t_1)./(g_nt_3+g_t_2.*g_t_1);
% Imposter
xim_1 = im_t_1.*(im_t_1.*im_nt_2.*im_nt_3)./(im_t_1+im_nt_2.*im_nt_3);
xim_2 = im_t_2.*(im_t_2.*im_nt_1.*im_nt_3)./(im_t_2+im_nt_1.*im_nt_3);
xim_3 = im_t_3.*(im_t_3.*im_nt_2.*im_nt_1)./(im_t_3+im_nt_2.*im_nt_1);
xim_4 = (im_t_2.*im_t_3).*(im_nt_1.*im_t_2.*im_t_3)./(im_nt_1+im_t_2.*im_t_3);
xim_5 = (im_t_1.*im_t_3).*(im_nt_2.*im_t_1.*im_t_3)./(im_nt_2+im_t_1.*im_t_3);
xim_6 = (im_t_3.*im_t_2).*(im_nt_3.*im_t_2.*im_t_1)./(im_nt_3+im_t_2.*im_t_1);
x_g = g_t_1.*g_t_2.*g_t_3; x_im = im_t_1.*im_t_2.*im_t_3;
%%
g = x_g+xg_1+xg_2+xg_3+xg_4+xg_5+xg_6;
im = x_im+xim_1+xim_2+xim_3+xim_4+xim_5+xim_6;
save('graph_fusion.mat','g','im');
%% Decidability calculation
var_g=var(g); % variance
var_im=var(im);
avg_g=mean(g); %mean
avg_im=mean(im);
d=(avg_g-avg_im)/sqrt((var_g^2+var_im^2)/2); %decidability