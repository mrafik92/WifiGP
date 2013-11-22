function[soft_bit_demod_signal]=QAM16_demodulation_v1(recieved_signal)

m=1;
for l=1:length(recieved_signal)
yre=real(recieved_signal(l));
yim=imag(recieved_signal(l));
 if (yre< -2)
  soft_bit_demod_signal(m)=2*(yre+1);
 elseif ((yre>=-2)&&(yre<=2))
  soft_bit_demod_signal(m)=yre;
 elseif((yre)>2)
  soft_bit_demod_signal(m)=2*(yre-1);
 end
 
 if (yre<=0)
  soft_bit_demod_signal(m+1)=yre+2;
 else
  soft_bit_demod_signal(m+1)=2-yre;    
 end
  if ((yim)<-2)
  soft_bit_demod_signal(m+2)=2*(yim+1);
 elseif (yim>=-2&&yim<=2)
  soft_bit_demod_signal(m+2)=yim;
 elseif((yim)>2)
  soft_bit_demod_signal(m+2)=2*(yim-1);
 end
 
 if (yim<=0)
  soft_bit_demod_signal(m+3)=yim+2;
 else
  soft_bit_demod_signal(m+3)=2-yim;    
 end

 m=m+4;
end
