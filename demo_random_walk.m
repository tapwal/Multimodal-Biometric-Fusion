% U(i,j) matrix after K-nearest neighbour step but before
% normalization; U_norm is normalized U matrix;
d_mat = sum(features,2);
d_mat = diag(d_mat); %% arranging the row-sum in diagonal matrix;
W=U*U';
S = d_mat^(-1/2)*W*d_mat^(-1/2);
alpha =0.2;
lambda = 0.8;
U_not = U;
for t=1:20
    U=alpha*S*U*(1-alpha)*U_not;
    U_prev = U;
    U = U_norm*U_prev'*U_norm;
    W = U*U';
    S = d_mat^(-1/2)*W*d_mat^(-1/2);
end

    
