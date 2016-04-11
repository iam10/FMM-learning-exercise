clear all
dt = 0.1;
steps = 20;
N = 2^4;
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

den = ones(N,1);
Vx = 0;
Vy = 0;
figure(1)
filename = 'fmm.gif';
scatter(x,y)
xlim([1,4]);
ylim([1,4]);
drawnow
frame = getframe(1);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
for i = 1:steps
    %dxx = 0;
    %dyy = 0;
    [dxx,dyy] = laplaceSLPfmm(den,x,y);
    
    Vx = Vx - dxx*dt;
    Vy = Vy - dyy*dt;

    x = x + dt*Vx;
    y = y + dt*Vy;
    
    scatter(x,y)
    xlim([1,4]);
    ylim([1,4]);
    drawnow
    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    imwrite(imind,cm,filename,'gif','WriteMode','append');
end

VxD = 0;
VyD = 0;
figure(1)
filename = 'direct.gif';
scatter(xD,yD)
xlim([1,4]);
ylim([1,4]);
drawnow
frame = getframe(1);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
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
    xlim([1,4]);
    ylim([1,4]);
    drawnow
    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    imwrite(imind,cm,filename,'gif','WriteMode','append');
end

