function fraction_average( filename)
%This function average the fraction of odd flipping events by temperature
%This function do a moving average of 3 temperature points
filen = sprintf('%s.csv',filename);
averagename = sprintf('%s_average.csv',filename);
array = csvread(filen);
temperature = unique(array(:,1));

result = zeros(length(temperature),5);
result(:,1) = temperature;
for i=1:length(temperature)
    total1 = sum(array(array(:,1)==temperature(i),2));
    total2 = sum(array(array(:,1)==temperature(i),5));
    posi1 = sum(array(array(:,1)==temperature(i),3));
    nega1 = sum(array(array(:,1)==temperature(i),4));
    posi2 = sum(array(array(:,1)==temperature(i),6));
    nega2 = sum(array(array(:,1)==temperature(i),7));
    total = total1+total2;
    posi = posi1+posi2;
    nega = nega1+nega2;
    pposi = posi/total;
    pnega = nega/total;
    result(i,2) = pposi;
    result(i,4) = pnega;
    result(i,3) = sqrt(pposi*pnega/total);
    result(i,5) = sqrt(pposi*pnega/total);
    result(i,6) = 1/log(pposi/pnega);
end
csvwrite(averagename,result);


end

