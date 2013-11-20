function encoded_data = LDPC_encoder( data , A_MPDU_length , mstbc , MCS_index , BW , NSS)


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

%%
MCS  = struct(...
    'Modulation', {'BPSK','QPSK','QPSK','16-QAM','16-QAM','64-QAM','64-QAM','64-QAM','256-QAM','256-QAM'},...
    'Code_rate' , {0.5 , 0.5, 0.75, 0.5, 0.75, 2/3 ,3/4 , 5/6, 3/4, 5/6}, ...
    'NBPSCS' , {1 , 2 , 2 , 4 ,4, 6, 6, 6, 8, 8});

R = MCS(MCS_index).Code_rate;
Ncarriers = [52 , 108, 234 , 468];
NDBPS = Ncarriers(BW) * R  * MCS(MCS_index).NBPSCS * NSS ; % number of data bits per OFDM symbol

%% Step one: Calculating the minimum number of OFDM Symbols

Nsym = mstbc *  ceil((8 * A_MPDU_length +16 + NTail)/(mstbc * NDBPS)); %number of ofdm symbols
Npld = Nsym * NDBPS;        %number of payload bits

%% Step two : Code word size NLDPC & Number of code words Ncw

NCBPS = NDBPS / R;
NTCB = NCBPS * Nsym;


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

% Choosing The H matrix
if NLDPC == 1296
    p = 54;
    if R == 0.5
        H = H_1296_05;
    elseif R == 2/3
        H = H_1296_067;
    elseif R == 3/4
        H = H_1296_075;
    elseif R == 5/6
        H = H_1296_083;
    end
elseif NLDPC == 1944
    p = 81;
    if R == 0.5
        H = H_1944_05;
    elseif R == 2/3
        H = H_1944_067;
    elseif R == 3/4
        H = H_1944_075;
    elseif R == 5/6
        H = H_1944_086;
    end
elseif NLDPC == 648
    p = 27;
    if R == 0.5
        H = H_648_05;
    elseif R == 2/3
        H = H_648_067;
    elseif R == 3/4
        H = H_648_075;
    elseif R == 5/6
        H = H_648_083;
    end
end

H_mat = convert_H(H,p);



%% Step Three : Shortening zero bits

Nshrt = max([0, Ncw * NLDPC * R - Npld]);
if Nshrt
    Nspcw = floor(Nshrt/Ncw);
    shrt_array = zeros(1,Ncw);
    shrt_array(1:mod(Nshrt,Ncw)) = Nspcw +1;
    shrt_array(mod(Nshrt,Ncw)+1 : end) = Nspcw;
end

encoded = zeros(Ncw,NLDPC);
for i =1:Ncw
    temp = [data((i-1)*NLDPC*R + 1:i*NLDPC*R) zeros(1,shrt_array(i))];
    encoded(i,1:length(temp)) = temp;
end

%% Step four: Parity Check bits

Hi = H_mat(:,1:NLDPC*R);

Hp = H_mat(:,((NLDPC*R)+1):end);

temp = 4;





