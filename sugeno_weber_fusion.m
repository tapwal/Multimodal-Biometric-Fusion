n=50;
n_sub = 60;
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
            g_t_1(l) = bhatacharya_distance(graph_train_1(i,:),graph_test_1(j,:));
            g_t_2(l) = bhatacharya_distance(graph_train_2(i,:),graph_test_2(j,:));
            g_t_3(l) = bhatacharya_distance(graph_train_3(i,:),graph_test_3(j,:));
            l=l+1;
        else
            im_t_1(k) = bhatacharya_distance(graph_train_1(i,:),graph_test_1(j,:));
            im_t_2(k) = bhatacharya_distance(graph_train_2(i,:),graph_test_3(j,:));
            im_t_3(k) = bhatacharya_distance(graph_train_3(i,:),graph_test_3(j,:));
            k=k+1;
        end
    end
end
%% 
p = 567543573367900;
for i = 1:60
    g1 = max(0,(g_t_1(i)+g_t_2(i)-1+p*g_t_1(i)*g_t_2(i))/(1+p));
    g(i) = max(0,(g1+g_t_3(i)-1+p*g1*g_t_3(i))/(1+p));
end
  
for i = 1:3540
    im1 = max(0,(im_t_1(i)+im_t_2(i)-1+p*im_t_1(i)*im_t_2(i))/(1+p));
    im(i) = max(0,(im1+im_t_3(i)-1+p*im1*im_t_3(i))/(1+p));
end
%% Decidability calculation
var_g=var(g); % variance
var_im=var(im);
avg_g=mean(g); %mean
avg_im=mean(im);
d=(avg_g-avg_im)/sqrt((var_g^2+var_im^2)/2); %decidability


    
    
    
        