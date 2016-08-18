function fraction_config_multi(nnp,nnn,nnnp,nnnn,thresholddiff,thresholdsame,folder,geometry,spacing,lowT,highT,points)
% This function detect the islands that flip under a specfic enviornment at
% different temperature. 

temperature = linspace(lowT,highT,points);
result = zeros(points*4,9);
count = 1;
for i = 1:points
        for location = 1:4
            filename = sprintf('%s/%s%d_%3dK_%1d#_XMCD_%d_%d.csv',folder,geometry,spacing,temperature(i),location,thresholddiff,thresholdsame);
            if(exist(filename,'file'))
                [firsttotal,firstpositive,firstnegative,secondtotal,secondpositive,secondnegative]=detect_changed ( nnp,nnn,nnnp,nnnn,filename);
                result(count,1) = temperature(i);
                result(count,2) = firsttotal;
                result(count,3) = firstpositive;
                result(count,4) = firstnegative;
                result(count,5) = secondtotal;
                result(count,6) = secondpositive;
                result(count,7) = secondnegative;
                result(count,8) = double((firstpositive+secondpositive)/(firsttotal+secondtotal));
                result(count,9) = double((firstnegative+secondnegative)/(firsttotal+secondtotal));
                count = count+1;
            end
        end
end
resultname = sprintf('fraction_%s%d_NN%d_%dNNN%d_%d_threshold%d_%d.csv',geometry,spacing,nnp,nnn,nnnp,nnnn,thresholddiff,thresholdsame);
csvwrite(resultname,result(1:count-1,:));
end

function  [firsttotal,firstpositive,firstnegative,secondtotal,secondpositive,secondnegative]=detect_changed ( nnp,nnn,nnnp,nnnn,xmcdfilename)
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

firsttotal = 0;
firstpositive = 0;
firstnegative = 0;
secondtotal = 0;
secondpositive = 0;
secondnegative = 0;
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
                    for k = 1:size(XMCDinformation,2)
                        if(abs(nnp-nnn)==abs(nnxmcd(k)) && abs(nnnp-nnnn)==abs(nnnxmcd(k)) && sign((nnp-nnn)*(nnnp-nnnn))==sign(nnxmcd(k)*nnnxmcd(k)))
                            if(mod(k,2)==1)
                                %first
                                firsttotal = firsttotal+1;
                                if(nnp~=nnn)
                                    if(sign(nnxmcd(k))==sign(XMCDinformation(k)))
                                        firstpositive = firstpositive + 1;
                                    elseif(sign(nnxmcd(k))==-sign(XMCDinformation(k)))
                                        firstnegative = firstnegative + 1;
                                    end
                                elseif(nnnp~=nnnn)
                                    if(sign(nnnxmcd(k))==sign(XMCDinformation(k)))
                                        firstpositive = firstpositive + 1;
                                    elseif(sign(nnnxmcd(k))==-sign(XMCDinformation(k)))
                                        firstnegative = firstnegative + 1;
                                    end
                                else
                                    if(sign(XMCDinformation(k))>0)
                                        firstpositive = firstpositive + 1;
                                    elseif(sign(XMCDinformation(k))<0)
                                        firstnegative = firstnegative + 1;
                                    end
                                end
                            else
                                %second
                                secondtotal = secondtotal+1;
                                if(nnp~=nnn)
                                    if(sign(nnxmcd(k))==sign(XMCDinformation(k)))
                                        secondpositive = secondpositive + 1;
                                    elseif(sign(nnxmcd(k))==-sign(XMCDinformation(k)))
                                        secondnegative = secondnegative + 1;
                                    end
                                elseif(nnnp~=nnnn)
                                    if(sign(nnnxmcd(k))==sign(XMCDinformation(k)))
                                        secondpositive = secondpositive + 1;
                                    elseif(sign(nnnxmcd(k))==-sign(XMCDinformation(k)))
                                        secondnegative = secondnegative + 1;
                                    end
                                else
                                    if(sign(XMCDinformation(k))>0)
                                        secondpositive = secondpositive + 1;
                                    elseif(sign(XMCDinformation(k))<0)
                                        secondnegative = secondnegative + 1;
                                    end
                                end
                            end
                        end
                    end
                end
            end

    end
end

end

