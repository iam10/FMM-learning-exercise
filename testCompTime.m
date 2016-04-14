clear all
format long
N = [2^8,2^9,2^10,2^11,2^12,2^13,2^14,2^15,2^16];

xMin = 1;
xMax = 1000000;
yMin = 1;
yMax = 1000000;

directTime = zeros(length(N),1);
fmmTime = zeros(length(N),1);

for i = 1:length(N)
    pointCloud = zeros(N(i),2);
    %generate a random x and y pair for each point
    for j = 1:(N(i))
        pointCloud(j,1) = (xMax - xMin)*rand() + xMin; 
        pointCloud(j,2) = (yMax - yMin)*rand() + yMin;
    end
    x = pointCloud(:,1);
    y = pointCloud(:,2);
    den = ones(N(i),1);
    dxxD = zeros(N(i),1);
    dyyD = zeros(N(i),1);
    tic
    for j = 1:N(i)
        ind = [(1:j-1) (j+1:N(i))];
        rho2 = (x(j) - x(ind)).^2 + (y(j) - y(ind)).^2;
        dxxD(j) = sum(den(ind).*(x(j) - x(ind))./rho2);
        dyyD(j) = sum(den(ind).*(y(j) - y(ind))./rho2);
    end
    directTime(i) = toc;

    tic
    [dxx,dyy] = laplaceSLPfmm(den,x,y);
    fmmTime(i) = toc;
 
end

plot(N,directTime,'-ro',N,fmmTime,'-.b');
legend('direct','fmm','Location','northwest');


