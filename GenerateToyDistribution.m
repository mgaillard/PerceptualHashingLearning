function [Points, X1, X2, S] = GenerateToyDistribution()
  P1 = [0.5, 1];
  P2 = [1, 0.5];
  P3 = [-0.5, -1];
  P4 = [-1, -0.5];

  Points = [P1; P2; P3; P4];
       
  X1 = [P1;
        P1;
        P1;
        P2;
        P2;
        P3];

  X2 = [P2;
        P3;
        P4;
        P3;
        P4;
        P4];
        
   
  S = [1;
       0;
       0;
       0;
       0;
       1];
end