@Echo Off
:START

REM ######AWD&AWS#####
echo $WIMWV,90,R,010.00,N,A*01>>com3
waitfor /T 1 0 > nul

REM ######other data NMEA#######
echo $WIXDR,C,+002.3,C,TEMP,P,1.0089,B,PRESS,H,067.2,P,RH*3C>>com3

REM #####RMC######
echo $GPRMC,123519,A,4807.038,N,01131.000,E,025.0,084.4,230394,003.1,W*6A>>com7

REM ##############HDT##############
echo $GPHDT,10.000,T*00>>com5
waitfor /T 5 0 > nul

REM ######GILL#######
echo Q,180,009.77,+002.4,1008.5,067.0,-003.0,00,+04.8,58>>com3
waitfor /T 5 0 > nul
echo $WIMWV,270,R,010.00,N,A*01>>com3
waitfor /T 2 0 > nul
echo $WIMWV,0,R,010.00,N,A*01>>com3
waitfor /T 2 0 > nul
GoTo START
EXIT