function fliprate_multi(filen1,filen2,fractionfile)
fraction = csvread(fractionfile);
dim1 = size(fraction);

result = zeros(dim1(1),5);
result(:,1) = fraction(:,1);
for i = 1:dim1(1)
     if(fraction(i,2)~=0&&fraction(i,4)~=0)
        [result(i,2),result(i,3),result(i,4),result(i,5)] = ...
            fliprate(filen1,filen2,fraction(i,2),fraction(i,3),...
            fraction(i,4),fraction(i,5));
     else
         result(i,2) = 0;
         result(i,3) = 0;
     end
     
end
resultname = sprintf('fliprate_%s.csv',fractionfile(1:end-4));
csvwrite(resultname,result);
end
function [ fliprate1,error1,fliprate2,error2 ] = fliprate( filen1,filen2,fraction1,std1,fraction2,std2 )
% This function calculate the inequivalent flipping rate due to energy
% asymmetry using fraction of odd flipping events during two different gap
% time. This version can also caculate the error
% Input: filen1 and filen2 are the file name containing matrix of the same
% size. The first column is one flipping rate, the second column is another
% flipping rate and the third column is the fraction of odd flipping events
% with that specific set of flipping rate. 
length=600;
file1 = csvread(filen1);
file2 = csvread(filen2);
x = linspace(min(file1(:,1)),max(file1(:,1)),length);
y = linspace(min(file2(:,1)),max(file2(:,2)),length);
% file1matrix = reshape(file1(:,3),length(1),length);
% file2matrix = reshape(file2(:,3),length(1),length);
% figure;imagesc(x,y,file1matrix);title(filen1);set(gca,'Ydir','Normal');
% figure;imagesc(x,y,file2matrix);title(filen2);set(gca,'Ydir','Normal');

dim1 = size(file1);
dim2 = size(file2);
if(dim1~= dim2)
    display('Mistake! The two files have different sizes.')
    return
end
difference1 = zeros(dim1);
difference1(:,1:2) = file1(:,1:2);
difference1(:,3) = abs((file1(:,3)-fraction1));
diff1matrix = reshape(difference1(:,3),length,length);
% figure;imagesc(x,y,diff1matrix);title('difference1');set(gca,'Ydir','Normal');
difference2 = zeros(dim2);
difference2(:,1:2) = file2(:,1:2);
difference2(:,3) = abs((file2(:,3)-fraction2));
diff2matrix = reshape(difference2(:,3),length,length);
% figure;imagesc(x,y,diff2matrix);title('difference2');set(gca,'Ydir','Normal');
result = zeros(dim1);
result(:,1:2) = file1(:,1:2);
result(difference1(:,3)<std1&difference2(:,3)<std2,3)=1;
result(result(:,1)<result(:,2),3)=0;
resultmatrix = reshape(result(:,3),length,length);
figure;imagesc(x,y,resultmatrix);title('intersect');set(gca,'Ydir','Normal');
% 
%  difference(1,difference(:,3)==min(difference(:,3)))
% fliprate2 = difference(2,difference(:,3)==min(difference(:,3)));

fliprate1=mean(result(result(:,3)==1,2));
error1 = std(result(result(:,3)==1,2));
fliprate2=mean(result(result(:,3)==1,1));
error2 = std(result(result(:,3)==1,1));



end

