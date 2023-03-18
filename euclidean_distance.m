load('train_uni_mat.mat'); load('test_uni_mat.mat');
for i=1:100
    for j =1:100
        eucl_dis(i,j) =  sqrt(sum(uni_matrix_test(i,:).^2 - uni_matrix_train(j,:).^2));
    end
end