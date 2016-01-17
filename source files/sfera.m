r=2;
A=[-2,-1,2]; A=r*A/norm(A);
B=[-1,-2,-1]; B=r*B/norm(B);

[X,Y,Z]=sphere;
mesh(r*X,r*Y,r*Z), hold on

% angle subtended by great arc
% from point A to point B
theta=acos(dot(A,B)/r^2);
% normal, binormal, and tangent
% vectors at point A
N=A/r; BN=cross(A,B);
T=cross(BN,N); T=T/norm(T);

n=20;
t=linspace(0,theta,n)';
N=repmat(N,n,1);
T=repmat(T,n,1);
t=repmat(t,1,3);
garc=r*(N.*cos(t)+T.*sin(t));
plot3(garc(:,1),garc(:,2),garc(:,3),...
   'k','linewidth',2)
AB=[A;B];
plot3(AB(:,1),AB(:,2),AB(:,3),'r.',...
   'markersize',18)
AB=1.1*AB;
text(AB(:,1),AB(:,2),AB(:,3),['A';'B'])
axis equal, hidden off, hold off
view([-30, 15])