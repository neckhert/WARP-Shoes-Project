 set I; #index of product type
 set J; #index of machine
 set W; #index of warehouse
 set K; #index of shoe part
 
 param d{I};
 param D{i in I}:= 2*d[i];
 param n{I,K} default 0; #number of rm per shoe
 param p{K}; #cost per rm
 param m{i in I}:= sum{k in K} n[i,k]*p[k]; #cost of materials per shoe
 param t{I,J} default 0; #time to manufacture per shoe per machine (s)
 param T{i in I, j in J}:= t[i,j]/360;
 param s{I}; #profit per shoe sold
 param c{W}; #capacity per warehouse
 param h{W}; #cost to open warehouse
 
 var x{I} >= 0 integer;
 var y{W} binary;
 
 maximize profit : (sum {i in I} s[i] * x[i]) #revenue
 					- (25* sum {i in I, j in J} T[i,j]*x[i]) #worker cost
 					- (sum {i in I} 10 * (D[i] - x[i])) #not meeting demand cost
 					- (sum {w in W} y[w] * h[w]) #warehouse opening cost
 					- (sum {i in I} x[i] * m[i]); #raw material price

 
s.t. demand {i in I}: x[i] <= D[i];
s.t. budget : sum {i in I} x[i] * m[i] <= 10000000;
s.t. machine_hours {j in J}: sum {i in I} t[i,j] * x[i] <= 1209600;
s.t. warehouse_cap : sum  {i in I} x[i] <= sum {w in W} c[w] * y[w];
