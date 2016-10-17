  function fl_CalculateCodingRate (integer P_I_MCS, integer p_N_PRB, integer p_TBSize) return boolean
  {
    const integer tsc_REs_Per_PRB := 138;     /* @sic R5s100155 sic@
                                               * 12 * 12 - 6 [Cell specific reference symbols] total 8, and 2 in symbols 0]
                                               * with DCI =2, symbols o and 1 are used for REGs */
    var integer v_BitsPerSymbol;
    var float v_CodingRate;
 
    // initialise v_BitsPerSymbol
    if (p_I_MCS < 10)
      {
        v_BitsPerSymbol := 2 ; //QPSK
      }
    else if (p_I_MCS < 17)
      {
        v_BitsPerSymbol := 4 ; //16QAM
      }
    else if (p_I_MCS < 29)
      {
        v_BitsPerSymbol := 6 ; //64QAM
      }
    else
      {
        FatalError(__FILE__, __LINE__, "invalid imcs");
      }
    
    v_CodingRate := (int2float(p_TBSize + 24)) / (int2float(p_N_PRB * tsc_REs_Per_PRB * v_BitsPerSymbol));
    
    if ( v_CodingRate <= 0.930)
      {
        return true; // TB size applicable
      }
    else
      {
        return false; // Coding rate is high hence TB size is not applied
      }
  } // end of f_CalculateCodingRate