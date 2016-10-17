clc;
clear;
%execute make.m first to compile c files.

%--------------------------
SNRdB= -10:1:20;      %SNR range, in dB; the definition of SNR is symbol power divided by noise power
Ntrials=50;     %no. of channel realizations
CQIMax=15;          %modulation and coding scheme: 0,...,28. Higher value means higher code rate.
Tn=6;            %control the block length: 1,...,110
%Bandwidth = 1.4e6; %Channel Bandwidth 1.4MHz
Tframe = 10; % fixed frame duration: 10ms
Tcp = 4.7e-3; % Normal cp time 4.7us

%------
Nsc = 12; % number of subcarrier
Ns = 14; % number of OFDM symbols, 14 when applying normal Cyclic Prefix
Tp=151;     %some parameter in LTE. do not change.
T=Tp*Tn;    %block length, i.e., number of symbols in a code block
FailCount = zeros(length(SNRdB),1);
BLER_coded = zeros(length(SNRdB),1);
ThroughPut = zeros(length(SNRdB),1);
%--------------------------
wb= waitbar(0);
t1=clock;
%--------------------------
MCSSet = [0 1 2 4 7 9 12 14 16 19 21 23 25 27 28];
SNR=10.^(SNRdB/10);         %SNR in linear scale

for nSNR = 1:length(SNR)
  SINR = SNR(nSNR); %* (abs(h))^2;
  SINRdB = log(SINR*10);
  CQI = SNR_CQI_Mapping(SINRdB);
  MCS = MCSSet(CQI);

  LTEParams=GetLTEParameters;     %get LTE parameters;

  MCS_params=LTEParams.MCS_params(MCS+1); %MCS parameter according to the selected MCS.

  NumInfoBits=LTEParams.MCS_table(MCS_params.TBS+1,Tn); %no. of information bits according to Tn and MCS.

  NumCodedBits=T*MCS_params.modulation_order;

  for ntrials=1:Ntrials
      h=sqrt(1/2)*(randn + 1i*randn);        %set the channel as 1

      waitbar((Ntrials*(nSNR-1)+ntrials)/(Ntrials*length(SNR)),wb);

      DataBits=logical(randi(2,1,NumInfoBits)-1);     %data bits; logical

      [CodedBits,Signaling]=ChannelCoding(DataBits,NumCodedBits,MCS_params,LTEParams);    %channel coding; consider this as a black box.

      symbol_index=bin2dec(char(reshape(CodedBits,MCS_params.modulation_order,T)+48)');   %symbo index

      s=LTEParams.SymbolAlphabet{MCS_params.modulation_order}(symbol_index+1);            %symbols

      v=(randn(T,1)+1i*randn(T,1))/sqrt(2);   %noise
      y=h*s+1/sqrt(SNR(nSNR))*v;    % receive signal

      LLR=LLR_SISO(y,h, 1/SNR(nSNR),MCS_params,LTEParams,'soft-decision');          %compute bit LLR

      [DecodedBits]=ChannelDecoding(LLR,Signaling,LTEParams);   %channel decoding; consider this as a black box.
      BitError = logical(sum(abs(DataBits-DecodedBits)>0.5));
      FailCount(nSNR) = FailCount(nSNR) + BitError;
  end;
  BLER_coded(nSNR) = FailCount(nSNR)/Ntrials;
  ThroughPut(nSNR) = (1 - BLER_coded(nSNR)) * NumInfoBits * 1000 / 1e6;
  
end;
%----------------------------------
etime(clock,t1);

%----------------
close(wb);

Capacity = zeros(1, length(SNR));
Bandwidth = Nsc * Ns * Tn/1e-3;
F = (Tframe - Tcp)/(Tframe) * (Ns * Nsc/2 - 4)/(Nsc * Ns/2);
for nSNR=1:length(SNR)
    Capacity(nSNR) = F * Bandwidth * log2(1 + SNR(nSNR))/1e6;
end

figure(1);
plot(SNRdB, ThroughPut, SNRdB, Capacity, '-xb');
xlabel('SNR(dB)');ylabel('Through Put [Mbit/s]');
grid
