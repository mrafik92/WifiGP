clc
clear
Digital_signal = [1 0 1 0 1 0 0 1];
bpsk_signal=zeros(1,length(Digital_signal));
Real_part=zeros(1,length(bpsk_signal));
Imag_part=zeros(1,length(bpsk_signal));
for i=1:length(Digital_signal)
  bpsk_signal(i)=(Digital_signal(i)*2)-1;
    
Real_part(i)=real(bpsk_signal(i));    
Imag_part(i)=imag(bpsk_signal(i));    
end
stem(Real_part,Imag_part)