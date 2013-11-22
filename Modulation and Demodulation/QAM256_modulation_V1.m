clc
clear
Digital_signal = [0 1 1 0 0 0 0 1 1 1 1 0 0 0 1 0];
qam256_signal=zeros(1,length(Digital_signal)/8);
Real_part=zeros(1,length(qam256_signal));
Imag_part=zeros(1,length(qam256_signal));
bitmap=[-15 -13 -9 -11 -1 -3 -7 -5 15 13 9 11 1 3 7 5];
m=1;
for l=1:8:length(Digital_signal)
  x=Digital_signal(l)*(8)+Digital_signal(l+1)*(4)+Digital_signal(l+2)*(2)+Digital_signal(l+3);
  y=Digital_signal(l+4)*(8)+Digital_signal(l+5)*(4)+Digital_signal(l+6)*(2)+Digital_signal(l+7);
  qam256_signal(m)=bitmap(x+1)+(bitmap(y+1)*i);
  Real_part(m)=real(qam256_signal(m));    
  Imag_part(m)=imag(qam256_signal(m)); 
  m=m+1;
 end
stem(Real_part,Imag_part)