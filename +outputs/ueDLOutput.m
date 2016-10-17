classdef ueDLOutput < handle
% UE output, including ACK, subframe rv_idx, CQI...
% Josep Colom Ikuno, jcolom@nt.tuwien.ac.at
% (c) 2009 by INTHFT
% www.nt.tuwien.ac.at

   properties
       

%        C
%        UE_scheduled
%        rv_idx
% 
       rx_data_bits
       rx_coded_bits
%        RI
%        PMI
%        CQI
%        CQI_bar
%        HARQ_process
%        channel_estimation_error
%        freq_offset_est
%        timing_offset_est
%        PE_signal_power_subframe % Post Equalization Signal Power Matrix
%        PE_noise_power_subframe  % Post Equalization Noise Power Matrix
%        Signal_plus_noise_power
%        Noise_power

       ACK_codeblocks       
       C       
       
       rxgrid
       grid_est
       DLChannel_DMRS
       LLR_codeword
       UE_est_grid
       ACK

       CSI_DMRS_feedback

       CSI_feedback %feedback by CSI-RS
       
   end

   methods
        function obj=ueDLOutput()
           obj.ACK_codeblocks       =[];
           obj.C =[];      

           obj.rxgrid=[];
           obj.grid_est=[];
           obj.DLChannel_DMRS=[];
           obj.LLR_codeword=[];
           obj.UE_est_grid=[];
           obj.ACK=[];

           obj.CSI_feedback.CQI=[]; %feedback by CSI-RS
           obj.CSI_feedback.SINR=[]; %feedback by CSI-RS
           obj.CSI_feedback.PMI=[]; %feedback by CSI-RS
           obj.CSI_feedback.RI=[]; %feedback by CSI-RS
           
           obj.CSI_DMRS_feedback.CQI_legacy=[]; %feedback by DMRS
           obj.CSI_DMRS_feedback.SINR_legacy=[]; %feedback by DMRS
           obj.CSI_DMRS_feedback.CQI=[]; %feedback by DMRS
           obj.CSI_DMRS_feedback.SINR=[]; %feedback by DMRS           
       end
       
       function clear(obj)
           obj.ACK_codeblocks       =[];
           obj.C =[];      

           obj.rxgrid=[];
           obj.grid_est=[];
           obj.DLChannel_DMRS=[];
           obj.LLR_codeword=[];
           obj.UE_est_grid=[];
           obj.ACK=[];
  

           obj.CSI_feedback.CQI=[]; %feedback by CSI-RS
           obj.CSI_feedback.SINR=[]; %feedback by CSI-RS           
           obj.CSI_feedback.PMI=[]; %feedback by CSI-RS
           obj.CSI_feedback.RI=[]; %feedback by CSI-RS
           
           obj.CSI_DMRS_feedback.CQI_legacy=[]; %feedback by DMRS
           obj.CSI_DMRS_feedback.SINR_legacy=[]; %feedback by DMRS           
           obj.CSI_DMRS_feedback.CQI=[]; %feedback by DMRS
           obj.CSI_DMRS_feedback.SINR=[]; %feedback by DMRS           
       end
   end
end 
