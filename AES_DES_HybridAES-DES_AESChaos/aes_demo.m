function [encrypt,decrypt]=aes_demo(msg,key,key1)
%AES_CHAOS  Demonstration of AES-components.
%key1 is second key...
%   AES_CHAOS
%   runs a demonstration of all components of 
%   the Advanced Encryption Standard (AES) toolbox.
%
%   In the initialization step the S-boxes, the round constants,
%   and the polynomial matrices are created and
%   an example cipher key is expanded into 
%   the round key schedule.
%   Step two and three finally convert 
%   an example plaintext to ciphertext and back to plaintext.


%plaintext_hexs ='x2';
%plain=dec2hex(plaintext_hexs)
%plain=hex2dec(plain)
%length(plain)
%plain(3)=0
%length(plain)
%plain(3)

tic
global keydec
%key1='sdgdfg';
b=0;
%keystr='asdf';
key1bin=[];
for i=1:length(key1)
  %  temp1=dec2bin(msg(i),8);
    b=unicode2native(key1(i));
    temp1=dec2bin(b,8);
    key1bin=horzcat(key1bin,temp1);
    b=0;
end
key1zero=[];
zeroadd=mod(length(key1bin),128);
if length(key1)<16
    keyzero=zeros(1,128-zeroadd);
    key1bin=[key1bin,keyzero];
end

%key1bin=str2num(key1bin);



%msg='hellomonildgdfhgfdhdfdfg';
%key='dfgdfg';
% Initialization
[s_box, inv_s_box, w, poly_mat, inv_poly_mat] = aes_init(key);

% Define an arbitrary series of 16 plaintext bytes 
% in hexadecimal (string) representation
% The following two specific plaintexts are used as examples 
% in the AES-Specification (draft)
%plaintext_hex = {'00' '11' '22' '33' '44' '55' '66' '77' ...
 %                '88' '99' 'aa' 'bb' 'cc' 'dd' 'ee' 'ff'};
% disp('plaintext')
%msg='efghiegfdgdf45yug'



%plaintext_hex = {'32' '43' 'f6' 'a8' '88' '5a' '30' '8d' ...
%                '31' '31' '98' 'a2' 'e0' '37' '07' '34'};

% Convert plaintext from hexadecimal (string) to decimal representation
plaintext = msg;
plaintext_len=length(plaintext);
   if(mod(length(plaintext),32)~=0)
        for i=1:32-mod(length(plaintext),32)
            plaintext(plaintext_len+i)=0;
        end
   end
 plaintext   
arr_size=length(plaintext)/32;
start=1;
stop=32;
plaintextarray=[];
for i=1:arr_size
    plaintextarray(i,1:32)=plaintext(start:stop);%32*n array
     start=stop+1;
     stop=stop+32;
end
leftp=zeros(1,128);
rightp=zeros(1,128);
aes128=zeros(1,128);
cipherbin=[];
cipher256=[];
cipherdecl16=[];
cipherdecr16=[];
right128=[];
left128=[];
ciphertext1=[];
strng=zeros(1,8);strng1=zeros(1,8);
x='';y='';start=1;stop=8;
cipherfinal='';
for i=1:arr_size
      for t=1:16
x=dec2bin(plaintextarray(i,t),8);
y=dec2bin(plaintextarray(i,t+16),8);
        for z=1:8
        leftp(start)=str2num(x(z));
        rightp(start)=str2num(y(z));
        start=start+1;
        end
     end

     for l=1:128 
right128(l)=mod(key1bin(l)+rightp(l),2);
left128(l)=mod(right128(l)+leftp(l),2);
     end

    start1=1;stop1=8;count=1
    for q=1:8:128
       aesstr=num2str(left128(start1:stop1));
       start1=stop1+1;
       stop1=stop1+8;
       aesdec(count)=bin2dec(aesstr);
       count=count+1;
    end
    count=1;
ciphertext1 = cipher(aesdec, w, s_box, poly_mat,1);

    for h=1:16
        cipherbin=horzcat(cipherbin,dec2bin(ciphertext1(h),8));
    end   
    
  
 
   cipherbin=num2str(cipherbin);%cipherbin==right128 and right128=left128 of enc
    start=1;stop=8;index=1
    for u=1:16
        for s=1:8
         strng(s)=horzcat(right128(index));
         strng1(s)=horzcat(cipherbin(index));
         index=index+1;
         if strng1(s)==48
             strng1(s)=0;
         else
             strng1(s)=1;
         end
        end
%         strng
%         strng1
         cipherdecl16(u)=bin2dec(num2str(strng));
         cipherdecr16(u)=bin2dec(num2str(strng1));%cipher becoming right part of 256 enc data...
         strng=zeros(1,8);strng1=zeros(1,8);
    end
    start=1;stop=8;
    cipher256(i,:)=horzcat(cipherdecl16,cipherdecr16);
    for o=1:32
    cipherfinal=horzcat(cipherfinal,native2unicode(cipher256(o)));%cipher256===perfect right 16 dec==output from aesenc and...
    end                                                             %left 16 permutation of exor..
end
encrypt=cipher256;
%=================decryption===========================
uncipherbin=[];
start=1;
leftp=[];rightp=[];
for i=1:arr_size
 
    unciphertext=inv_cipher (cipher256(i,17:32), w, inv_s_box, inv_poly_mat, 1);%uncipher=left128 of enc part refer line113
    index=1;%coz left 128 goes into right 128 of enc..
    unciphertext;
    for t=1:16
    x=dec2bin(cipher256(i,t),8);%right128 of enc...(left of enc becomes right of org)
    y=dec2bin(unciphertext(t),8);%left128 of enc
        for z=1:8
        leftp(start)=str2num(y(z));%leftp=right128 of enc..refer line 112
        rightp(start)=str2num(x(z));%consider these left and right same as org but without xor
        start=start+1;
        end
    end   
     
 start=1;
    for l=1:128
        
        leftp(l)=mod(rightp(l)+leftp(l),2); %order vv imp 
        rightp(l)=mod(rightp(l)+key1bin(l),2);
    end
    
     plain(i,:)=[leftp rightp];
end
% leftp
% rightp
% plain
start1=1;stop1=8;
ptext='';
index=1;
for i=1:arr_size
    for j=1:32
   str=num2str(plain(i,start1:stop1));  
   ptext=horzcat(ptext,native2unicode(bin2dec(str)));
   start1=stop1+1;
   stop1=stop1+8;
    end
    start1=1;stop1=8;str='';
end
%disp('final output')
decrypt=ptext;

t=toc
end