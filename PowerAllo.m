function W = PowerAllo(UserNum,W,AlloType) 
switch(AlloType)
    case 'WaterFilling'
        P = zeros(1,UserNum);           %initial power allocation for all users
        Pwf = 10;             %initial water filling power level
        Pwf1 = 100;
        Pwf0 = 0;
        for cycle = 1:1000
            for user = 1:UserNum
                P(user) = max(Pwf - 1,0);
            end
            if sum(P) > 1
                Pwf1 = Pwf;
                Pwf = (Pwf0+Pwf)/2;
            else
                Pwf0 = Pwf;
                Pwf = (Pwf+Pwf1)/2;
            end
        end
        for user = 1:UserNum
            W(:,user) = W(:,user)*sqrt(P(user));
        end        
    case 'EPS'
        for user = 1:UserNum
            W(:,user) = W(:,user)/sqrt(UserNum);
        end   
end