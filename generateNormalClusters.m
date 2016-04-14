function [x,y] = generateNormalClusters ( xMin, xMax, yMin, yMax,pointCount)
%initialize point array
pointCloud = zeros(pointCount,2);
%generate a random x and y pair for each point
mu = (xMax*.75 - xMin*1.25)*rand() + xMin*1.25;
sigma = .5*((xMax-xMax*.75)-(xMin*1.25-xMin))*rand() + (xMin*1.25-xMin);
mu2 = (yMax*.75 - yMin*1.25)*rand() + yMin*1.25;
sigma2 = .5*((yMax-yMax*.75)-(yMin*1.25-yMin))*rand() + (yMin*1.25-yMin);
for i = 1:pointCount/2
    pointCloud(i,1) = normrnd(mu, sigma); 
    pointCloud(i,2) = normrnd( mu2, sigma2);
end
mu = (xMax*.75 - xMin*1.25)*rand() + xMin*1.25;
sigma = .5*((xMax-xMax*.75)-(xMin*1.25-xMin))*rand() + (xMin*1.25-xMin);
mu2 = (yMax*.75 - yMin*1.25)*rand() + yMin*1.25;
sigma2 = .5*((yMax-yMax*.75)-(yMin*1.25-yMin))*rand() + (yMin*1.25-yMin);
for i = pointCount/2:pointCount
    pointCloud(i,1) = normrnd(mu, sigma); 
    pointCloud(i,2) = normrnd( mu2, sigma2);
end
x = pointCloud(:,1);
y = pointCloud(:,2);
%{
%save stored information
fileID = fopen('uniformData.txt','w');
fprintf(fileID,'%d\n',pointCount);
fprintf(fileID,'%f\t%f\n',pointCloud);
fclose(fileID);
scatter(pointCloud(:,1),pointCloud(:,2));
%}
end 