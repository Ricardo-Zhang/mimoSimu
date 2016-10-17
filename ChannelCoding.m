function [CodedBits,Signaling]=ChannelCoding(DataBits,NumCodedBits,MCS_Params,CellParams)


%----------------------------------------
Signaling=struct;
Signaling.UE=network_elements.UE;
Signaling.UE.N_soft= 3667200;     
Signaling.UE.turbo_iterations=10;                        %turbo decoding iterations
% UE_schedule(nUE).rv_idx=0;
Signaling.UE.DLmode=10;

Signaling.BS_output = outputs.bsDLOutput(1); 
%----------------------------------------
Signaling.BS_output.UE_signaling.turbo_rate_matcher.G = NumCodedBits;
Signaling.BS_output.UE_signaling.turbo_rate_matcher.N_l=1;
Signaling.BS_output.UE_signaling.turbo_rate_matcher.rv_idx=0;
Signaling.BS_output.UE_signaling.MCS_and_scheduling.MCS_params=MCS_Params;

CodedBits = LTE_tx_DLSCH_encode(CellParams,DataBits,Signaling.BS_output.UE_signaling,Signaling.BS_output.genie,Signaling.UE,1);
