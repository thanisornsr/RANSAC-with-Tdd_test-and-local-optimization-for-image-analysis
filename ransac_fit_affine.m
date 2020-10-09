function [A_best,t_best,k_loop,nbr_inlier_best] = ransac_fit_affine(pts, pts_tilde,d, threshold,local_opt_using)
    datasize = length(pts);
    A_best = zeros(2,2);
    t_best = zeros(2,1);
    nbr_inlier_best = 0;
    new_best_found = false;
    
    %These parameter is to adjust the iteration
    e = 0.05; %Initial inlier rate
    mu = 0.1^2; %minimum probability of missing correct model %Not sure about this
    k_max = round(log(mu)/log(1-e^(3+d)));
    k_loop = 0;
    
    
    while k_loop < k_max
%     while k_loop < 1000

        temp = randperm(datasize,3+d);
        index_of_point_to_estimate = temp(1:3);
        index_of_Tdd = temp(4:end);
        
        pts_temp = pts(1:2,index_of_point_to_estimate);
        pts_tilde_temp = pts_tilde(1:2,index_of_point_to_estimate);
        [A_temp, t_temp] = estimate_affine(pts_temp, pts_tilde_temp);
        
        %check for NaN 
%         check_A = sum(sum(isnan(A_temp)));
%         check_t = sum(sum(isnan(t_temp)));
%         check_for_NaN = check_A + check_t == 0;
        
        %check for Tdd
        if d == 0
            check_for_Tdd = true;
        else
            pts_Tdd = pts(1:2,index_of_Tdd);
            pts_tilde_Tdd = pts_tilde(1:2,index_of_Tdd);
            residual_lgths_Tdd = residual_lgths(A_temp,t_temp,pts_Tdd,pts_tilde_Tdd);
            check_threshold_Tdd = residual_lgths_Tdd < threshold;
            check_for_Tdd = sum(check_threshold_Tdd) == d;
        end
        
        
        if check_for_Tdd        
%         if check_for_NaN && check_for_Tdd
            residual_lgths_temp = residual_lgths(A_temp,t_temp,pts,pts_tilde);
            check_threshold = residual_lgths_temp < threshold;
            nbr_inlier = sum(check_threshold);
            if nbr_inlier > nbr_inlier_best
                A_best = A_temp;
                t_best = t_temp;
                nbr_inlier_best = nbr_inlier;
                e = nbr_inlier/datasize;
                k_max = round(log(mu)/log(1-e^(3+d)));
                
                %Local optimization
%                 new_best_found = false;
                if local_opt_using
                   %Store inlier
                   index_inlier = find(check_threshold);
                   pts_inlier =  pts(:,index_inlier);
                   pts_tilde_inlier = pts_tilde(:,index_inlier);
                   A_new_best = zeros(2,2);
                   t_new_best = zeros(2,1);
                   nbr_inlier_new_best = nbr_inlier_best;
                   %iterate 10 times
                   for k_local = 1:10
                        if nbr_inlier_best<12
                            s_pts_inlier = pts_inlier;
                            s_pts_tilde_inlier = pts_tilde_inlier;  
                        else
                            index_for_local = randperm(nbr_inlier_best,12);
                            s_pts_inlier = pts_inlier(:,index_for_local);
                            s_pts_tilde_inlier = pts_tilde_inlier(:,index_for_local);
                        end
                        

                        [A_local_temp,t_local_temp] = least_squares_affine(s_pts_inlier, s_pts_tilde_inlier);

                        residual_lgths_local_temp = residual_lgths(A_local_temp,t_local_temp,pts,pts_tilde);
                        check_threshold_local = residual_lgths_local_temp < threshold;
                        nbr_inlier_local = sum(check_threshold_local);
                        if nbr_inlier_local > nbr_inlier_new_best
                            A_new_best = A_local_temp;
                            t_new_best = t_local_temp;
                            nbr_inlier_new_best = nbr_inlier_local;
                            if nbr_inlier_new_best > nbr_inlier_best
                                e = nbr_inlier_new_best/datasize;
                                k_max = round(log(mu)/log(1-e^(3+d)));
                            end
                            new_best_found = true;
                        end
                   end
                end
            end  
        end
        k_loop = k_loop + 1;  
    end
   if new_best_found
        if nbr_inlier_best < nbr_inlier_new_best
            A_best = A_new_best;
            t_best = t_new_best;
            nbr_inlier_best = nbr_inlier_new_best;
        end
   end

end