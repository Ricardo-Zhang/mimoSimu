function LLR =  LLR_SISO(y,h, NoisePower,MCS_params,Params, LLR_method)

if ~exist('LLR_method','var')
    LLR_method='soft-decision';
end

y=reshape(y,[],1);
Constellation=Params.SymbolAlphabet{MCS_params.modulation_order};
Constellation=reshape(Constellation,[],1);

y=y./h;
NoisePower=NoisePower./(abs(h).^2);


switch lower(LLR_method)
	case 'hard-decision'

        e=bsxfun(@minus,y, Constellation.');

        [~,ind]=min(abs(e),[],2);

        symbol= Constellation(ind);     %hard decision symbol

        LLR=dec2bin(ind-1,MCS_params.modulation_order)'-48;     %bits
        
        LLR=10*LLR-5;                   %if bit=1, then LLR=5; if bit=0, LLR=-5; Not sure whether this is good or not.
                 
	case 'soft-decision'
        LLR_symb=exp(-bsxfun(@rdivide,abs(bsxfun(@minus, y , Constellation.')).^2,NoisePower)); %symbol LLR
        
        M=MCS_params.modulation_order;          %no. of bits in each symbol     
        
        %compute LLR for each bits
        for nn=1:M  %compute the nn bit

            M1=M-nn;
            M2=nn-1;
            Ind0=bsxfun(@plus,((0:2^M1-1)*2^nn)',(0:2^M2-1));   %symbol indexes with the nn bit=0
            Ind1=Ind0+2^(nn-1);                                 %symbol indexes with the nn bit=1
            Prob0=sum(LLR_symb(:,Ind0+1),2);                    %probility of nn bit=0
            Prob1=sum(LLR_symb(:,Ind1+1),2);                    %probility of nn bit=1
            LLR(M-nn+1,:)=log(Prob1./Prob0);                    %LLR
        end
        % LLR=max(min(LLR,10),-10);                               %clip to [-10,10]; I am not sure whether this is good or not. But it works.
        LLR=LLR(:);
    otherwise
        error('LLR calculation method not defined;');
	end
end

