function MCS = SNR_MCS_Mapping(SNRdB)  
if SNRdB < -5.1
    CQI = 1;
elseif SNRdB < -4.4
    CQI = 2;
elseif SNRdB < -2.5
    CQI = 3;
elseif SNRdB < -0.2
    CQI = 4;
elseif SNRdB < 1.4
    CQI = 5;
elseif SNRdB < 3.3
    CQI = 6;
elseif SNRdB < 5.1
    CQI = 7;
elseif SNRdB < 6.2
    CQI = 8;
elseif SNRdB < 8.5
    CQI = 9;
elseif SNRdB < 10.2
    CQI = 10;
elseif SNRdB < 11.6
    CQI = 11;
elseif SNRdB < 13.4
    CQI = 12;
elseif SNRdB < 14.3
    CQI = 13;
elseif SNRdB < 16.6
    CQI = 14;
else
    CQI = 15;
end
MCSSet = [0 1 2 4 7 9 12 14 16 19 21 23 25 27 28];
MCS = MCSSet(CQI);