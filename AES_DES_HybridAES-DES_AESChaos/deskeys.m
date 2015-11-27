function [Ki,key48d] =deskeys(key64,seed)%input in bits..
PC1=[57,49,41,33,25,17,9,1,58,50,42,34,26,18,10,2,59,51,43,35,27,19,11,3,60,52,44,36,63,55,47,39,31,23,15,7,62,54,46,38,30,22,14,6,61,53,45,37,29,21,13,5,28,20,12,4]; %parity drop for keys..
PC2=[14,17,11,24,1,5,3,28,15,6,21,10,23,19,12,4,26,8,16,7,27,20,13,2,41,52,31,37,47,55,30,40,51,45,33,48,44,49,39,56,34,53,46,42,50,36,29,32]; %key comp 
Ki=zeros(16,48); %matrix 16*48
 
K_PC1=key64(PC1);  %parity drop key 64 to 56                
C0=K_PC1(1:28); %split left 28
D0=K_PC1(29:56); %split right 48

for i=1:16 
    if i==1||i==2||i==9||i==16       
        C0=[C0(2:end),C0(1)]; 
        D0=[D0(2:end),D0(1)]; 
    else                             
        C0=[C0(3:end),C0(1:2)]; 
        D0=[D0(3:end),D0(1:2)]; 
    end 
    K_LS=[C0,D0]; 
 
    Ki(i,:)=K_LS(PC2); 
end
    %==========decryption keys==========
    
%=========irrational permutation==============
if seed~=0
Ki=irrational(seed,Ki);
disp('called')
end
keytemp48=[];
for i=16:-1:1
        keytemp48=Ki(i,1:48);
        key48d((17-i),1:48)=[keytemp48];
end 

for i=1:16
    for j=1:48
        if Ki(i,j)==48
            Ki(i,j)=0;
        else
            Ki(i,j)=1;
        end
        if key48d(i,j)==48
            key48d(i,j)=0;
        else
            key48d(i,j)=1;
        end
    end
end

end