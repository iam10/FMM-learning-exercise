clear all
dt = 1;
steps = 250;

fileID = fopen('uniformDataPerturbed.txt','r');
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

%figure(1)
%filename = 'fmm.gif';
%scatter(x,y);
%title('FMM');
%pause(0.01);
%drawnow;
%frame = getframe(1);
%im = frame2im(frame);
%[imind,cm] = rgb2ind(im,256);
%imwrite(imind,cm,filename,'gif', 'Loopcount',inf);

den = ones(N,1);
%den(1) = 100;
Vx = zeros(N,1);
Vy = zeros(N,1);
%for i = 1:steps
    %[dxx,dyy] = laplaceSLPfmm(den,x,y);
    
    %Vx = Vx - dxx*dt;
    %Vy = Vy - dyy*dt;

    %x = x + dt*Vx;
    %y = y + dt*Vy;
    
    %scatter(x,y);
    %title('FMM');
    %xlim([0,101]);
    %ylim([0,101]);
    %pause(0.01);
    %drawnow;
    %frame = getframe(1);
    %im = frame2im(frame);
    %[imind,cm] = rgb2ind(im,256);
    %imwrite(imind,cm,filename,'gif','WriteMode','append');
    
%end


%Where direct starts
%figure(1)
%filename = 'direct.gif';
%scatter(xD,yD);
%title('Direct');
%    pause(0.01);
%drawnow
%frame = getframe(1);
%im = frame2im(frame);
%[imind,cm] = rgb2ind(im,256);
%imwrite(imind,cm,filename,'gif', 'Loopcount',inf);

VxD = zeros(N,1);
VyD = zeros(N,1);
%error= zeros(length(x),1);
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
    [dxx,dyy] = laplaceSLPfmm(den,x,y);
    
    Vx = Vx - dxx*dt;
    Vy = Vy - dyy*dt;

    x = x + dt*Vx;
    y = y + dt*Vy;
    %scatter(xD,yD);
    %title('Direct');
    %xlim([0,101]);
    %ylim([0,101]);
    %pause(0.01);
    %drawnow
    %frame = getframe(1);
    %im = frame2im(frame);
    %[imind,cm] = rgb2ind(im,256);
    %imwrite(imind,cm,filename,'gif','WriteMode','append');
    error(i) = norm(((x-xD).^2+(y-yD).^2).^.5,inf);
    x = xD;
    y = yD;
    Vx = VxD;
    Vy = VyD;
end

plot([1:steps],error)


