%Autor: Artemov Sergei
%Date: 11.12.2015
%**************************************************************************
%*****Input varibles:*****
%handle_in - handle plot fild
%XYZ - input point matrix
%beat_n - beat number
%step - window shifting value
%win_size - size of window foe plane calculate
%start_point, end_point - start and end point in matrix XYZ
%*****Output varibles:*****
%normal - array of normal vectors
%Err - array of summary error
%**************************************************************************

function [normal,Err] = func_normal_vector(handle_in, XYZ, beat_n, step, win_size, start_point, end_point)

count = fix(((end_point - start_point) - win_size)/step);

cla(handle_in);

for i = 1:count-1
    p1 = start_point+(step*i-step);
    p2 = p1 + win_size;
    
    XData =(XYZ(beat_n,p1:p2,1))';
    YData =(XYZ(beat_n,p1:p2,2))';
    ZData =(XYZ(beat_n,p1:p2,3))';
    
    X(:,1) = XData(:,1);
    X(:,2) = YData(:,1);
    X(:,3) = ZData(:,1);
    
    [coeff,score] = princomp(X);
    normal(:,i) = coeff(:,3);
    meanX = mean(X,1);
    [n,p] = size(X);
    error = abs((X - repmat(meanX,n,1))*normal(:,i));
    Err(:,i) = sum(error);
    
    N = [normal(1,i)*200+XData(1,1); normal(2,i)*200+YData(1,1); normal(3,i)*200+ZData(1,1)];
    
    N = horzcat([XData(1,1); YData(1,1); ZData(1,1)], N);
    N = N';
    
    hold(handle_in,'on');
    plot3(handle_in, N(:,1),N(:,2),N(:,3),'Linewidth',2);
end
    
XData =(XYZ(beat_n,start_point:end_point,1));
YData =(XYZ(beat_n,start_point:end_point,2));
ZData =(XYZ(beat_n,start_point:end_point,3));
scatter3(handle_in, XData,YData,ZData,'fill');
hold(handle_in,'off');