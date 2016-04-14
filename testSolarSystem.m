
%Solar system
N = 9;
x = zeros(N,1);
y = zeros(N,1);
x(1) = 0;
x(2) = 0.387;
x(3) = 0.723;
x(4) = 1;%x(5) = 0.00257*
x(5) = 1.52;
x(6) = 5.20
x(7) = 9.58
x(8) = 19.20;
x(9) = 30.05;
%x(10) = 39.48;

den = zeros(N,1);
den(1) = 330000;
den(2) = 0.0553
den(3) = 0.815;
den(4) = 1;
%den(5) = 0.0123;
den(5) = 0.107;
den(6) = 317.8;
den(7) = 95.2;
den(8) = 14.5;
den(9) = 17.1;

Vx = zeros(N,1);
Vy = zeros(N,1);
Vy(1) = 0;
Vy(2) = 1.59;
Vy(3) = 1.18;
Vy(4) = 1;
%Vy(5) = 0.0343;
Vy(5) = 0.808;
Vy(6) = 0.439;
Vy(7) = 0.325;
Vy(8) = 0.228;
Vy(9) = 0.182;
%Vy(10) = 0.157;

theta = rand(N,1)*2*pi;
y = sin(theta).*x*10000;
x = cos(theta).*x*10000;
Vx = -sin(theta).*Vy*4000000;
Vy = cos(theta).*Vy*4000000;


speedDisRatio = 67/93000;
Vy = Vy*speedDisRatio;
Vx = Vx*speedDisRatio;
%x = x*100;
Vy = Vy;
den = den*100;
%Vx = den*0.05;
x(1) = 0;y(1) = 0;
Vx(1) = 0;Vy(1) = 0;

dt = 1;
steps = 40000;
posBound = 100000;

%{
%random
Vy = zeros(N,1);

N = 2^7;
dt = 10000;
steps = 40000;
posBound = 10000000;
velBound = posBound*0.00000001;
x = 0.5*posBound + (posBound)*randn(N,1);%.*(-1).^(randi([0,1],N,1));
%y = 0.1*posBound + (posBound)*randn(N,1).*(-1).^(randi([0,1],N,1));
y = zeros(N,1);
Vx = 0.1*velBound + (velBound)*randn(N,1).*(-1).^(randi([0,1],N,1));
Vx = Vx .* -1;
%Vx = zeros(N,1);
Vy = .01*velBound + (velBound)*randn(N,1);%.*(-1).^(randi([0,1],N,1));

[x,y] = generateNormalClusters(posBound,1.5*posBound,posBound,1.5*posBound,N);
x = cat(1,x,x.*-2);
y = cat(1,y,y);
Vx = cat(1,Vx,Vx.*-1);
Vy= cat(1,Vy,Vy.*-1);
N = N*2;
x(1) = 0;y(1) = 0;
Vx(1) = 0;Vy(1) = 0;
den = cos(rand(N,1));
den(1) = N*.5;
den(N/2:N) = 2.*den(N/2:N);
%}
%{
%Galaxy
N = 2^5;
dt = 1;
steps = 40000;
posBound = 10000;

V = rand(N,1);
theta = rand(N,1)*2*pi;
x = cos(theta);
y = sin(theta);
Vx = -1.*sin(theta);
Vy = cos(theta);
%{
x = rand(N,1);
y = zeros(N,1);
Vx = zeros(N,1);
Vy = rand(N,1);
%}
den = rand(N,1);

Vy = 30*Vy./y./den;
x = x*N*20+x*N.*rand(N,1)*20+x*N*100;
Vx = 30*Vx./x./den;
y = y*N*20+y*N.*rand(N,1)*20+y*N*100;
%x(N/2:N) = x(N/2:N)*-1;
%Vy(N/2:N) = Vy(N/2:N)*-1;
den = den*100;
%Vx = den*0.01;
x(1) = 0;y(1) = 0;
Vx(1) = 0;Vy(1) = 0;
den(1) = sum(den)*2;
%}
figure(1)
filename = 'fmm.gif';
scatter(x(2:N),y(2:N),'b');
hold on
scatter(x(1),y(1),'r');
hold off
xlim([-100,100]);
ylim([-100,100]);
drawnow
frame = getframe(1);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
imwrite(imind,cm,filename,'gif', 'Loopcount',inf);

%Vx = zeros(N,1);
%Vy = zeros(N,1);
xD = x;
yD = y;
VxD = Vx;
VyD = Vy;
for i = 1:steps
    %dxx = 0;
    %dyy = 0;
    [dxx,dyy] = laplaceSLPfmm(den,x,y);
    
    Vx = Vx - dxx*dt;
    Vy = Vy - dyy*dt;

    x = x + dt*Vx;
    y = y + dt*Vy;

    dxxD = zeros(N,1);
    dyyD = zeros(N,1);
    for j = 1:N
        ind = [(1:j-1) (j+1:N)];
        rho2 = (xD(j) - xD(ind)).^2 + (yD(j) - yD(ind)).^2;
        dxxD(j) = sum(den(ind).*(xD(j) - xD(ind))./rho2);
        dyyD(j) = sum(den(ind).*(yD(j) - yD(ind))./rho2);
    end
    dxxD = dxxD/2/pi;
    dyyD = dyyD/2/pi;
    
    VxD = VxD - dxxD*dt;
    VyD = VyD - dyyD*dt;

    xD = xD + dt*VxD;
    yD = yD + dt*VyD;
    
    scatter(x(2:N),y(2:N),'b');
    hold on
    scatter(x(1),y(1),'r');
    hold off
    lim = posBound;
    xlim([-lim+x(1),lim+x(1)]);
    ylim([-lim+y(1),lim+y(1)]);
    drawnow
    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    imwrite(imind,cm,filename,'gif','WriteMode','append');
end