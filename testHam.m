%This file calculates the Hamiltonian and the difference between the direct
%and FMM solver
clear all
format long
%Notice that H goes down as t->0
dt = 0.001;
steps = 100;

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
Vx = zeros(N,1);
Vy = zeros(N,1);
Vx2 = zeros(N,1);
Vy2 = zeros(N,1);
VxD = zeros(N,1);
VyD = zeros(N,1);
error = zeros(steps,1);
%Linf = zeros(steps,1);
H = zeros(steps,1);
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

    %Do same thing for perturbed data

    %figure;
    %scatter(x,y)
    %xlim([-10,10]);
    %ylim([-10,10]);
    %pause
    
    errx = norm(dxx - dxxD,inf)/norm(dxxD,inf);
    erry = norm(dyy - dyyD,inf)/norm(dyyD,inf);
    error(i) = max(errx,erry);

    %Calculate the Hamiltonian
    H(i) = sum(Vx.^2+Vy.^2)/2;
    temp = zeros(N,1);
    for j = 1:N
        ind = [(1:j-1) (j+1:N)];
        rho = sqrt((x(j) - x(ind)).^2 + (y(j) - y(ind)).^2);
        temp(j) = -sum((den(ind)/2/pi).*log(rho));
    end
    H(i) = H(i) - sum(temp);
end
figure;
semilogy(1:steps,error);

H(1)-H(steps)
figure;
plot(1:steps,H);