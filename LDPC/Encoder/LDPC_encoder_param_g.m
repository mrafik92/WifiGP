function ldpcPara   = LDPC_encoder_param_g (A_MPDU_length, R, mstbc, NDBPS)


% Definitions
% MCS        : modulation coding Scheme
% R          : Code Rate
% NDBPS      : Number of Data Bits Per OFDM Symbol
% NCBPS      : Number of coded bits per OFDM symbol
% NBPSCS     : Number of Data Bits Per Symbol
% NBPSCS     : Number of coded bits per single carrier for each spatial stream (or modulation order)
% NSS        : Number of Spatial Streams
% Npld       : Number of payload bits
% NLDPC      : LDPC code word length
% Ncw        : Number of LDPC code words
% NTCB       : Total number of Coded bits
% Nspcw      : Number of Shortening bits per Code Word



%% Step one: Calculating the minimum number of OFDM Symbols

if (mstbc~=0)
    mstbc = 2; 
else
    mstbc = 1;
end;

Nsym = mstbc *  ceil((8 * A_MPDU_length +16 )/(mstbc * NDBPS)); %number of ofdm symbols
Npld = Nsym * NDBPS;        %number of payload bits
NCBPS = NDBPS / R;
NTCB = NCBPS * Nsym;

%% Step two : Code word size NLDPC & Number of code words Ncw


if NTCB <= 648
    Ncw = 1;
    if NTCB >= Npld + 912 * (1-R)
        NLDPC = 1296;
    else
        NLDPC = 648;
    end
elseif NTCB <= 1296 & NTCB > 648
    Ncw = 1;
    if NTCB >= Npld + 1464 * (1 - R)
        NLDPC = 1944;
    else
        NLDPC = 1296;
    end
elseif NTCB <= 1944 & NTCB > 1296
    Ncw = 1;
    NLDPC = 1944;
elseif  NTCB  <= 2592 & NTCB > 1944
    Ncw = 2;
    if NTCB >= Npld + 2916 * (1 - R)
        NLDPC = 1944;
    else
        NLDPC = 1296;
    end
else
    NLDPC = 1944;
    Ncw = ceil(Npld/(1944*R));
end



%% Step Three : Shortening zero bits

Nshrt = max([0, Ncw * NLDPC * R - Npld]);

if Nshrt
    Nspcw = floor(Nshrt/Ncw);
    shrt_array = zeros(1,Ncw);
    shrt_array(1:mod(Nshrt,Ncw)) = Nspcw +1;
    shrt_array(mod(Nshrt,Ncw)+1 : end) = Nspcw;
end

vCWlength = NLDPC - shrt_array;


%% Step five: Packing into OFDM Symbols

Npunc = max( 0, (Ncw * NLDPC) - NTCB - Nshrt);

temA = 0.1 * Ncw * NLDPC * (1-R);
temB = 1.2 * Npunc * (R /(1-R));
temC = 0.3 * Ncw * NLDPC *(1-R);


if( ( (Npunc > temA) && (Nshrt < temB)) || (Npunc > temC))
    NTCB = NTCB + NCBPS * mstbc;    %%One More OFDM symbol
    Nsym = NTCB/NCBPS;              
    tem = (Ncw * NLDPC) - NTCB - Nshrt;
    Npunc = max( 0, tem);
end

Nppcw = floor( Npunc/ Ncw);   

punc_array = zeros(1, Ncw);

if (Npunc > 0)
    Npp1 = rem(Npunc, Ncw);  % discard parity bits: (n-k-Nppcw-1 : n-k-1)
    punc_array(1: Npp1) = Nppcw + 1;
    punc_array(Npp1+1 : Ncw) = Nppcw; % discard parity bits: (n-k-Nppcw : n-k-1)
    vCWlength = vCWlength - punc_array;
end

%Repetition

tem = NTCB - (Ncw * NLDPC * (1-R)) - Npld;
Nrep = max(0, round(tem));
vNrepInt = zeros(1, Ncw);
vNrepRem = zeros(1, Ncw);

if( Npunc == 0 && Nrep > 0)
    repBit = floor( Nrep / Ncw);           % repeat bits for each codeword
    Np1 = rem( Nrep, Ncw);              % one more bits should be repeated
    
    vRep = ones(1, Ncw) * repBit;
    vRep(1:Np1) = repBit + 1;     % 1-by-Ncw, repeat bits for each codeword
    
    vNrepInt = floor( vRep ./ vCWlength);
    vNrepRem = vRep - vNrepInt .* vCWlength;
    
    vCWlength = vCWlength + vRep;
end

switch( NLDPC)
    case 648,   FileIdx.idxCwLen = 1;
    case 1296,  FileIdx.idxCwLen = 2;
    case 1944,  FileIdx.idxCwLen = 3;
    otherwise,  error('unknown codeword length');
end

% rate: 1/2, 2/3, 3/4, 5/6
rateScale = R * 12;
switch( rateScale)
    case 6,     FileIdx.idxRate = 1;
    case 8,     FileIdx.idxRate = 2;
    case 9,     FileIdx.idxRate = 3;
    case 10,    FileIdx.idxRate = 4;
end

ldpcPara.FileIdx=FileIdx; % parity file index

ldpcPara.NLDPC = NLDPC;        ldpcPara.Ncw = Ncw;
ldpcPara.Nsym = Nsym;          ldpcPara.Ncbps = NCBPS;
ldpcPara.NTCB = NTCB;    
ldpcPara.rate = R;

ldpcPara.Nshrt = Nshrt;        ldpcPara.Npunc = Npunc;
ldpcPara.Nrep = Nrep;

% the following vectors are 1-by-Ncw
ldpcPara.vNshrt = shrt_array;  % Nspcw for each codeword:
ldpcPara.vNpunc = punc_array;     % Nppcw for each codeword
ldpcPara.vNrepInt = vNrepInt; % repeat number of the whole codeword
ldpcPara.vNrepRem = vNrepRem; % repeat number of bits in a codeword

ldpcPara.vCWlength = vCWlength;   % codeword length after discard shorten bits, punc or repeat


end