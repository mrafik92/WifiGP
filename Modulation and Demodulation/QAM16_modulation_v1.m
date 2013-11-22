clc
clear
Digital_signal = [0 0 0 1];
qam16_signal=zeros(1,length(Digital_signal)/4);
Real_part=zeros(1,length(qam16_signal));
Imag_part=zeros(1,length(qam16_signal));
m=1;
for l=1:4:length(Digital_signal)
  qam16_signal(m)=(((2*Digital_signal(l))-1)*((-2*Digital_signal(l+1))+3))+(((2*Digital_signal(l+2))-1)*((-2*Digital_signal(l+3))+3))*i;
  Real_part(m)=real(qam16_signal(m));    
  Imag_part(m)=imag(qam16_signal(m)); 
  m=m+1;
end
 stem(Real_part,Imag_part)