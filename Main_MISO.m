clear;
clc;
%execute make.m first to compile c files.

AttenTx = 3;
UserNum = 3;

%--------------------------
dBNoiPwr= -20:1:10;      %SNR range, in dB; the definition of SNR is symbol power divided by noise power
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

for ntrials = 1:Ntrials    
    H = sqrt(1/2)*(randn(UserNum, AttenTx) + 1i*randn(UserNum, AttenTx)); % channel model, noiseless
    for nNoise = 1:length(dBNoiPwr)
        %Wait Bar Update-----------------
        waitbar((length(dBNoiPwr)*(ntrials-1)+nNoise)/(Ntrials*length(dBNoiPwr)),wb);
        
        LTEParams=GetLTEParameters;     %get LTE parameters;
        
        %Channel Init----------------------
        v =(randn(T,UserNum)+1i*randn(T,UserNum))/sqrt(2);   % noise
        W = H'*inv(H*H');
        W = W / sqrt(trace(W*W'));
        Signal = TransmitInit(UserNum, H, W, NoiPwr(nNoise), LTEParams, Tn, T);
        
        %ZF-Precoding-----------------------
        k = Signal.k;
        x = W * k.';
        
        %Rx Signal---------------------------      
        BitError = RxDecode(UserNum, H, W, x, Signal, v, NoiPwr(nNoise), LTEParams);
        for User = 1:UserNum
            ThroughPut(nNoise,User) = ThroughPut(nNoise,User) + (1-BitError(User))*Signal(User).NumInfoBits*1000/1e6;
            BLER(nNoise,User) = BLER(nNoise,User) + BitError(User);
            R(nNoise,User) = R(nNoise,User) + log2(1+Signal(User).SINR);
            SINR(nNoise,User) = Signal(User).SINR;
        end
        
    end
end

close(wb);
BLER = BLER/Ntrials;

R = R/Ntrials;
Bandwidth = Nsc * Ns * Tn/1e-3;
F = (Tframe - Tcp)/(Tframe) * (Ns * Nsc/2 - 4)/(Nsc * Ns/2);
CapacityTotal = F*(sum(R,2))* Bandwidth/1e6;

ThroughPutTotal = sum(ThroughPut,2)/Ntrials;

figure(1);
plot(dBNoiPwr, ThroughPutTotal, dBNoiPwr, CapacityTotal,'-xb');
xlabel('Noise Power(dB)');ylabel('Through Put [Mbit/s]');
grid

