function [pts, pts_tilde, A_true, t_true] = affine_test_case(N,outlier_rate,sigma)
    
    %Generate the total point in image 640x480
    N_outlier = round(outlier_rate*N);
%     pts_x = randperm(640,N);
%     pts_y = randperm(480,N);
    pts_x = randi(640,N,1);
    pts_y = randi(480,N,1);
    
    pts = [pts_x,pts_y]';
    
    %Random A_true t_true
    temp = -1+rand(2,2)*(1+1);
    a = temp(1,1);
    b = temp(1,2);
    c = temp(2,1);
    d = temp(2,2);
    t_x = randi([-50 50],1);
    t_y = randi([-50 50],1);

    A_true = [a,b;c,d];
    t_true = [t_x;t_y];

    pts_tilde = A_true*pts+t_true;
    
    %Add noise
    noise_to_add_x = randi(640,1,N_outlier);
    noise_to_add_y = randi(480,1,N_outlier);
    noise_to_add = [noise_to_add_x;noise_to_add_y];
    index_to_add = randperm(N,N_outlier);
    pts_tilde(:,index_to_add) = noise_to_add;
    
    %Add Gaussian noise
    gaussian_noise_to_add = normrnd(0,sigma,2,N);
    pts_tilde = pts_tilde + gaussian_noise_to_add;

end