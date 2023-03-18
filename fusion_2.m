clear;clc;   
%% finding unified matrix
% for calculating the testing features replace:
%            i.) 'test' by 'test' and 'testing' by 'testing'
%

% features - testing ear feature; features1 - testing ear features;
% features_testing - testing face features;
% features_testing - testing face features
% test - testing iris features; test - testing iris features
%% loading mat files into matrices;
n = input('enter the number of subjects :'); % n is the number of subjects in consideration (n_key_sub+1)
load('key_features_ext.mat');
features = importdata('ear_features_test.mat'); load('feature_all.mat'); load('color_feature_test.mat');
%% coping features in new matrices
face_features_testing = features_testing'; 
iris_features_testing = test; ear_feature_testing = features;

% graph_test_1, graph_test_2 etc. contains the final graph features for face, iris,ear;  
uni_matrix_test = zeros(60,80);graph_test_1=zeros(60,80);
graph_test_2=zeros(60,80);graph_test_3=zeros(60,80);

%% calculating features for 51 images (image no. 50 to 100)
for ll = 1:60
    features_testing = [face_features_testing(ll,:);key_face_features];
    test = [iris_features_testing(ll,:);key_iris_features]; features_test = [ear_feature_testing(ll,:);key_ear_features];
    
    [norm_1,s_matrix_1, d_mat_1, U_1] = similiarity_face(features_testing, n);
    [norm_2,s_matrix_2, d_mat_2, U_2] = similiarity_iris(test,n);
    [norm_3,s_matrix_3, d_mat_3, U_3] = similiarity_ear(features_test,n);
    n_mod = 3; % n_mod being the number of modalities
    % let norm_1, norm_2 etc. initial similiarity matrices;
    % U_1 etc. contains matrix containing K-NN only
    % s_matrix_1, s_matrix_2 etc. sparse matrices;
    %% some matrix definition as in paper
    W_1 = U_1*U_1';
    S_1 = d_mat_1^(-1/2)*W_1*d_mat_1^(-1/2);
    U_not_1 = U_1;
    W_2 = U_2*U_2';
    S_2 = d_mat_2^(-1/2)*W_2*d_mat_2^(-1/2);
    U_not_2 = U_2;
    W_3 = U_3*U_3';
    S_3 = d_mat_3^(-1/2)*W_3*d_mat_3^(-1/2);
    U_not_3 = U_3;
    alpha =0.1;lambda = 0.8;e = eye(n);
    %% old fusion
    %{
    for t = 1:3 % 12 is the number of itrations for cross-diffusion process
        n_1 = norm_1; n_2 = norm_2; n_3 = norm_3;
        norm_1 = s_matrix_1*((n_2+n_3)/(n_mod-1)) * (s_matrix_1)';
        norm_2 = s_matrix_2*((n_1+n_3)/(n_mod-1)) * (s_matrix_2)';
        norm_3 = s_matrix_3*((n_1+n_2)/(n_mod-1)) * (s_matrix_3)';
    end
    %}
    
    %% cross-diffusion process to iteratively update the similiarity matrix.
    for t=1:20
        U_1=alpha*S_1*U_1+(1-alpha)*U_not_1;
        U_2=alpha*S_2*U_2+(1-alpha)*U_not_3;
        U_3=alpha*S_2*U_3+(1-alpha)*U_not_3;
        U_prev_1 = U_1;U_prev_2 = U_2;U_prev_3 = U_3;
        U_1 = s_matrix_1*(1/2*(U_prev_2+U_prev_3))'*s_matrix_1+lambda*e;
        U_2 = s_matrix_2*(1/2*(U_prev_1+U_prev_3))'*s_matrix_2+lambda*e;
        U_3 = s_matrix_3*(1/2*(U_prev_1+U_prev_2))'*s_matrix_3+lambda*e;
        W_1 = U_1*U_1';
        S_1 = d_mat_1^(-1/2)*W_1*d_mat_1^(-1/2);
        W_2 = U_2*U_2';
        S_2 = d_mat_2^(-1/2)*W_2*d_mat_2^(-1/2);
        W_3 = U_3*U_3';
        S_3 = d_mat_3^(-1/2)*W_3*d_mat_3^(-1/2);
        norm_1 = U_1; norm_2 = U_2; norm_3 = U_3;
    end
    %% Unified Matrix
    % uni_norm = (norm_1 + norm_2 + norm_3)/n_mod;
    graph_test_1(ll,:)=norm_1(1,:); graph_test_2(ll,:)=norm_2(1,:);graph_test_3(ll,:) = norm_3(1,:);
    % uni_matrix_test(ll,:) = uni_norm(1,:);
    % uni_matrix_test = uni_norm;
end
% save('test_uni_mat1.mat','uni_matrix_test');
save('pcr5_test.mat','graph_test_1','graph_test_2','graph_test_3');

