function [encrypt,decrypt]=aes_demo(msg,key)
%AES_DEMO  Demonstration of HYBRID AES- DES components.
%
%   AES_DEMO
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
msg_hex=dec2hex(msg);


%plaintext_hex = {'32' '43' 'f6' 'a8' '88' '5a' '30' '8d' ...
%                '31' '31' '98' 'a2' 'e0' '37' '07' '34'};
seed=0;
% Convert plaintext from hexadecimal (string) to decimal representation
plaintext = hex2dec(msg_hex);
plaintext_len=length(plaintext);
   if(mod(length(plaintext),16)~=0)
        for i=1:16-mod(length(plaintext),16)
            plaintext(plaintext_len+i)=0;
        end
   end
    
arr_size=length(plaintext)/16;
start=1;
stop=16;
plaintextarray=[];
for i=1:arr_size
    plaintextarray(i,1:16)=plaintext(start:stop);%16*n array
     start=stop+1;
     stop=stop+16;
end
disp('before des 64+64')
plaintext'
plaintextarray;
 desbin=[];
 temp=[];
 temp1=[];
 keydes=[];
 desdec=[];
 desddec=[];
 count=1;
 start=1;stop=8;
 for i=1:8
    keydes=horzcat(keydes,dec2bin(keydec(i),8));
 end
%disp('===========key 4 des==========================')
%keydes
[key48 key48d]=deskeys(keydes,seed);
re_plaintextarray=[];
ciphertextarray=[];
for i=1:arr_size
% This is the real McCoy.
% Convert the plaintext to ciphertext,
% using the expanded key, the S-box, and the polynomial transformation matrix

   start1=1;stop1=8;
   des128=dec2bin(plaintextarray(i,:),8);
   des128=reshape(des128',1,128);%vvvv imp;
    temp=des(des128(1:64),key48);
    temp1=des(des128(65:128),key48);
    desbin=[temp,temp1];

    for j=1:8:128
       desstr=num2str(desbin(start1:stop1));%convert des output to decimal
       start1=stop1+1;
       stop1=stop1+8;
       desdec(count)=bin2dec(desstr);
       count=count+1;
    end
    count=1;
  % disp('des 64+64 output')
  % desdec
ciphertext = cipher (desdec, w, s_box, poly_mat, 1);
%disp('aes 128 output encrypt')
ciphertext;
ciphertextarray(i,:)=ciphertext(1,:);
%ciphertextarray(i,:)=reshape(ciphertext,1,16);
% Convert the ciphertext back to plaintext
% using the expanded key, the inverse S-box, 
% and the inverse polynomial transformation matrix
re_plaintext = inv_cipher (ciphertext, w, inv_s_box, inv_poly_mat, 1);
re_plaintextarray(i,1:16)=re_plaintext(1,16);%todo with size...
%disp('aes decrypt 128')
re_plaintext;
desd128=dec2bin(re_plaintext(1,:),8);
desd128=reshape(desd128',1,128);%vvvv imp;
%desd128(65:128)
desbin;
temp=des(desd128(1:64),key48d);
 temp1=des(desd128(65:128),key48d);
 desdbin=[temp,temp1];
 start1=1;stop1=8;
 for k=1:8:128
       desstr=num2str(desdbin(start1:stop1));
       start1=stop1+1;
       stop1=stop1+8;
       desddec=horzcat(desddec,bin2dec(desstr));
 end

end
disp('encrypt complete')
ciphertextarray
disp('des 64+64 decrypt')
desddec
encrypt=ciphertextarray;
decrypt=desddec;
t=toc
end