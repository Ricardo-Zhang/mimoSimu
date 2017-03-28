function [DataBits_decoded]=ChannelDecoding(LLR, Signaling,Params)


[DataBits_decoded,~,ACK]= LTE_rx_DLSCH_decode(Params, reshape(LLR,[],1),Signaling.BS_output.UE_signaling,Signaling.UE,Signaling.BS_output.genie,1);
