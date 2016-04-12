function [] = generateNormalClusters ( xMin, xMax, yMin, yMax,pointCount)
%initialize point array
pointCloud = zeros(pointCount,2);
%generate a random x and y pair for each point
mu = randi([xMin,xMax]);
sigma = randi([xMin,xMax]);
mu2 = randi([yMin,yMax]);
sigma2 = randi([yMin,yMax]);
for i = 1:pointCount/2
    pointCloud(i,1) = normrnd(1, sigma); 
    pointCloud(i,2) = normrnd( 1, sigma2);
end
mu = randi([xMin,xMax]);
sigma = randi([xMin,xMax]);
mu2 = randi([yMin,yMax]);
sigma2 = randi([yMin,yMax]);
for i = pointCount/2:pointCount
    pointCloud(i,1) = normrnd(1, sigma); 
    pointCloud(i,2) = normrnd( 1, sigma2);
end
%save stored information
fileID = fopen('normalData.txt','w');
%fprintf(fileID,'%d\n',pointCount);
fprintf(fileID,'%f\t%f\n',pointCloud);
fclose(fileID);
scatter(pointCloud(:,1),pointCloud(:,2));
end