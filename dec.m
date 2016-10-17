function [Ind,S] = dec(S_tilde,codebook)
%quantization

%input:   S_tilde     to be qunatized
%         codebook    constellation

%output:  S           the quantized result
%         Ind         the index of S in codebook

%This funtion performs the following task:
% for each element s_tilde in S_tilde, find the point in codebook that is closest to s_tilde.
% S is the result and Ind is the index of S in codebook

[M,N]=size(S_tilde);

metric=abs(bsxfun(@minus,S_tilde(:),codebook(:).'));

[temp,Ind_t]=min(metric,[],2);

Ind=reshape(Ind_t,M,N);

S=codebook(Ind);



