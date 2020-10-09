function residual_lgths = residual_lgths(A,t,pts,pts_tilde)
    r = (A*pts+t) - pts_tilde;
    residual_lgths = sqrt(sum(r.^2,1));

end