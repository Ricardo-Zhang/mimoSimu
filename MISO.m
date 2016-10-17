clear;
clc;
%execute make.m first to compile c files.

AttenTx = 2;
UserNum = 2;

%--------------------------
dBNoiPwr= -20:0.5:10;      %SNR range, in dB; the definition of SNR is symbol power divided by noise power
Ntrials=1e2;     %no. of channel realizations
Tn=6;            %control the block length: 1,...,110
Tframe = 10; % fixed frame duration: 10ms
Tcp = 4.7e-3; % Normal cp time 4.7us

%------
Nsc = 12; % number of subcarrier
Ns = 14; % number of OFDM symbols, 14 when applying normal Cyclic Prefix
Tp=151;     %some parameter in LTE. do not change.
T=Tp*Tn;    %block length, i.e., number of symbols in a code block
ThroughPut = zeros(length(dBNoiPwr),UserNum);
%% 
BLER = zeros(length(dBNoiPwr),UserNum);
R = zeros(length(dBNoiPwr),UserNum);

%---------------
NoiPwr=10.^(dBNoiPwr/10);         %SNR in linear scale

%Wait Bar Init--------------------------
wb= waitbar(0);
t1=clock;

for nNoise = 1:length(NoiPwr)
    for ntrial = 1:Ntrials
        waitbar(((ntrial/Ntrials+nNoise-1)/length(NoiPwr)),wb);
        H = sqrt(1/2)*(randn(AttenTx, UserNum) + 1i*randn(AttenTx, UserNum)); % channel model, noiseless
        W = pinv(H');
        W = W/norm(W,'fro');
        SINR = 

    end
end
close(wb);

        