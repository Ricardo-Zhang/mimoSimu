clc;
clear;

CrcBits = 24;
REsPerPRB = 138 ; % 12 Subframes * 7 ofdm symbols
Tn=6;            %control the block length: 1,...,110
CodeRate = zeros(28,2);
for MCS = 0:28
    LTEParams=GetLTEParameters;     %get LTE parameters;
    MCS_params=LTEParams.MCS_params(MCS+1); %MCS parameter according to the selected MCS.
    BitsPerSymbol = MCS_params.modulation_order;
    NumInfoBits=LTEParams.MCS_table(MCS_params.TBS+1,Tn); %no. of information bits according to Tn and MCS.
    CodeRate(MCS+1,1) = MCS;
    CodeRate(MCS+1,2) = (NumInfoBits) / (Tn * REsPerPRB * BitsPerSymbol);
end

