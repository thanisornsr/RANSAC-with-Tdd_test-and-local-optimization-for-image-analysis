function [A, t] = estimate_affine(pts, pts_tilde)

    
    b_for_solve = [pts_tilde(1,1);pts_tilde(2,1);pts_tilde(1,2);pts_tilde(2,2);pts_tilde(1,3);pts_tilde(2,3);];
    A_for_solve = [pts(1,1) pts(2,1) 0 0 1 0;
                   0 0 pts(1,1) pts(2,1) 0 1;
                   pts(1,2) pts(2,2) 0 0 1 0;
                   0 0 pts(1,2) pts(2,2) 0 1;
                   pts(1,3) pts(2,3) 0 0 1 0;
                   0 0 pts(1,3) pts(2,3) 0 1;];
               
    temp = A_for_solve\b_for_solve;
    A = [temp(1,1),temp(2,1);temp(3,1),temp(4,1)];
    t = [temp(5,1);temp(6,1)];


end