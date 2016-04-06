function [] = generateNormalClusters ( xMin, xMax, yMin, yMax,pointCount)
%initialize point array
pointCloud = zeros(pointCount,2);
%generate a random x and y pair for each point
mu = randi([0,100]);
sigma = randi([0,100]);
mu2 = randi([0,100]);
sigma2 = randi([0,100]);
for i = 1:pointCount/2
    pointCloud(i,1) = (xMax - xMin)*normrnd(mu, sigma) + xMin; 
    pointCloud(i,2) = (yMax - yMin)*normrnd( mu2, sigma2) + yMin;
end
mu = randi([0,100]);
sigma = randi([0,100]);
mu2 = randi([0,100]);
sigma2 = randi([0,100]);
for i = pointCount/2:pointCount
    pointCloud(i,1) = (xMax - xMin)*normrnd(mu, sigma) + xMin; 
    pointCloud(i,2) = (yMax - yMin)*normrnd( mu2, sigma2) + yMin;
end
%save stored information
fileID = fopen('uniformData.txt','w');
fprintf(fileID,'%d\n',pointCount);
fprintf(fileID,'%f\t%f\n',pointCloud);
fclose(fileID);
scatter(pointCloud(:,1),pointCloud(:,2));
end