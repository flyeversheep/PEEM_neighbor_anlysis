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
            if(~isempty(xmcd(xmcd(:,1)==i & xmcd(:,2)==j-1 , :)))
                countnn = countnn+1;
                nnxmcd1 = xmcd(xmcd(:,1)==i & xmcd(:,2)==j-1 , 3:end);
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

                for k = 1:size(XMCDinformation,2)-1
                    if(abs(nnp-nnn)==abs(nnxmcd(k)) && abs(nnnp-nnnn)==abs(nnnxmcd(k)) && sign((nnp-nnn)*(nnnp-nnnn))==sign(nnxmcd(k)*nnnxmcd(k)))
                        if(mod(k,2)==1)
                            %LL
                            LLRRtotal=LLRRtotal+1;
                                ij = sprintf('%d %d',i,j)
                                
                            if(XMCDinformation(k)~=XMCDinformation(k+1))
                                LLRRchanged = LLRRchanged+1;
                                display('in');
%                                 ij = sprintf('%d %d',i,j);
%                                 display(ij);
                            end
                        else
                            %LR
                            LRtotal=LRtotal+1;
                            if(XMCDinformation(k)~=XMCDinformation(k+1))
                                LRchanged = LRchanged+1;
%                                 ij = sprintf('%d %d',i,j);
%                                 display(ij);
                            end
                        end
                    end
                end
            end

    end
end

end

