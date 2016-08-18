function detect_changed_multi(nnp,nnn,nnnp,nnnn,thresholddiff,thresholdsame,folder,geometry,spacing,lowT,highT,points)
% This function detect the islands that flip under a specfic enviornment at
% different temperature. 

temperature = linspace(lowT,highT,points);
result = zeros(points*4,7);
count = 1;
for i = 1:points
        for location = 1:4
            filename = sprintf('%s/%s%d_%3dK_%1d#_XMCD_%d_%d.csv',folder,geometry,spacing,temperature(i),location,thresholddiff,thresholdsame);
            if(exist(filename,'file'))
                [LLRRtotal,LLRRchanged,LRtotal,LRchanged]=detect_changed ( nnp,nnn,nnnp,nnnn,filename);
                result(count,1) = temperature(i);
                result(count,2) = LLRRtotal;
                result(count,3) = LLRRchanged;
                result(count,4) = LRtotal;
                result(count,5) = LRchanged;
                result(count,6) = double(LLRRchanged/LLRRtotal);
                result(count,7) = double(LRchanged/LRtotal);
                count = count+1;
            end
        end
end
resultname = sprintf('%s%d_NN%d_%dNNN%d_%d_threshold%d_%d.csv',geometry,spacing,nnp,nnn,nnnp,nnnn,thresholddiff,thresholdsame);
csvwrite(resultname,result(1:count-1,:));
end

function  [LLRRtotal,LLRRchanged,LRtotal,LRchanged]=detect_changed ( nnp,nnn,nnnp,nnnn,xmcdfilename)
% This function detect the islands that flip under a specific environment 
% nnp means the number of nearest neighbor prefering positive orientation. 
% nnn means the number of nearest neighbor prefering negative orientation.
% nnnp means the number of next nearest neighbor prefering positive
% orientation.
% nnnn means the number of next nearest neighbor prefering negative
% orientation. 
% This code only works for LLRRLLRR exposure



xmcd = csvread(xmcdfilename);
dim = size(xmcd);

LLRRtotal=0;
LLRRchanged=0;
LRtotal=0;
LRchanged=0;
for i = 2:max(xmcd(:,1)-1)
    for j = 2:max(xmcd(:,2)-1)
        countnn = 0;
        countnnn = 0;

            nnxmcd1 = zeros(1,dim(2)-2);
            nnxmcd2 = zeros(1,dim(2)-2);
            nnxmcd3 = zeros(1,dim(2)-2);
            nnxmcd4 = zeros(1,dim(2)-2);
            nnnxmcd1 = zeros(1,dim(2)-2);
            nnnxmcd2 = zeros(1,dim(2)-2);
            if(~isempty(xmcd(xmcd(:,1)==i&xmcd(:,2)==j-1,:)))
                countnn = countnn+1;
                nnxmcd1 = xmcd(xmcd(:,1)==i&xmcd(:,2)==j-1,3:end);
            end
            if(~isempty(xmcd(xmcd(:,1)==i&xmcd(:,2)==j+1,:)))
                countnn = countnn+1;
                nnxmcd2 = xmcd(xmcd(:,1)==i&xmcd(:,2)==j+1,3:end);
            end
            if(~isempty(xmcd(xmcd(:,1)==i-1&xmcd(:,2)==j,:)))
                countnn = countnn+1;
                nnxmcd3 = xmcd(xmcd(:,1)==i-1&xmcd(:,2)==j,3:end);
            end
            if(~isempty(xmcd(xmcd(:,1)==i+1&xmcd(:,2)==j,:)))
                countnn = countnn+1;
                nnxmcd4 = xmcd(xmcd(:,1)==i+1&xmcd(:,2)==j,3:end);
            end
            if(mod(i+j,2)==0)
                
                if(~isempty(xmcd(xmcd(:,1)==i-1&xmcd(:,2)==j-1,:)))
                    countnnn = countnnn+1;
                    nnnxmcd1 = xmcd(xmcd(:,1)==i-1&xmcd(:,2)==j-1,3:end);
                end
                if(~isempty(xmcd(xmcd(:,1)==i+1&xmcd(:,2)==j+1,:)))
                    countnnn = countnnn+1;
                    nnnxmcd2 = xmcd(xmcd(:,1)==i+1&xmcd(:,2)==j+1,3:end);
                end
                
            else
                if(~isempty(xmcd(xmcd(:,1)==i-1&xmcd(:,2)==j+1,:)))
                    countnnn = countnnn+1;
                    nnnxmcd1 = xmcd(xmcd(:,1)==i-1&xmcd(:,2)==j+1,3:end);
                end
                if(~isempty(xmcd(xmcd(:,1)==i+1&xmcd(:,2)==j-1,:)))
                    countnnn = countnnn+1;
                    nnnxmcd2 = xmcd(xmcd(:,1)==i+1&xmcd(:,2)==j-1,3:end);
                end
            end
            if(countnn==nnp+nnn && countnnn==nnnp+nnnn)
                nnxmcd = nnxmcd1+nnxmcd2-nnxmcd3-nnxmcd4;
                nnnxmcd = nnnxmcd1+nnnxmcd2;
                XMCDinformation = xmcd(xmcd(:,1)==i&xmcd(:,2)==j,3:end);
                if(~isempty(XMCDinformation))
                    for k = 1:size(XMCDinformation,2)-1
                        if(abs(nnp-nnn)==abs(nnxmcd(k)) && abs(nnnp-nnnn)==abs(nnnxmcd(k)) && sign((nnp-nnn)*(nnnp-nnnn))==sign(nnxmcd(k)*nnnxmcd(k)))
                            if(mod(k,2)==1)
                                %LL
                                LLRRtotal=LLRRtotal+1;
                                if(XMCDinformation(k)~=XMCDinformation(k+1))
                                    LLRRchanged = LLRRchanged+1;
                                end
                            else
                                %LR
                                LRtotal=LRtotal+1;
                                if(XMCDinformation(k)~=XMCDinformation(k+1))
                                    LRchanged = LRchanged+1;
                                end
                            end
                        end
                    end
                end
            end

    end
end

end

