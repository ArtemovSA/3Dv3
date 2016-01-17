start_point = 500;
end_point = 1100;
num_beat_1 = 1;
num_beat_2 = 2;

%%
mag_1 = ((XYZ(num_beat_1,start_point:end_point,1)).^2 + (XYZ(num_beat_1,start_point:end_point,2)).^2 + (XYZ(num_beat_1,start_point:end_point,3)).^2).^(0.5);
mag_2 = ((XYZ(num_beat_2,start_point:end_point,1)).^2 + (XYZ(num_beat_2,start_point:end_point,2)).^2 + (XYZ(num_beat_2,start_point:end_point,3)).^2).^(0.5);
[Dist,D,k,w] = dtw(mag_1,mag_2, 0);

%%
sign_x_1 = XYZ(num_beat_1,start_point:end_point,1);
sign_x_2 = XYZ(num_beat_2,start_point:end_point,1);
[Dist,D,k,w] = dtw(sign_x_1,sign_x_2, 0);

%%
hold on;
plot3(XYZ(num_beat_1,start_point:end_point,1),XYZ(num_beat_1,start_point:end_point,2),XYZ(num_beat_1,start_point:end_point,3),'color','r','Linewidth',2);
plot3(XYZ(num_beat_2,start_point:end_point,1),XYZ(num_beat_2,start_point:end_point,2),XYZ(num_beat_2,start_point:end_point,3),'color','k','Linewidth',2);

for (i = 1:k)
    point_dwp_1 = start_point + w(i,1);
    point_dwp_2 = start_point + w(i,2);
    
    line = [XYZ(num_beat_1,point_dwp_1,1), XYZ(num_beat_2,point_dwp_2,1);XYZ(num_beat_1,point_dwp_1,2), XYZ(num_beat_2,point_dwp_2,2);XYZ(num_beat_1,point_dwp_1,3), XYZ(num_beat_2,point_dwp_2,3)];
    
    plot3(line(1,:),line(2,:),line(3,:),'Linewidth',1);
end