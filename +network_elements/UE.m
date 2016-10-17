classdef UE < handle


properties
    


    DLmode                            % DEFINED IN STANDARD 3GPP TS 36.213-820 Section 7.1, page 12
                                    % 1: Single Antenna, 2: Transmit Diversity, 3: Open Loop Spatial Multiplexing
                                    % 4: Closed Loop SM, 5: Multiuser MIMO
                                    
    ULMode
                                    
    NumAnt                             % number of receive antennas at UE
    clock;                      % So the UE is aware in which TTI he is (initialized to 0)
    
    SRSParams;                  %SRS parameters;
    
    velocity;
    
    rxgrid;
    
    N_soft;
    
    Scheduler;
    
    turbo_iterations;
    
    N_ID_cell
    
    MIMO_detection_method
    MIMO_detection_method_LLR    

end

   methods
       % Class constructor, defining default values.
       % Get as input a struct defining the input variables
       function obj = UE(UE_params)
           
           

           % Assign values
           % obj.demapping_method             = UE_params.demapping_method;

%            obj.user_speed                   = UE_params.user_speed;
% 
%            obj.DLMode                           = UE_params.mode;
%            obj.NumAnt                           = UE_params.NumAnt;
%            
%            obj.clock.n_f=0;
%            obj.clock.subframe_i=0;
%            
%            obj.SRSParams=UE_params.SRSParams;
%            
%            obj.CellParams=UE_params.CellParams;

       end
       
  
       
   end
end 
