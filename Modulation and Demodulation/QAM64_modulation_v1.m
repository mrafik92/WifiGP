clc
clear
Digital_signal = [1 1 1 0 0 0];
qam64_signal=zeros(1,length(Digital_signal)/6);
Real_part=zeros(1,length(qam64_signal));
Imag_part=zeros(1,length(qam64_signal));
bitmap=[-7 -5 -1 -3 7 5 1 3];
m=1;
 for l=1:6:length(Digital_signal)
  x=Digital_signal(l)*(2^2)+Digital_signal(l+1)*(2)+Digital_signal(l+2);
  y=Digital_signal(l+3)*(2^2)+Digital_signal(l+4)*(2)+Digital_signal(l+5);
  qam64_signal(m)=bitmap(x+1)+(bitmap(y+1)*i);
  Real_part(m)=real(qam64_signal(m));    
  Imag_part(m)=imag(qam64_signal(m)); 
  m=m+1;
 end
stem(Real_part,Imag_part)