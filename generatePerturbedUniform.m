function [] = generatePerturbedUniform( xMin, xMax, yMin, yMax,pointCount)
%initialize point arrays
pointCloud = zeros(pointCount,2);
pointCloudPerturbed = pointCloud;
%generate a random x and y pair for each point
for i = 1:pointCount
    pointCloud(i,1) = (xMax - xMin)*rand() + xMin; 
    pointCloud(i,2) = (yMax - yMin)*rand() + yMin;
    %perturb from original
    pointCloudPerturbed(i,1) = pointCloud(i,1) + ...
    ((.00000002)*rand()-.00000001);
    pointCloudPerturbed(i,2) = pointCloud(i,1) + ...
    ((.00000002)*rand()-.00000001);
end
%save stored information for unperturbed data
fileID = fopen('uniformDataUnperturbed.txt','w');
fprintf(fileID,'%d\n',pointCount);
fprintf(fileID,'%f\t%f\n',pointCloud);
fclose(fileID);
%save stored information for perturbed data
fileID = fopen('uniformDataPerturbed.txt','w');
fprintf(fileID,'%d\n',pointCount);
fprintf(fileID,'%f\t%f\n',pointCloudPerturbed);
fclose(fileID);
end