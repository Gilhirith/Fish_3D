function d = Dis_Pt_To_Line( P, CorPts ) 
%UNTITLED Summary of this function goes here 
% Detailed explanation goes here 
l = [ CorPts(1) - CorPts(4), CorPts(2) - CorPts(5), CorPts(3) - CorPts(6) ]; 
pl = [ P(1) - CorPts(1), P(2) - CorPts(2), P(3) - CorPts(3) ]; 
tem = cross(pl, l); 
d = norm( tem ) / norm( l ); 