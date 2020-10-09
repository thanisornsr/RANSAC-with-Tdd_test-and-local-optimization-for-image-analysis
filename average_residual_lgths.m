function average_residual_lgths_inlier = average_residual_lgths(A,t,pts,pts_tilde,threshold)

    residual_lgths_temp = residual_lgths(A,t,pts,pts_tilde);
    checked_threshold = residual_lgths_temp < threshold;
    nbr_inlier = sum(checked_threshold);
%     pts_in = zeros(2,nbr_inlier);
%     pts_t_in = zeros(2,nbr_inlier);
    
    residual_in = zeros(1,nbr_inlier);
    index_in = 1;
    for i = 1:length(pts)
        if checked_threshold(i) == true
%            pts_in(:,index_in) = pts(1:2,i);
%            pts_t_in(:,index_in) = pts_tilde(1:2,i);
           residual_in(index_in) = residual_lgths_temp(i);
           index_in = index_in + 1;
        end
    end
    
    average_residual_lgths_inlier = sum(residual_in)/nbr_inlier;
    

end