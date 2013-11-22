
function [pktEncOut] = LDPC_ENCODER_APPLY(bitIn, ldpcPara)

Lldpc = ldpcPara.NLDPC;		Ncw = ldpcPara.Ncw;
Npunc = ldpcPara.Npunc;
vNshrt = ldpcPara.vNshrt;   % 1-by-Ncw, shorten bits for each codeword
vNpunc = ldpcPara.vNpunc;   % 1-by-Ncw, punctured bits for each codeword
vNrepInt = ldpcPara.vNrepInt;	% 1-by-Ncw, repeat the whole codeword
vNrepRem = ldpcPara.vNrepRem;  % 1-by-Ncw, repeat the number of bits
ldpcFileIdx = ldpcPara.FileIdx; % parity file index

K0 = Lldpc * ldpcPara.rate;
Nsym = ldpcPara.Nsym;

% parity check matrix: 802.11n_ldpc_pcm_Prate_Flen.mat
szParityCkFile = sprintf('parity_ck/802_11n_ldpc_pcm_P%1d_%1d.mat', ...
                         ldpcFileIdx.idxRate, ldpcFileIdx.idxCwLen);
load(szParityCkFile);  % parity check matrix: P
G_parity  = P;         % (N-K0)-by-K0, now A*G = 0 (mod 2)

qIn = 0;  % position of the input bits
qOut = 0;  % position of the output bits


    cwBg = 1;   cwEnd = Ncw;

pktEncOut = zeros( Nsym * ldpcPara.Ncbps, 1);

for k = cwBg: cwEnd
    
    % insert shorten bits
    Ninfo = K0 - vNshrt(k); % number of pay-load bits in systematic part
    xInfo = bitIn( qIn + (1:Ninfo));
    temShort = zeros( vNshrt(k), 1);
    xIn = [xInfo(:); temShort(:)];
    xInParity = mod( G_parity * xIn, 2);  % ldpc encode
    
    if( Npunc > 0)			% puncture
        xOutPunc = xInParity( 1: end-vNpunc(k));
        xOut = [xInfo(:); xOutPunc(:)];
        
    else		% repeat
        % discard shortened bits
        xOutShort = [xInfo(:); xInParity(:)];
        
        if( vNrepInt(k))  % number to repeat the whole codeword
            xOutRepInt = kron(ones(vNrepInt(k), 1), xOutShort(:));
        else
            xOutRepInt = [];
        end
        xOutRepRem = xOutShort( 1: vNrepRem(k));
        xOut = [xOutShort; xOutRepInt; xOutRepRem];
    end
    
    pktEncOut(qOut + (1: length(xOut)) ) = xOut;
    
    qIn = qIn + Ninfo;
    qOut = qOut + length( xOut);
end
if( (qOut ~= ldpcPara.Ncbps * Nsym || qOut ~= ldpcPara.NTCB) && (nargin ~= 3))
    error( 'LDPC PPDU encoder output length is not equal to Ncbps*Nsym -- applyLdpcEnc.m');
end

return;
