%%calculating the BHATTACHARAYA DISTANCE for all images
%%
clear; clc;
% n_sub = 80;% n_sub = 51/100;
% n_key = 80;% n_key = 50/100;
% g = zeros(1,n_sub);
% im = zeros(1,n_sub*(n_sub-1));
% l = 1;
% k = 1;
% load('train_uni_mat1.mat'); load('test_uni_mat1.mat');
% uni_matrix_test = uni_matrix_test./repmat(sum(uni_matrix_test,2),1,n_key);
% uni_matrix_train = uni_matrix_train./repmat(sum(uni_matrix_train,2),1,n_key);
% for i = 1:n_sub
%     for j = 1:n_sub
%         if i == j
%             g(l) = bhatacharya_distance(uni_matrix_test(i,:),uni_matrix_train(j,:));
%             l=l+1;
%         else
%             im(k) = bhatacharya_distance(uni_matrix_test(i,:),uni_matrix_train(j,:));
%             k=k+1;
%         end
%     end
% end
% save('graph_fusion.mat','g','im');
load('graph_fusion.mat');
var_g=var(g); % variance
var_im=var(im);
avg_g=mean(g); %mean
avg_im=mean(im);
d=(avg_g-avg_im)/sqrt((var_g^2+var_im^2)/2); %decidability

