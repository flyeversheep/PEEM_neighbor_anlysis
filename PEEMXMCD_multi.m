function PEEMXMCD_multi(thresholddiff,thresholdsame,folder,geometry,spacing,lowT,highT,points)
temperature = linspace(lowT,highT,points);
for i = 1:points
    for location = 1:4
        filename = sprintf('%s/%s%d_%3dK_%1d#_%s.csv',folder,geometry,spacing,temperature(i),location,geometry);
        filename1 = sprintf('%s/%s%d_%3dK_%1d#_%s1.csv',folder,geometry,spacing,temperature(i),location,geometry);
        resultname = sprintf('%s/%s%d_%3dK_%1d#_XMCD_%d_%d.csv',folder,geometry,spacing,temperature(i),location,thresholddiff,thresholdsame);
        if(exist(filename,'file'))
            PEEMXMCD(thresholddiff,thresholdsame,filename,resultname);
        elseif(exist(filename1,'file'))
            PEEMXMCD(thresholddiff,thresholdsame,filename1,resultname);
        end
    end
end
end

function result = PEEMXMCD(thresholddiff,thresholdsame,filename,resultname)
    %The thresholddiff is the parameter to adjust the sensitivity to detect
    %the flip during exposure between different polarization. The larger
    %the number is, the more sensitive thedetector will be. 

    %Thresholdsame is the parameter to adjust the sensitivity to detect
    %the flip between during exposure same polarization. The smaller the number is, the
    %more sensitive the detector will be. Note: The random noise will generate a
    %difference of 10. 
    
    spread = csvread(filename);
    dim = size(spread);
    result = zeros(dim(1),dim(2));
    result(:,1:2) = spread(:,1:2);
%     orientation2 = zeros(1,dim(1));
%find out the orientation of the 2nd frame
    for i = 1:dim(1)
        result(i,4) = findspin(spread(i,3:dim(2)),2,thresholddiff,thresholdsame);
    end
%find out the orientation of the 1st frame
    diff = spread(:,3)-spread(:,4);
    signnow = sign(spread(:,3)-spread(:,4));
    marker = signnow.*result(:,4) == 1;
    mask = abs(diff)>thresholdsame&marker;
    result(:,3)=result(:,4);
    result(mask,3) = result(mask,3)*(-1);
%find out the orientation of the rest of the frame
    for i = 5:dim(2)
        signnow = sign(spread(:,i)-spread(:,i-1));
        diff = spread(:,i)-spread(:,i-1);
        result(:,i)=result(:,i-1);
        if(mod(i,4)==1)
            %L and R. When the spin is negative, in order to change the
            %orientation, the intensity can eighter go up or drop down by
            %an amount that is smaller than the threshold
            marker = signnow.*result(:,i) == -1;
            mask = abs(diff)<thresholddiff|marker;
        elseif(mod(i,4)==2)
            %R same
            marker = signnow.*result(:,i)==-1;
            mask = abs(diff)>thresholdsame&marker;
        elseif(mod(i,4)==3)
            %R and L. 
            marker = signnow.*result(:,i) == 1;
            mask = abs(diff)<thresholddiff|marker;
        elseif(mod(i,4)==0)
            %L same. When the spin is negative, the intensity has to drop
            %and the difference has to be larger than threshold in order to
            %change orientation.
            marker = signnow.*result(:,i)==1;
            mask = abs(diff)>thresholdsame&marker;
        end
        result(mask,i) = result(mask,i)*(-1);
%-------------------------------------------------------------------------------
%         if(mod(i,2)==0)
%             result(diff>thresholdsame,i) = result(diff>thresholdsame,i)*(-1);
%         else
%-------------------------------------------------------------------------------            
%to infer the spin orientation based on the former spin
%             result(diff<thresholddiff,i) = result(diff<thresholddiff,i)*(-1);
            
%------------------------------------------------------------------------------
%------------------------------------------------------------------------------
%to calculate the spin information using adjacent frame
%         for k = 1:dim(1)
%             result(k,i) = findspin(spread(k,3:dim(2)),i-2,thresholddiff,thresholdsame);
%         end
%------------------------------------------------------------------------------
%     end
%------------------------------------------------------------------------------
    end
    csvwrite(resultname,result);
end

function spread = PEEMspread(fname,maskin)
%This function transform the spreadsheets into one spreadsheet
total = 64;
maskn = sprintf('%s.xls',maskin);
mask = xlsread(maskn);
for k = 1:total
   filename = sprintf('%s%04d.xls',fname,k-1);
   temp = xlsread(filename);
   if (k==1)
       dim = size(temp);
       element = nnz(mask(1:dim(1),1:dim(2)));
       spread = zeros(element,total+2);
       count=1;
       for i = 1:dim(1)
           for j = 1:dim(2)
               if(mask(i,j)~=0)
                   spread(count,1) = i;
                   spread(count,2) = j;
                   count = count+1;
               end
           end
       end
   end
   count=1;
   for i = 1:dim(1)
       for j = 1:dim(2)
           if(mask(i,j)~=0)
               spread(count,k+2) = temp(i,j);
               count=count+1;
           end
       end
   end
end
sheetname = sprintf('%s_%s.csv',fname,maskin);
csvwrite(sheetname,spread);
end

function [orientation] = findspin(timeseries,time,thresholddiff,thresholdsame)
%This function find the spin orientation information of the islands at
%specific time
%This function only works for LLRRLLRR exposure
if(time+1>size(timeseries))
    orientation = 0;
    return
end
diff=timeseries(time+1)-timeseries(time);
if(mod(time/2,2)==1)
    sign=1;
else
    sign=-1;
end
if(diff>thresholddiff)
    orientation = 1*sign;
elseif(diff<-thresholddiff)
    orientation = -1*sign;
else
    if(time+2>size(timeseries))
        orientation = 0;
        return
    end
    orientationplustwo = findspin(timeseries,time+2,thresholddiff,thresholdsame);
    diff2 = timeseries(time+2)-timeseries(time+1);
    if (abs(diff2)>thresholdsame)
        orientation = orientationplustwo;
    else
        orientation = (-1)*orientationplustwo;
    end
end
end