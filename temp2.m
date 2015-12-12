load('data.mat');
start_point = 601;
end_point = 1500;
data_X = abs(XYZ(1,start_point:end_point,1));
data_Y = abs(XYZ(1,start_point:end_point,2));
data_Z = abs(XYZ(1,start_point:end_point,3));
magnitude = (data_X.^2 + data_Y.*data_Y + data_Z.*data_Z).^(0.5);

windowSize = 10;
b = (1/windowSize)*ones(1,windowSize);
a = 1;
magnitude_f = filter(b,a,magnitude);
data_X_f = filter(b,a,data_X);
data_Y_f = filter(b,a,data_Y);
data_Z_f = filter(b,a,data_Z);

hold on;
plot(data_X_f,'r');
plot(data_Y_f,'g');
plot(data_Z_f,'b');
plot(magnitude_f,'m');
[pks_X,locs_X] = findpeaks(data_X_f,'SORTSTR','descend','MINPEAKDISTANCE',100);
[pks_Y,locs_Y] = findpeaks(data_Y_f,'SORTSTR','descend','MINPEAKDISTANCE',100);
[pks_Z,locs_Z] = findpeaks(data_Z_f,'SORTSTR','descend','MINPEAKDISTANCE',100);
[pks_M,locs_M] = findpeaks(magnitude_f,'SORTSTR','descend','MINPEAKDISTANCE',100);
plot(locs_X(1:2),pks_X(1:2),'or');
plot(locs_Y(1:2),pks_Y(1:2),'og');
plot(locs_Z(1:2),pks_Z(1:2),'ob');
plot(locs_M(1:2),pks_M(1:2),'om');