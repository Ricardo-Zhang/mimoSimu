clear;
clc;
close;
for i = 1:10000
    H = randn(2,2);
    Nh = sqrt(1/2)*abs(H);
end
mean(Nh(1,1))
mean(Nh(1,2))
mean(Nh(2,1))
mean(Nh(2,2))
