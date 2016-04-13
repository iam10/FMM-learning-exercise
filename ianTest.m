clear all
dt = 0.1;
steps = 200;
%N = 2^4;
%{
x = zeros(N,1);
y = zeros(N,1);

iter = 0;
for i = 1:sqrt(N)
    for j = 1:sqrt(N)
        iter = iter + 1;
        x(iter) = i + rand() * .1-.05;
        y(iter) = j + rand() * (.1)-.05;
    end
end
xD = x;
yD = y;
%}

fileID = fopen('uniformDataUnperturbed.txt','r');
formatSpec = '%f %f';
sizeA = [2 Inf];
A = fscanf(fileID,formatSpec,sizeA);
A = A';
x = A(:,1);
y = A(:,2);
xD = x;
yD = y;
N = length(x);

xmin = min(x);
xmax = max(x);
ymin = min(y);
ymax = max(y);

figure(1)
filename = 'fmm.gif';
scatter(x,y)
%xlim([0,5]);
%ylim([0,5]);
drawnow
frame = getframe(1);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
imwrite(imind,cm,filename,'gif', 'Loopcount',inf);

den = ones(N,1);
den(1) = 100;
Vx = zeros(N,1);
Vy = zeros(N,1);
for i = 1:steps
    %dxx = 0;
    %dyy = 0;
    [dxx,dyy] = laplaceSLPfmm(den,x,y);
    
    Vx = Vx - dxx*dt;
    Vy = Vy - dyy*dt;

    x = x + dt*Vx;
    y = y + dt*Vy;
    
    scatter(x,y)
    xlim([0,101]);
    ylim([0,101]);
    drawnow
    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    imwrite(imind,cm,filename,'gif','WriteMode','append');
end

%Where direct starts
figure(2)
filename = 'direct.gif';
scatter(x,y)
xlim([0,101]);
ylim([0,101]);
drawnow
frame = getframe(1);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
imwrite(imind,cm,filename,'gif', 'Loopcount',inf);

VxD = zeros(N,1);
VyD = zeros(N,1);
for i = 1:steps
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
    
    scatter(xD,yD)
    xlim([0,101]);
    ylim([0,101]);
    drawnow
    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    imwrite(imind,cm,filename,'gif','WriteMode','append');
end

error = [abs(x-xD) abs(y-yD)];
norm(error,inf)

