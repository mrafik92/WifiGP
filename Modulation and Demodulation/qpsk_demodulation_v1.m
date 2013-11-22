function[soft_bit_demod_signal]=qpsk_demodulation_v1(recieved_signal)
m=1;
for i=1:length(recieved_signal)
soft_bit_demod_signal[m]=real(recieved_signal(i));
soft_bit_demod_signal[m+1]=imag(recieved_signa(i));
m=m+2;
end
