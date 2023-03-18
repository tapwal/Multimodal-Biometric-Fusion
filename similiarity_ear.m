%% calculating similiarity matrix.
function [norm, s_matrix, d_mat, U] = similiarity_ear(features,n)
    % load('ear_features.mat'); % load the features mat file.
    sim_kernel = zeros(n,n);
    for mm = 1:n
        sim_kernel(mm,:) = exp(-sqrt(sum((repmat(features(mm,:),n,1)-features).^2,2)))';
    end
    d_mat = sum(sim_kernel,2);
    d_mat = diag(d_mat);
    %save('sim_kernel_ear.mat','sim_kernel');
    %% Normalization
    idx = eye(size(sim_kernel));
    idx2 = 1-idx;
    dia = 6*idx/7;    % change for self similiarity;
    n_dia = idx2.*sim_kernel;
    n_dia = 1*n_dia./(7*repmat(sum(n_dia,2),1,n));  % change for mutual similiarity;
    norm = dia+n_dia;
    %% getting sparse matrix using k-nearest neighbour/ Fuzzy k-nn
    sort_norm = sort(norm,2);
    thresh_value = sort_norm(:,n-15); % taking 20-nearest neighbours.
    %% K-nearest neighbour approach
    
    thresh_matrix = norm > repmat(thresh_value,1,n); % selecting elements greater than threshold.
    n_neighbours = norm.*thresh_matrix;
    U = n_neighbours;
    s_matrix = n_neighbours./repmat(sum(n_neighbours,2),1,n);
    
    %% fuzzy k-nearest neighbour approach
    %{
    thresh_matrix_1 = (norm > repmat(thresh_value,1,n)).*(norm./(repmat(sum(norm,2),1,n))); % selecting elements greater than threshold.
    thresh_matrix_2 = (norm < repmat(thresh_value,1,n)).*(norm./(repmat(sum(norm,2),1,n)));
    s_matrix = thresh_matrix_1+thresh_matrix_2;
    %}
end
