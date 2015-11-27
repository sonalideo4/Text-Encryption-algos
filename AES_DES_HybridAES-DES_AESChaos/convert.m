function [ptext1] =convert(data128)

start1=1;stop1=8;
ptext1=[];
index=1;
    for j=1:16
   str=num2str(data128(start1:stop1));
   ptext1(index)=bin2dec(str);
   start1=stop1+1;
   stop1=stop1+8;
   index=index+1;
    end
end