This project has code written in matlab, python and q/KDB+ code.  Code mirrors each other 

My contribution was to convert matlab file over to q/KDB+, for Kalman gain portion.

Code refers to equations from:
Book: Ernest P Chan "Algorithmic Trading - Strategies and their Rational" (2013)

Matlab file implements examples of computing beta between two ETFs, using kalman gain. 

speed:  python is slowest.  Then matlab.  Fastest is q/kdb+.  

to time in kdb+/q/KDB

q)\t \l beta.kalman.q

