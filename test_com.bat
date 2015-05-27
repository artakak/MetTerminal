@Echo Off

:START

waitfor /T 5 0 > nul


REM ######AWD&AWS#####

echo $WIMWV,90,R,010.00,N,A*01 $WIXDR,C,+002.3,C,TEMP,P,1.0089,B,PRESS,H,067.2,P,RH*3C>>com2

waitfor /T 1 0 > nul


REM #####RMC######

echo $GPDTM,W84,,00.0000,N,00.0000,E,,W84*41 $GPRMC,112354,A,6943.6768,N,03001.8823,E,0.0,218.9,270515,14.1,E*40>>com6

REM ##############HDT##############

echo $HEROT,000.0,A*2B $HEHDT,114.8,T*23>>com4

waitfor /T 5 0 > nul


REM ######GILL#######

REM echo Q,180,009.77,+002.4,1008.5,067.0,-003.0,00,+04.8,58>>com4
waitfor /T 5 0 > nul

GoTo START

EXIT