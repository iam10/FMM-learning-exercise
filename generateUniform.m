function [] = generateUniform( xMin, xMax, yMin, yMax,pointCount)
%initialize point array
pointCloud = zeros(pointCount,2);
%generate a random x and y pair for each point
for i = 1:pointCount
    pointCloud(i,1) = (xMax - xMin)*rand() + xMin; 
    pointCloud(i,2) = (yMax - yMin)*rand() + yMin;
end
%save stored information
fileID = fopen('uniformData.txt','w');
%fprintf(fileID,'%d\n',pointCount);
fprintf(fileID,'%f\t%f\n',pointCloud);
fclose(fileID);
end