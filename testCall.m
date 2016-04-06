setenv('PATH', [getenv('PATH') ';C:\MinGW\bin']);
N = 2^12;
theta = (0:N-1)'*2*pi/N;

%x = cos(theta);
%y = exp(sin(theta));
%den = exp(cos(theta));
x = rand(N,1);
y = rand(N,1);
den = rand(N,1);


tic
[dx,dy] = laplaceSLPfmm(den,x,y);
fprintf('FMM required      %4.2e seconds\n',toc)

dx_direct = zeros(N,1);
dy_direct = zeros(N,1);
tic
for j = 1:N
  ind = [(1:j-1) (j+1:N)];
  rho2 = (x(j) - x(ind)).^2 + (y(j) - y(ind)).^2;
  dx_direct(j) = sum(den(ind).*(x(j) - x(ind))./rho2);
  dy_direct(j) = sum(den(ind).*(y(j) - y(ind))./rho2);
end
fprintf('Direct required   %4.2e seconds\n',toc)
dx_direct = dx_direct/2/pi;
dy_direct = dy_direct/2/pi;

errx = norm(dx - dx_direct,inf)/norm(dx_direct,inf);
erry = norm(dy - dy_direct,inf)/norm(dy_direct,inf);
fprintf('Absolute error is %4.2e\n',max(errx,erry))



