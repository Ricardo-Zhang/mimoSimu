function W = PowerAllo(UserNum,W,AlloType) 
switch(AlloType)
    case 'WaterFilling'
        for user = 1:UserNum
            W(:,user) = W(:,user)/norm(W(:,user),'fro');    
        end
        P = zeros(1,UserNum);           %initial power allocation for all users
        Pwf = UserNum;             %initial water filling power level
        Pwf1 = UserNum;
        Pwf0 = 0;
        for cycle = 1:1000
            for user = 1:UserNum
                yi = 1/(norm(W(:,user),'fro')^2);
                P(user) = max(Pwf*yi - 1,0);
                Pn(user) = P(user)/yi;
            end
            if sum(Pn) > 1
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
            W(:,user) = W(:,user)/norm(W(:,user),'fro');
            W(:,user) = W(:,user)/sqrt(UserNum);
        end
    case 'Regularized'
        W = W / sqrt(trace(W*W'));
    end       
end