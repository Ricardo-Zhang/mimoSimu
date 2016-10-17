function BitError = RxDecode(UserNum, H, W, x, SignalStruct, v, NoisePwr, LTEParams)
BitError = zeros(1,UserNum);
for User = 1:UserNum
    y = (H(User,:) * x).'+ sqrt(NoisePwr) * v(:,User);
    LLR=LLR_SISO(y,H(User,:)*W(:,User), NoisePwr,SignalStruct(User).MCSPara,LTEParams,'soft-decision');
    [DecodedBits]=ChannelDecoding(LLR,SignalStruct(User).Signaling,LTEParams);
    BitError(User) = logical(sum(abs(SignalStruct(User).DataBits-DecodedBits)>0.5));
end
end