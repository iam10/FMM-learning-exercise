%This file calculates the Hamiltonian and the difference between the direct
%and FMM solver
clear all
%Notice that H goes down as t->0
Energies = zeros(2,1);
fileID = fopen('uniformDataUnperturbed.txt','r');
formatSpec = '%f %f';
sizeA = [2 Inf];
A = fscanf(fileID,formatSpec,sizeA);
A = A';
x = A(:,1);
y = A(:,2);
N = length(x);
for dt = [.1,.01,.001,.0001]
    steps = 10/dt;
    den = ones(N,1);
    Vx = zeros(N,1);
    Vy = zeros(N,1);
    H = zeros(2,1);
    for i = 1:steps
    
        [dxx,dyy] = laplaceSLPfmm(den,x,y);
    
        Vx = Vx - dxx*dt;
        Vy = Vy - dyy*dt;

        x = x + dt*Vx;
        y = y + dt*Vy;

    

        %Calculate the Hamiltonian
        if(i==steps||i==1)
            indx = mod(i,steps)+1;
            H(indx) = sum(Vx.^2+Vy.^2)/2;
            temp = zeros(N,1);
            for j = 1:N
                ind = [(1:j-1) (j+1:N)];
                rho = sqrt((x(j) - x(ind)).^2 + (y(j) - y(ind)).^2);
                temp(j) = -sum((den(ind)/2/pi).*log(rho));
            end
            H(indx) = H(indx) - sum(temp);
        end
    end
    Energies((log10(dt)*-1)) = abs(H(1)-H(2));
end

figure;
plot([.1,.01,.001,.0001],Energies);
