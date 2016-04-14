clear all
format long
dt = 0.1;
steps = 100;

fileID = fopen('uniformDataUnperturbed.txt','r');
formatSpec = '%f %f';
sizeA = [2 Inf];
A = fscanf(fileID,formatSpec,sizeA);
A = A';
xs = A(:,1);
ys = A(:,2);
N = length(xs);

den = ones(N,1);
x2 = zeros(N,1);
y2 = zeros(N,1);
Vx = zeros(N,1);
Vy = zeros(N,1);
Vx2 = zeros(N,1);
Vy2 = zeros(N,1);
VxD = zeros(N,1);
VyD = zeros(N,1);
VxD2 = zeros(N,1);
VyD2 = zeros(N,1);
xDiff = zeros(steps,1);
yDiff = zeros(steps,1);
xDiffD = zeros(steps,1);
yDiffD = zeros(steps,1);
nPerts = 20;
maxDiff = zeros(nPerts,1);
maxDiffD = zeros(nPerts,1);
pert = zeros(nPerts,1);
for p = nPerts:-1:1
    pert(p) = 10^-p;
    x = xs;
    y = ys;
    for i = 1:N
        %Here i did perturbations based of a % of the original
        %because we don't know how big the original is(could be a million)
        x2(i) = x(i) + x(i)*((2*pert(p))*rand()-pert(p));
        y2(i) = y(i) + y(i)*((2*pert(p))*rand()-pert(p));
    end
    xD = x;
    yD = y;
    xD2 = x2;
    yD2 = y2;
    for i = 1:steps
        
        %Do same thing for perturbed data
        [dxx2,dyy2] = laplaceSLPfmm(den,x2,y2);

        Vx2 = Vx2 - dxx2*dt;
        Vy2 = Vy2 - dyy2*dt;

        x2 = x2 + dt*Vx2;
        y2 = y2 + dt*Vy2;

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
        dxxD2 = zeros(N,1);
        dyyD2 = zeros(N,1);
        for j = 1:N
            ind = [(1:j-1) (j+1:N)];
            rho2 = (xD2(j) - xD2(ind)).^2 + (yD2(j) - yD2(ind)).^2;
            dxxD2(j) = sum(den(ind).*(xD2(j) - xD2(ind))./rho2);
            dyyD2(j) = sum(den(ind).*(yD2(j) - yD2(ind))./rho2);
        end
        dxxD2 = dxxD2/2/pi;
        dyyD2 = dyyD2/2/pi;
    
        VxD2 = VxD2 - dxxD2*dt;
        VyD2 = VyD2 - dyyD2*dt;

        xD2 = xD2 + dt*VxD2;
        yD2 = yD2 + dt*VyD2;
        xDiff(i) = norm(abs(xD-x2),inf);
        yDiff(i) = norm(abs(yD-y2),inf);
        xDiffD(i) = norm(abs(xD-xD2),inf);
        yDiffD(i) = norm(abs(yD-yD2),inf);
        %figure;
        %scatter(x,y,x2,y2);
        %scatter(x,y)
        %xlim([-10,10]);
        %ylim([-10,10]);
        %pause
    end
    maxDiff(p) = max(xDiff);
    maxDiffD(p) = max(xDiffD);
end
%maxDiff
figure;
loglog(pert.^-1,maxDiff,pert.^-1,maxDiffD);