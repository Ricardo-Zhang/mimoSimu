
ClassWrap=cell(2,1);

ClassWrap.UE=network_elements.UE;
ClassWrap.UE.N_soft= 3667200;     
ClassWrap.UE.turbo_iterations=10;                        %turbo decoding iterations
% UE_schedule(nUE).rv_idx=0;
ClassWrap.UE.DLmode=10;

ClassWrap.BS_DL_output = outputs.bsDLOutput(1); 
    