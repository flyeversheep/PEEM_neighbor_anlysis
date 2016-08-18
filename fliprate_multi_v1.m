function fliprate_multi_v1(filen1,filen2,fractionfile)
fraction = csvread(fractionfile);
dim1 = size(fraction);

result = zeros(dim1(1),3);
result(:,1) = fraction(:,1);
for i = 1:dim1(1)
     if(fraction(i,2)~=0&&fraction(i,3)~=0)
        [result(i,2),result(i,3)] = fliprate(filen1,filen2,fraction(i,2),fraction(i,3),result(i,1),fractionfile);
     else
         result(i,2) = 0;
         result(i,3) = 0;
     end
     
end
resultname = sprintf('fliprate_%s.csv',fractionfile(1:end-4));
csvwrite(resultname,result);
end
function [ fliprate1,fliprate2 ] = fliprate( filen1,filen2,fraction1,fraction2,T,fractionfile )
% This function calculate the inequivalent flipping rate due to energy
% asymmetry using fraction of odd flipping events during two different gap
% time. 
% Input: filen1 and filen2 are the file name containing matrix of the same
% size. The first column is one flipping rate, the second column is another
% flipping rate and the third column is the fraction of odd flipping events
% with that specific set of flipping rate. 
length = 300;
file1 = csvread(filen1);
file2 = csvread(filen2);
x = linspace(min(file1(:,1)),max(file1(:,1)),length);
y = linspace(min(file2(:,1)),max(file2(:,2)),length);
file1matrix = reshape(file1(:,3),length,length);
file2matrix = reshape(file2(:,3),length,length);
% figure;imagesc(x,y,file1matrix);title(filen1);
% figure;imagesc(x,y,file2matrix);title(filen2);

dim1 = size(file1);
dim2 = size(file2);
if(dim1~= dim2)
    display('Mistake! The two files have different sizes.')
    return
end
difference = zeros(dim1);
difference(:,1:2) = file1(:,1:2);
% difference(:,3) = sqrt(((file1(:,3)-fraction1)).^2+((file2(:,3)-fraction2)).^2);
norm1 = fraction1;
norm2 = fraction2;
difference(:,3) = sqrt(((file1(:,3)-fraction1)/norm1).^2+((file2(:,3)-fraction2)/norm2).^2);
% 
%  difference(1,difference(:,3)==min(difference(:,3)))
% fliprate2 = difference(2,difference(:,3)==min(difference(:,3)));
mindiff = min(difference(:,3));
fliprate1=difference(difference(:,3)==mindiff,1);
fliprate2=difference(difference(:,3)==mindiff,2);
if(fliprate2<fliprate1)
    fliptemp = fliprate1;
    fliprate1 = fliprate2;
    fliprate2 = fliptemp;
end
diffmatrix = reshape(difference(:,3),length,length);
figure;imagesc(x,y,diffmatrix);xlabel('flip rate 1');ylabel('flip rate 2');
t=title([fractionfile,'_T=',num2str(T),'K']);set(t,'Interpreter','none');set(gca,'Ydir','Normal');
colorbar;
% csvwrite('error_map.csv',difference);
fliprate1 =fliprate1(1);
fliprate2 =fliprate2(1);
end

