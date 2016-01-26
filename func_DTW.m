%Autor: Artemov Sergei
%Date: 17.01.2016
%**************************************************************************
%*****Input varibles:*****
%handle_in - handle plot fild
%num_beat_1 - beat number
%num_beat_2 - beat number
%start_point, end_point - start and end point in matrix XYZ
%axes_dtw - 'M','X','Y','Z','3D'
%show_path - 1, 0
%*****Output varibles:*****
%Dist - unnormalized distance between t and r
%D - the accumulated distance matrix
%k - the normalizing factor
%w - the optimal path
%rw - the warped r vector
%tw - the warped t vector
%**************************************************************************

function [Dist,D,k,w,rw,tw] = func_DTW(handle_in, handle_path, XYZ, num_beat_1, num_beat_2, start_point, end_point, axes_dtw, show_path)

switch (axes_dtw)
    case 'M'
        sign_1 = ((XYZ(num_beat_1,start_point:end_point,1)).^2 + (XYZ(num_beat_1,start_point:end_point,2)).^2 + (XYZ(num_beat_1,start_point:end_point,3)).^2).^(0.5);
        sign_2 = ((XYZ(num_beat_2,start_point:end_point,1)).^2 + (XYZ(num_beat_2,start_point:end_point,2)).^2 + (XYZ(num_beat_2,start_point:end_point,3)).^2).^(0.5);
        [Dist,D,k,w,rw,tw] = dtw(sign_1,sign_2, show_path,'2D');
    case 'X'
        sign_1 = XYZ(num_beat_1,start_point:end_point,1);
        sign_2 = XYZ(num_beat_2,start_point:end_point,1);
        [Dist,D,k,w,rw,tw] = dtw(sign_1,sign_2, show_path,'2D');
    case 'Y'
        sign_1 = XYZ(num_beat_1,start_point:end_point,2);
        sign_2 = XYZ(num_beat_2,start_point:end_point,2);   
        [Dist,D,k,w,rw,tw] = dtw(sign_1,sign_2, show_path,'2D');
    case 'Z'
        sign_1 = XYZ(num_beat_1,start_point:end_point,3);
        sign_2 = XYZ(num_beat_2,start_point:end_point,3);
        [Dist,D,k,w,rw,tw] = dtw(sign_1,sign_2, show_path,'2D');
    case '3D'
        sign_1 = XYZ(num_beat_1,start_point:end_point,:);
        sign_2 = XYZ(num_beat_2,start_point:end_point,:);
        [Dist,D,k,w,rw,tw] = dtw(sign_1,sign_2, show_path,'3D');
end;

hold(handle_in, 'on');
plot3(handle_in, XYZ(num_beat_1,start_point:end_point,1),XYZ(num_beat_1,start_point:end_point,2),XYZ(num_beat_1,start_point:end_point,3),'color','r','Linewidth',2);
plot3(handle_in, XYZ(num_beat_2,start_point:end_point,1),XYZ(num_beat_2,start_point:end_point,2),XYZ(num_beat_2,start_point:end_point,3),'color','k','Linewidth',2);

for (i = 1:k)
    point_dwp_1 = start_point + w(i,1);
    point_dwp_2 = start_point + w(i,2);
    
    line = [XYZ(num_beat_1,point_dwp_1,1), XYZ(num_beat_2,point_dwp_2,1);XYZ(num_beat_1,point_dwp_1,2), XYZ(num_beat_2,point_dwp_2,2);XYZ(num_beat_1,point_dwp_1,3), XYZ(num_beat_2,point_dwp_2,3)];
    
    plot3(handle_in, line(1,:),line(2,:),line(3,:),'Linewidth',1);
end

hold(handle_in, 'off');