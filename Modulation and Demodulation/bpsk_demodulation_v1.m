function[soft_bit_demod_signal]= bpsk_demodulation_v1(recieved_signal)
for i=1:length(recieved_signal)
soft_bit_demod_signal(i)=recieved_signal(i);
end
