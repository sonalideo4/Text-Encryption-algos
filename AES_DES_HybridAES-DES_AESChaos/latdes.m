function encryptdec=latdes(msg,K,seed)

%K=key;
%MB=[];  
%olength=length(M);
%for i=1:olength 
 %   Mi=M(i); 
  %  MBi=['0000',dec2bin(hex2dec(Mi))]; 
   % MBi=MBi(end-3:end); 
   % MBi=[str2num(MBi(1)),str2num(MBi(2)),str2num(MBi(3)),str2num(MBi(4))]; 
   % MB=[MB,MBi]; 
%end 
%M=MB ;

temp1=[];
M=[];
b=0;
for i=1:length(msg)
  %  temp1=dec2bin(msg(i),8);
    b=unicode2native(msg(i));
    temp1=dec2bin(b,8);
    M=horzcat(M,temp1);
    b=0;
end
sd=[0];
if mod(length(M),64)>0
    addz=mod(length(M),64);
   % M=[M,zeros(1,64-addz)];
   for i=1:64-addz
   M=horzcat(M,sd(1));
   end
end
 M;

keybin64=[];
for i=1:length(K)
    keybin64=horzcat(keybin64,dec2bin(K(i),8));
end
zadd=mod(length(keybin64),64);
zadd=64-zadd;
keybin64=[keybin64,zeros(1,zadd)];
keybin64;
[keyenc keydec]=deskeys(keybin64,seed);

E=[32, 1, 2, 3, 4, 5;      
    4, 5, 6, 7, 8, 9; 
    8, 9,10,11,12,13; 
   12,13,14,15,16,17; 
   16,17,18,19,20,21; 
   20,21,22,23,24,25; 
   24,25,26,27,28,29; 
   28,29,30,31,32,1]; 
S1=[14, 4, 13, 1, 2, 15, 11, 8, 3, 10, 6, 12, 5, 9, 0, 7;  
    0, 15, 7, 4, 14, 2, 13, 1, 10, 6, 12, 11, 9, 5, 3, 8; 
    4, 1, 14, 8, 13, 6, 2, 11, 15, 12, 9, 7, 3, 10, 5, 0; 
    15, 12, 8, 2, 4, 9, 1, 7, 5, 11, 3, 14, 10, 0, 6, 13]; 
S2=[15, 1, 8, 14, 6, 11, 3, 4, 9, 7, 2, 13, 12, 0, 5, 10; 
    3, 13, 4, 7, 15, 2, 8, 14, 12, 0, 1, 10, 6, 9, 11, 5; 
    0, 14, 7, 11, 10, 4, 13, 1, 5, 8, 12, 6, 9, 3, 2, 15; 
    13, 8, 10, 1, 3, 15, 4, 2, 11, 6, 7, 12, 0, 5, 14, 9]; 
S3=[10, 0, 9, 14, 6, 3, 15, 5, 1, 13, 12, 7, 11, 4, 2, 8; 
    13, 7, 0, 9, 3, 4, 6, 10, 2, 8, 5, 14, 12, 11, 15, 1; 
    13, 6, 4, 9, 8, 15, 3, 0, 11, 1, 2, 12, 5, 10, 14, 7; 
    1, 10, 13, 0, 6, 9, 8, 7, 4, 15, 14, 3, 11, 5, 2, 12]; 
S4=[7, 13, 14, 3, 0, 6, 9, 10, 1, 2, 8, 5, 11, 12, 4, 15; 
    13, 8, 11, 5, 6, 15, 0, 3, 4, 7, 2, 12, 1, 10, 14, 9; 
    10, 6, 9, 0, 12, 11, 7, 13, 15, 1, 3, 14, 5, 2, 8, 4; 
    3, 15, 0, 6, 10, 1, 13, 8, 9, 4, 5, 11, 12, 7, 2, 14]; 
S5=[2, 12, 4, 1, 7, 10, 11, 6, 8, 5, 3, 15, 13, 0, 14, 9; 
    14, 11, 2, 12, 4, 7, 13, 1, 5, 0, 15, 10, 3, 9, 8, 6; 
    4, 2, 1, 11, 10, 13, 7, 8, 15, 9, 12, 5, 6, 3, 0, 14; 
    11, 8, 12, 7, 1, 14, 2, 13, 6, 15, 0, 9, 10, 4, 5, 3]; 
S6=[12, 1, 10, 15, 9, 2, 6, 8, 0, 13, 3, 4, 14, 7, 5, 11; 
    10, 15, 4, 2, 7, 12, 9, 5, 6, 1, 13, 14, 0, 11, 3, 8; 
    9, 14, 15, 5, 2, 8, 12, 3, 7, 0, 4, 10, 1, 13, 11, 6; 
    4, 3, 2, 12, 9, 5, 15, 10, 11, 14, 1, 7, 6, 0, 8, 13]; 
S7=[4, 11, 2, 14, 15, 0, 8, 13, 3, 12, 9, 7, 5, 10, 6, 1; 
    13, 0, 11, 7, 4, 9, 1, 10, 14, 3, 5, 12, 2, 15, 8, 6; 
    1, 4, 11, 13, 12, 3, 7, 14, 10, 15, 6, 8, 0, 5, 9, 2; 
    6, 11, 13, 8, 1, 4, 10, 7, 9, 5, 0, 15, 14, 2, 3, 12]; 
S8=[13, 2, 8, 4, 6, 15, 11, 1, 10, 9, 3, 14, 5, 0, 12, 7; 
    1, 15, 13, 8, 10, 3, 7, 4, 12, 5, 6, 11, 0, 14, 9, 2; 
    7, 11, 4, 1, 9, 12, 14, 2, 0, 6, 10, 13, 15, 3, 5, 8; 
    2, 1, 14, 7, 4, 10, 8, 13, 15, 12, 9, 0, 3, 5, 6, 11]; 

P=[16,7,20,21,29,12,28,17,1,15,23,26,5,18,31,10,2,8,24,14,32,27,3,9,19,13,30,6,22,11,4,25]; %straight d

PC1=[57,49,41,33,25,17,9,1,58,50,42,34,26,18,10,2,59,51,43,35,27,19,11,3,60,52,44,36,63,55,47,39,31,23,15,7,62,54,46,38,30,22,14,6,61,53,45,37,29,21,13,5,28,20,12,4]; %parity drop for keys..

PC2=[14,17,11,24,1,5,3,28,15,6,21,10,23,19,12,4,26,8,16,7,27,20,13,2,41,52,31,37,47,55,30,40,51,45,33,48,44,49,39,56,34,53,46,42,50,36,29,32]; %key comp 

Ki=zeros(16,48); %matrix 16*48
 

msgbin=[];
%===============key for decryption================


L=[];
R=[];
Mlength=length(M);
for j=1:64:(Mlength-63)
    L=M(j:j+31);  %msg split
    R=M(j+32:j+63);
    if(j==65)
            L;
            R;
    end
for i=1:16 
    E0=reshape(E',1,48);  %transpose of expansion matrix...
    R_E=R(E0);         %right 32 to 48    
    R_Ki=mod(R_E+keyenc(i,:),2); %xor(R_E,Ki(i,:))

    B=R_Ki(1:6); 
    x=B(1)*2+B(6)*1+1;     
    y=B(2)*8+B(3)*4+B(4)*2+B(5)*1+1; 
    C=['0000',dec2bin(S1(x,y))];   
    C=C(end-3:end); 
    C1=[str2num(C(1)),str2num(C(2)),str2num(C(3)),str2num(C(4))]; 
    
    B=R_Ki(7:12); 
    x=B(1)*2+B(6)*1+1; 
    y=B(2)*8+B(3)*4+B(4)*2+B(5)*1+1; 
    C=['0000',dec2bin(S2(x,y))]; 
    C=C(end-3:end); 
    C2=[str2num(C(1)),str2num(C(2)),str2num(C(3)),str2num(C(4))]; 
   
    B=R_Ki(13:18); 
    x=B(1)*2+B(6)*1+1; 
    y=B(2)*8+B(3)*4+B(4)*2+B(5)*1+1; 
    C=['0000',dec2bin(S3(x,y))]; 
    C=C(end-3:end); 
    C3=[str2num(C(1)),str2num(C(2)),str2num(C(3)),str2num(C(4))]; 
     
    B=R_Ki(19:24); 
    x=B(1)*2+B(6)*1+1; 
    y=B(2)*8+B(3)*4+B(4)*2+B(5)*1+1; 
    C=['0000',dec2bin(S4(x,y))]; 
    C=C(end-3:end); 
    C4=[str2num(C(1)),str2num(C(2)),str2num(C(3)),str2num(C(4))]; 
    
    B=R_Ki(25:30); 
    x=B(1)*2+B(6)*1+1; 
    y=B(2)*8+B(3)*4+B(4)*2+B(5)*1+1; 
    C=['0000',dec2bin(S5(x,y))]; 
    C=C(end-3:end); 
    C5=[str2num(C(1)),str2num(C(2)),str2num(C(3)),str2num(C(4))]; 
       
    B=R_Ki(31:36); 
    x=B(1)*2+B(6)*1+1; 
    y=B(2)*8+B(3)*4+B(4)*2+B(5)*1+1; 
    C=['0000',dec2bin(S6(x,y))]; 
    C=C(end-3:end); 
    C6=[str2num(C(1)),str2num(C(2)),str2num(C(3)),str2num(C(4))]; 
     
    B=R_Ki(37:42); 
    x=B(1)*2+B(6)*1+1; 
    y=B(2)*8+B(3)*4+B(4)*2+B(5)*1+1; 
    C=['0000',dec2bin(S7(x,y))]; 
    C=C(end-3:end); 
    C7=[str2num(C(1)),str2num(C(2)),str2num(C(3)),str2num(C(4))]; 
     
    B=R_Ki(43:48); 
    x=B(1)*2+B(6)*1+1; 
    y=B(2)*8+B(3)*4+B(4)*2+B(5)*1+1; 
    C=['0000',dec2bin(S8(x,y))]; 
    C=C(end-3:end); 
    C8=[str2num(C(1)),str2num(C(2)),str2num(C(3)),str2num(C(4))]; 
    C=[C1,C2,C3,C4,C5,C6,C7,C8]; 
    
    R_P=C(P); %straight d box
   
    TEMP=L; 
    L=R; 
    R=mod(TEMP+R_P,2); %xor.....
    end %end loop for 16 rounds
    TEMP=L; 
    L=R; 
    R=TEMP;
    C=[L,R];
   msgbin=horzcat(msgbin,C);
end %end loop for more than 64 bits...... 

msgbin;

outp='';
msgbin_str=num2str(msgbin);
t='';
length(msgbin_str)
for i=1:3:length(msgbin_str)%2 space after every msgbin_str character...13 is blank
    t=strcat(t,msgbin_str(i));
    if (length(t)==4)
        num_str8=bin2dec(t);
        outp=strcat(outp,dec2hex(num_str8));
        t='';
    end
end
encryptdec=outp;
end