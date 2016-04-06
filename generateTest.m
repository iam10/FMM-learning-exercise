function generateTest
size = 2^4;
x = zeros(size,1);
y = zeros(size,1);

iter = 1;
for i = 1:4
    for j = 1:4
        x(iter) = i + (2*rand-1)*10^(-5);
        y(iter) = j + (2*rand-1)*rand*10^(-5);
        iter = iter + 1;
    end
end
scatter(x,y);
fileID = fopen('testData.txt','w');
fprintf(fileID,'%d\t%d\n',size,size);
for i = 1:length(x)
    fprintf(fileID,'%f\t%f\n',x(i),y(i));
end
fclose(fileID);


A2 = load('newtestData.txt');
x2 = A2(:,1);
y2 = A2(:,2);
x2(1) = [];
y2(1) = [];
figure;
scatter(x2,y2);
for i = 1:length(x)
    fprintf('%f\t%f\n',x2(i),y2(i));
end
end