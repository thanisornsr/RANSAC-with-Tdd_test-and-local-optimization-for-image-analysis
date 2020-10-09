function [A,t] = least_squares_affine(pts, pts_tilde)

    [~,data_length] = size(pts);
    
    A_for_solve = zeros(data_length*2,6);
    b_for_solve = zeros(data_length*2,1);
    
    for i = 1:2:data_length*2
        index = (i+1)/2;
        pts_temp = pts(1:2,index);
        pts_tilde_temp = pts_tilde(1:2,index);
        A_for_solve(i,:) = [pts_temp(1) pts_temp(2) 0 0 1 0];
        A_for_solve(i+1,:) = [0 0 pts_temp(1) pts_temp(2) 0 1];
        b_for_solve(i) = pts_tilde_temp(1);
        b_for_solve(i+1) = pts_tilde_temp(2);
    end
    
    
    temp = A_for_solve\b_for_solve;
    A = [temp(1,1),temp(2,1);temp(3,1),temp(4,1)];
    t = [temp(5,1);temp(6,1)];


end
