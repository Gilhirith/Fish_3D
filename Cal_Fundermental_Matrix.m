function F = Cal_Fundermental_Matrix(fc_left, cc_left, alpha_c_left, fc_right, cc_right, alpha_c_right, om, T)
    %% intrinsic matrix
    M_l = [fc_left(1), alpha_c_left * fc_left(1), cc_left(1);
            0, fc_left(2), cc_left(2);
            0, 0, 1];
    M_r = [fc_right(1), alpha_c_right * fc_right(1), cc_right(1);
            0, fc_right(2), cc_right(2);
            0, 0, 1];
    
    R = rodrigues(om);
    
    t = -(R)^-1 * T';
    S = [0, -t(3), t(2); t(3), 0, -t(1); -t(2), t(1), 0];
    
    E = R * S;
    
    F = ((M_r)^-1)' * E * (M_l)^-1;
    
end