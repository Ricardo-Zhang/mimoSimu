function [Constellation] = GrayMapping(QAMSize)
switch QAMSize
    case 16
        Constellation=[-3+3i -3+1i -3-3i -3-1i -1+3i -1+1i -1-3i -1-1i 1+3i 1+1i 1-3i 1-1i 3+3i 3+1i 3-3i 3-1i ];
        Constellation=Constellation/sqrt(mean(abs(Constellation).^2));  %normalize the power to one

%     Based on the following mapping
%     0000 0100 1100 1000
%     0001 0101 1101 1001
%     0011 0111 1111 1011
%     0010 0110 1110 1010



        
        
    case 4
        Constellation=[-1+1i 1+1i -1-1i 1-1i];
        Constellation=Constellation/sqrt(mean(abs(Constellation).^2));
%       Based on the following mapping    
%       00 01
%       10 11
    
    otherwise
        error('QAM Size undefined');
end

        