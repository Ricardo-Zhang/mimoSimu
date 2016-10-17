
clear mex;
%% MEX files that have a debug version



    cd('C-Source')
     mex crc16.c      -output ../LTE_common_crc16
     mex crc24a.c     -output ../LTE_common_crc24a
     mex crc24b.c     -output ../LTE_common_crc24b
     mex ConvEncode.c -output ../LTE_tx_convolutional_encoder
     mex byte2bit.c   -output ../LTE_common_byte2bit
     mex bit2byte.c   -output ../LTE_common_bit2byte

    mex Bit_Interleaver.c                                      -output ../LTE_common_bit_interleaver
    mex Soft_Bit_Interleaver.c                                 -output ../LTE_common_soft_bit_interleaver
    mex SisoDecode.c                                           -output ../LTE_rx_siso_decode
    mex Hard_decision.c                                        -output ../LTE_rx_hard_decision
    mex Turbo_rate_matching_bit_selection.c                    -output ../LTE_common_turbo_rate_matching_bit_selection_and_pruning

    
    cd('..');
    
    fprintf('done');