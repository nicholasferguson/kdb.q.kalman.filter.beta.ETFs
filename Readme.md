This project has code written in matlab, python and q/KDB+ code.  Code mirrors each other 

My contribution was to convert matlab file over to q/KDB+, for Kalman gain portion.

Code refers to equations from:
Book: Ernest P Chan "Algorithmic Trading - Strategies and their Rational" (2013)

Matlab file implements examples of computing beta between two ETFs, using kalman gain. 

speed:  python is slowest.  Then matlab.  Fastest is q/kdb+.  

to time in kdb+/q/KDB

q)\t \l beta.kalman.q

Note: xAT is Transform of xA

# =========================================================================
	+  R  Estimated measurement error covariance. 
	+  Q  Estimated process error covariance, measurement variance prediction
	+  K  Kalman Gain
	+  P  State Variance
	+  e  measurement prediction error
	+  yhat measurement prediction
+ ========================Analysis of code ================================
+ 											| Vw:Vw*(delta%(1-delta))
 											| Ve:0.001;
 		| xA:EWA cls px								
 		| yC:EWC cls px
 		------Start of LOOP through each Data Point Pair for its beta --------
+ ===measurement/model equations===     =====system/process equations============ 
+  =======transform of data=====          ======Variance/Covariance Adj======
+ 											| R:P+Vw
 	    | yhat,:sum xA[t;]*beta[;t]
 											| Q,:(sumMV[R;xA[t;]]) + Ve	       Q=xA.R.xAT + Ve	
 		| e,:yC[t]-yhat[t]
 											| K:mmu[R;vvmu[xA[t;];(1%Q[t])]]   K=R.xAT.1/Q
 				 _______________<_Adj Var___|				
 			     |
 	    | beta[;t]:beta[;t]+K*\:e[t]
 											| P:R-vvmu[mmu[xA[t;];R];K]  		P=R-K.xA.R
 													
+ -----------------------------------End of LOOP----------------------------------
													
					