/ Book: Ernest P Chan "Algorithmic Trading - Strategies and their Rational" (2013)
/ Function references in this script are mapped to above book.
/ startup cmd of q64:   q q.k -s 1 -p 5010 
/ Directory structure  
/ q
/  |- scripts
/       |- data
/ q)\cd scripts
/ q)\l beta.kalman.q
/ Additional note:  You can run the matlab files in Octave to compare results.
/ inputData_ETF.mat  fillMissingData.m  KF_beta_EWA_EWC.m
/ In Octave it might be missing one function, needed for plots "lag"

zeroM2:{[x;y] (x;y)#0f };  / Returns an x by y matrix of 0 
zeroM1:{[x] (x,x)#0f,x#0f};
make_diagA:{[x]`float$x*{x=/:x}til count x};
make_diag:{[x] 	:make_diagA (x)#1f;	}
vvmu:{[x;y]x*/:y}
sumMV:{[M;v]:sum v*t1:M mmu v;};

/ Daily data on EWA-EWC
colnames:`date`hi`lo`cl`op`vol
EWAt: flip colnames!("DFFFFJ";",")0:`:data/EWA2.csv
EWCt: flip colnames!("DFFFFJ";",")0:`:data/EWC2.csv


/ Augment x with ones to  accomodate possible offset in the regression
/ between y vs x.
xA:select cl,t:1f from EWAt
xA:flip xA[`cl`t];
yC:select cl from EWCt
yC:yC[`cl];

delta:0.0001 / delta=1 gives fastest change in beta, delta=0.000....1 allows no change (like traditional linear regression).

n:count yC;

yhat:(); / measurement prediction 
e:(); / measurement prediction error
Q:();  / measurement prediction error variance

Kx:zeroM2[2;n];  / capture K gain
/ For clarity, we denote R(t|t) by P(t).
/ initialize R, P and beta.
R:zeroM1[2];
P:zeroM1[2];
beta:zeroM2[2;n];
Vw:make_diag[2];
Vw:Vw*(delta%(1-delta))
Ve:0.001;

/ Initialize beta(;0) to zero
beta[;0]:0f;
t:0;
/  Given initialized beta and R (and P) to zeros
while[t<n;
	if[t>0;
		[
		beta[;t]:beta[;t-1]; / state prediction. Equation 3.7
		R:P+Vw; / state covariance prediction. Equation 3.8
		]
	  ]
	yhat,:sum xA[t;]*beta[;t]; / measurement prediction. Equation 3.9
	Q,:(sumMV[R;xA[t;]]) + Ve; / xA[t;].R.xA[t;]T; measurement variance prediction. Equation 3.10
	e,:yC[t]-yhat[t]; / measurement prediction error
	K:mmu[R;vvmu[xA[t;];(1%Q[t])]]; / Kalman gain 
	Kx[;t]:K; / list of Kalman gain for review, only
	beta[;t]:beta[;t]+K*\:e[t]; / State update. Equation 3.11
	P:R-vvmu[mmu[xA[t;];R];K]; / State covariance update. Equation 3.12
	t:t+1;
 ]
Kx:flip Kx;
show "K"; show K;
show "P"; show P;
show "beta";show beta;