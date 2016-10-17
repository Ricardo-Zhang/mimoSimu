classdef mylteScheduler < handle
% Implements methods common to all the schedulers.
% Josep Colom Ikuno, jcolom@nt.tuwien.ac.at
% (c) 2009 by INTHFT
% www.nt.tuwien.ac.at

   properties
       maxCodewords = 2;  % Maximum number of codewords that can be transmitted per TTI. For LTE, that's 2
       
       NumUE               % Total number of UEs -> length(UEs)
       UE_schedule   % In case this is a static scheduler, this variable stores for each
                          % UE the scheduling parameters that will be user.
                          % The only parameter that cannot be statically
       max_HARQ_retx      % Max num of HARQ retransmissions, NOT including the original tx. 0, 1, 2 or 3

       CQI_table        % CQI parameters for all possible MCSs
       
       MCS_table         %MCS parameters
            
       MCS_determine      %0, MCS is fixed
                          %1, chosen by BF alone
                          %2, chosen by simple OLLA withough considering BF
                          %3, chosen by smart OLLA considering BF
       OLLA
       
       
      
                          
                          
   end

   methods
       % Superclass constructor which is called by all subclasses
       function obj = mylteScheduler(scheduler_params,OLLAParams)
           
           obj.NumUE           = scheduler_params.NumUE;
           
           obj.max_HARQ_retx = scheduler_params.max_HARQ_retx;
           
           obj.MCS_determine  = scheduler_params.MCS_determine;
           
           obj.UE_schedule  = scheduler_params.UE_schedule;
           
           obj.OLLA=OLLAParams;
           
           
       end
       
       function  determine_MCS(obj,ACK,SINR_feedback,system_clock, SINR_offset)
        global CellParams
           if obj.MCS_determine==0 
               %fixed MCS
%                for nUE=1:obj.NumUE
%                     obj.UE_schedule(nUE).CQI_params=CellParams.CQI_params(obj.UE_schedule(nUE).cqi);
%                end;
               obj.calculate_allocated_bits(system_clock);
              return;
           end
           
%            if obj.MCS_determine==1
%                %BF chooses MCS
%                for nUE=1:obj.NumUE
%                     obj.UE_schedule(nUE).cqi=SchedulerParams(nUE).cqi;
%                     obj.UE_schedule(nUE).CQI_params=CellParams.CQI_params(SchedulerParams(nUE).cqi);
%                end;
%                obj.calculate_allocated_bits;
%            end;
               
           if obj.MCS_determine==2 || obj.MCS_determine==4 ||obj.MCS_determine==3%OLLA determins MCS completely
               for nUE=1:obj.NumUE

                    A_up=obj.OLLA.BLER_R*obj.OLLA.delta; A_down=-(1-obj.OLLA.BLER_R)*obj.OLLA.delta;

                    %if no ACK is receive, change nothing
                    if isempty(ACK{nUE})
                        continue;
                    end;
                           
                    for cw=1:length(ACK{nUE})
                        
                        %increase the SINR offset if successfully received,
                        %decrease otherwise
                        if ACK{nUE}(cw)
                            obj.OLLA.A_offset(cw,nUE)=obj.OLLA.A_offset(cw,nUE)+A_up;
                        else
                            obj.OLLA.A_offset(cw,nUE)=obj.OLLA.A_offset(cw,nUE)+A_down;
                        end;
                        %the offset is bounded in some region
                        obj.OLLA.A_offset(cw,nUE)=min(max(obj.OLLA.A_offset_range(1),obj.OLLA.A_offset(cw,nUE) ),obj.OLLA.A_offset_range(2));

 
                        
                        
                        %MCS is selcted accoring to this SINR
                        if obj.MCS_determine==2
                            SINR_current=obj.OLLA.A_offset(cw,nUE)+SINR_feedback{nUE}(cw);
                        elseif obj.MCS_determine==4
                            SINR_current=obj.OLLA.A_offset(cw,nUE);
                        elseif obj.MCS_determine==3
%                             SINR_current=obj.OLLA.A_offset(cw,nUE)+SINR_feedback{nUE}(cw)+SINR_offset{nUE}(cw);
                            SINR_current=obj.OLLA.A_offset(cw,nUE)+(0.6*SINR_feedback{nUE}(cw)+0.4*SINR_offset{nUE}(cw));
                        end
                            

                        MCS_t=find(CellParams.SINR2MCS<=SINR_current,1,'last')-1;
                        
                        if isempty(MCS_t)
                            obj.UE_schedule(nUE).MCS(cw)=0;
                        else
                            obj.UE_schedule(nUE).MCS(cw)=MCS_t;
                        end;


                    end
                    
                    obj.UE_schedule(nUE).MCS_params=CellParams.MCS_params(obj.UE_schedule(nUE).MCS+1);                         
                              
               end
               
               

               obj.calculate_allocated_bits(system_clock);
           end       

           
           
       end;
       
   
       function calculate_allocated_bits(obj,system_clock)
           global CellParams;
           
           
           
           for nUE=1:obj.NumUE
               
               Temp= obj.UE_schedule(nUE);   
               
               %compute overhead within a physical RB pair
               
               % for 3 or more layers, DMRS overhead is doubled
               if Temp.nLayers>2
                    overhead=24;
               else
                   overhead=12;
               end;
               
               if CellParams.CSIParams.isexist && mod(10*system_clock.n_f+system_clock.subframe_i, CellParams.CSIParams.Tperiod)==CellParams.CSIParams.Toffset
                   overhead=overhead+2*(floor((CellParams.CSIParams.Nap-1)/2)+1);
               end
               
               if CellParams.CRSParams.isexist
                   if CellParams.CRSParams.Nap==1
                        overhead=overhead+8;
                   elseif  CellParams.CRSParams.Nap==2
                        overhead=overhead+16;
                   elseif  CellParams.CRSParams.Nap==4
                        overhead=overhead+24;
                   end
               end
               
               if Temp.NumAssignedRBs>=1
                   
                    %no. of data bits for one layer transmission 
                    N_data_bits_1layer=CellParams.MCS_table{1}([Temp.MCS_params.TBS]+1, Temp.NumAssignedRBs);
                    
                    %no. of layers for each codeword
                    if Temp.nCodewords==1
                        nLayers_percodeword=Temp.nLayers;
                    else
                        nLayers_percodeword= [floor(Temp.nLayers/2) Temp.nLayers-floor(Temp.nLayers/2)];
                    end
                    
                    %refer to 36.213 for TB size 
                    for cw=1:Temp.nCodewords
                        switch nLayers_percodeword(cw)
                            case 1
                                obj.UE_schedule(nUE).N_data_bits(cw)=N_data_bits_1layer(cw);
                            case 2
                                if Temp.assignedRBs<=55
                                    obj.UE_schedule(nUE).N_data_bits(cw)=2*N_data_bits_1layer(cw);
                                else
                                    obj.UE_schedule(nUE).N_data_bits(cw)=CellParams.MCS_table{2}(find(CellParams.MCS_table{2}(:,1)==N_data_bits_1layer(cw),1,'first'),2);
                                end
                            case 3
                                if Temp.assignedRBs<=36
                                    obj.UE_schedule(nUE).N_data_bits(cw)=3*N_data_bits_1layer(cw);
                                else
                                    obj.UE_schedule(nUE).N_data_bits(cw)=CellParams.MCS_table{3}(find(CellParams.MCS_table{3}(:,1)==N_data_bits_1layer(cw),1,'first'),2);
                                end
                            case 4
                                if Temp.assignedRBs<=27
                                    obj.UE_schedule(nUE).N_data_bits(cw)=4*N_data_bits_1layer(cw);
                                else
                                    obj.UE_schedule(nUE).N_data_bits(cw)=CellParams.MCS_table{4}(find(CellParams.MCS_table{4}(:,1)==N_data_bits_1layer(cw),1,'first'),2);
                                end
                                
                                    
                        end;
                    end;
                    
                    obj.UE_schedule(nUE).N_coded_bits =nLayers_percodeword.*[Temp.MCS_params.modulation_order]* Temp.NumAssignedRBs * (2*CellParams.N_symb*CellParams.N_sc_RB-overhead);   
                end;
           end
               
               
%                if Temp.nLayers>2
%                     overhead=2*obj.overhead_ref;
%                else
%                    overhead=obj.overhead_ref;
%                end;
%                

               
%                if obj.UE_schedule(nUE).nLayers>3
%                    error('this calculation is not correct when DMRSPorts is greater than 2. RE elements with the same (k,l) is other antenna ports are not used for PDSCH');
%                end;
               
%                 if Temp.nCodewords==2
%                     obj.UE_schedule(nUE).N_coded_bits =2*[floor(Temp.DMRSPorts/2) Temp.DMRSPorts-floor(Temp.DMRSPorts/2)].* [Temp.CQI_params.modulation_order]* sum(Temp.assignedRBs) * (CellParams.N_symb*CellParams.N_sc_RB-overhead);   
%                else
%                    obj.UE_schedule(nUE).N_coded_bits =2*Temp.DMRSPorts.* Temp.CQI_params.modulation_order* sum(Temp.assignedRBs) * (CellParams.N_symb*CellParams.N_sc_RB-overhead);   
%                end;
%                obj.UE_schedule(nUE).N_data_bits  = 8*round(1/8 * obj.UE_schedule(nUE).N_coded_bits.* [Temp.CQI_params.coding_rate_x_1024] / 1024)-24; % calculate G based on TB_size and the target rate

                 
       end       
       
       function UE_MCS_and_scheduling_info=schedule_info(obj)
                      UE_MCS_and_scheduling_info=obj.UE_schedule;
       end;

       
     
   end 
end
