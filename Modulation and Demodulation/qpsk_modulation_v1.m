clc
clear
Digital_signal = [0 1 1 1 1 0 0 0];
qpsk_signal=zeros(1,length(Digital_signal)/2);
Real_part=zeros(1,length(qpsk_signal));
Imag_part=zeros(1,length(qpsk_signal));
m=1;
for l=1:2:length(Digital_signal)
qpsk_signal(m)=((2*Digital_signal(l))-1)+((2*Digital_signal(l+1))-1)*i;
Real_part(m)=real(qpsk_signal(m));    
Imag_part(m)=imag(qpsk_signal(m)); 
m=m+1;
end
stem(Real_part,Imag_part)