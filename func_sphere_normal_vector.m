%Autor: Artemov Sergei
%Date: 17.01.2016
%**************************************************************************
%*****Input varibles:*****
%handle_in - handle plot fild
%XYZ - input point matrix
%beat_n - beat number
%step - window shifting value
%win_size - size of window foe plane calculate
%start_point, end_point - start and end point in matrix XYZ
%text - 'on','off;
%n_vector - 'on','off;
%*****Output varibles:*****
%normal - array of normal vectors
%Err - array of summary error
%**************************************************************************

function [normal,Err] = func_sphere_normal_vector(handle_in, handle_n_time, XYZ, beat_n, step, win_size, start_point, end_point, text, n_vector)

count = fix(((end_point - start_point) - win_size)/step);
radius = 1;

cla(handle_in);
[X_sphere,Y_sphere,Z_sphere]=sphere(30);
mesh(handle_in,radius*X_sphere,radius*Y_sphere,radius*Z_sphere,'facecolor','none','LineWidth',0.1);
hold(handle_in,'on');

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
    
    N = ([normal(1,i); normal(2,i); normal(3,i)])';
    normal_points(i,:) = radius*N/norm(N); 
end
    [row,col] =size(normal_points(:,:));
    
    cla(handle_n_time);
    view(handle_n_time,0,90);
    %set(handle_n_time,'Xlim',[1 row]);
	hold(handle_n_time, 'on');
    plot(handle_n_time, normal_points(:,1),'ro-','LineWidth',2);
    plot(handle_n_time, normal_points(:,2),'go-','LineWidth',2);
    plot(handle_n_time, normal_points(:,3),'bo-','LineWidth',2);
    legend(handle_n_time, 'X','Y','Z');
    
    point_A = normal_points(1,:);
    
for i = 2:count-1 
    % angle subtended by great arc
    % from point A to point B
    point_B = normal_points(i,:);
    theta=acos(dot(point_A,point_B)/radius^2);
 
    N=point_A/radius; % normal
    BN=cross(point_A,point_B); %binormal
    T=cross(BN,N); %tangent
    T=T/norm(T); %vectors at point A
    
    n=100;
    t=linspace(0,theta,n)';
    N=repmat(N,n,1);
    T=repmat(T,n,1);
    t=repmat(t,1,3);
    garc=radius*(N.*cos(t)+T.*sin(t));
    plot3(handle_in,garc(:,1),garc(:,2),garc(:,3),'k','linewidth',2);
    
    AB=[point_A;point_B];
    plot3(handle_in,AB(:,1),AB(:,2),AB(:,3),'.r','markersize',20);
    if strcmp(n_vector,'on')
        normal_vector = [[0,0,0];[point_A(1),point_A(2),point_A(3)]];
        plot3(handle_in,normal_vector(:,1),normal_vector(:,2),normal_vector(:,3),'Linewidth',1);
    end
    if strcmp(text,'on')
        point_A=1.1*point_A;
        text(point_A(1),point_A(2),point_A(3),num2str(i-1),'Parent',handle_in);
    end
    point_A = point_B;
end

    axis(handle_in, 'equal');
    hidden off;
    hold(handle_in, 'off');