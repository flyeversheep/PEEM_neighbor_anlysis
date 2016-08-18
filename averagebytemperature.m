function averagebytemperature( filename )
%This function average the fraction of odd flipping events by temperature

filen = sprintf('%s.csv',filename);
averagename = sprintf('%s_average.csv',filename);
array = csvread(filen);
temperature = unique(array(:,1));

result = zeros(length(temperature),3);
result(:,1) = temperature;
for i=1:length(temperature)
    result(i,2) = mean(array(array(:,1)==temperature(i),6));
    result(i,3) = mean(array(array(:,1)==temperature(i),7));
end
csvwrite(averagename,result);


end

