clear all
N = [2^12,2^13,2^14];
FMMTime = zeros(length(N),1);
directTime = zeros(length(N),1);
absoluteError = zeros(length(N),1);
for i = 1:length(N)
    theta = (0:N(i)-1)'*2*pi/N(i);

    x = cos(theta);
    y = exp(sin(theta));
    den = exp(cos(theta));
    %x = rand(N,1);
    %y = rand(N,1);
    %den = rand(N,1);


    tic
    [dx,dy] = laplaceSLPfmm(den,x,y);
    FMMTime(i) = toc;

    dx_direct = zeros(N(i),1);
    dy_direct = zeros(N(i),1);
    tic
    for j = 1:N(i)
        ind = [(1:j-1) (j+1:N(i))];
        rho2 = (x(j) - x(ind)).^2 + (y(j) - y(ind)).^2;
        dx_direct(j) = sum(den(ind).*(x(j) - x(ind))./rho2);
        dy_direct(j) = sum(den(ind).*(y(j) - y(ind))./rho2);
    end
    directTime(i) = toc;
    dx_direct = dx_direct/2/pi;
    dy_direct = dy_direct/2/pi;

    errx = norm(dx - dx_direct,inf)/norm(dx_direct,inf);
    erry = norm(dy - dy_direct,inf)/norm(dy_direct,inf);
    absoluteError(i) = max(errx,erry);
end
figure()
plot(log(N),FMMTime);
figure()
plot(log(N),directTime);
figure()
plot(log(N),absoluteError);
