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

function [normal,Err] = func_sfera_normal_vector(XYZ, beat_n, step, win_size, start_point, end_point, text, n_vector)

count = fix(((end_point - start_point) - win_size)/step);
radius = 1;

[X_sphere,Y_sphere,Z_sphere]=sphere(30);
mesh(radius*X_sphere,radius*Y_sphere,radius*Z_sphere);
hold on;

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
    plot3(garc(:,1),garc(:,2),garc(:,3),'k','linewidth',2)
    AB=[point_A;point_B];
    plot3(AB(:,1),AB(:,2),AB(:,3),'r.','markersize',15)
    if strcmp(n_vector,'on')
        normal_vector = [[0,0,0];[point_A(1),point_A(2),point_A(3)]];
        plot3(normal_vector(:,1),normal_vector(:,2),normal_vector(:,3),'Linewidth',1);
    end
    if strcmp(text,'on')
        point_A=1.1*point_A;
        text(point_A(1),point_A(2),point_A(3),num2str(i-1));
    end
    point_A = point_B;
end

    axis equal;
    hidden off;
    hold off;
    view([-30, 15]);
