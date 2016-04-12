clear all
format long
dt = 1;
steps = 400;

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

den = ones(N,1);
Vx = 0;
Vy = 0;
VxD = 0;
VyD = 0;
Linf = zeros(steps,1);
for i = 1:steps
    dxx = zeros(N,1);
    dyy = zeros(N,1);
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
    
    %disp(dxx);
    %disp(dxxD);
    if i == 174
        scatter(x,y)
    end
    %xlim([-10,10]);
    %ylim([-10,10]);
    %pause
    
    error = [abs(dxx-dxxD) abs(dyy-dyyD)];
    Linf(i) = norm(error,inf);
    x = xD;
    y = yD;
end
%semilogy(1:steps,Linf);

%scatter(x,y)