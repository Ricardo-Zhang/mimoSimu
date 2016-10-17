function SignalStruct = TransmitInit(UserNum, H, W, NoisePwr, LTEParams, Tn, T)

k = zeros(T,UserNum);
for User = 1:UserNum
    Interf = 0; % Interference Init
    for i = 1:UserNum
        Interf = Interf + H(User,:)*W(:,i)*W(:,i)'*H(User,:)';
    end
    SINR{1,User} = real((H(User,:)*W(:,User)*W(:,User)'*H(User,:)')/((Interf - H(User,:)*W(:,User)*W(:,User)'*H(User,:)')+NoisePwr));
    SINRdB = 10*log10(SINR{1,User}); % SINR trans to dB format

    MCS = SNR_CQI_Mapping(SINRdB); % MCS Mapping

    MCS_params{1,User}=LTEParams.MCS_params(MCS+1); %MCS parameter according to the selected MCS. 
    NumInfoBits{1,User}=LTEParams.MCS_table(MCS_params{1,User}.TBS+1,Tn); %no. of information bits according to Tn and MCS.
    NumCodedBits=T*MCS_params{1,User}.modulation_order;  
    DataBits{1,User} = logical(randi(2,1,NumInfoBits{1,User})-1);  %data bits for User1; logical
    [CodedBits,Signaling{1,User}]=ChannelCoding(DataBits{1,User},NumCodedBits,MCS_params{1,User},LTEParams);    %channel coding; consider this as a black box.
    symbol_index = bin2dec(char(reshape(CodedBits,MCS_params{1,User}.modulation_order,T)+48)');   %symbol index
    s{1,User} = LTEParams.SymbolAlphabet{MCS_params{1,User}.modulation_order}(symbol_index+1);            %symbols  
    k(:,User) = s{User};
end

field1 = 'SINR'; value1 = SINR;
field2 = 'MCSPara'; value2 = MCS_params;
field3 = 'DataBits'; value3 = DataBits;
field4 = 'Signaling'; value4 = Signaling;
field5 = 'NumInfoBits'; value5 = NumInfoBits;
field6 = 'k'; value6 = k;
SignalStruct = struct(field1, value1, field2, value2, field3, value3, field4, value4, field5, value5, field6, value6);
end


