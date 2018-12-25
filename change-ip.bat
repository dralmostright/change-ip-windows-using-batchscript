:: 
:: @Author : Suman Adhikari
::
:: @Date : 2018/09/18
::
:: @Description : The script designed to assign the IP address in windows via bat script.
::				  As a DBA i have visit client side and my ip address varied as per client.
::				  Hence, it helps to assign ip via cmd
::
:: @Version : 1.0
::
:: @Last updated date :
::
:: @Revisions

@ECHO OFF  
title Configuring IP address from cmd
echo. 
echo. 
echo ^/$$$$$$$                            ^/$$                                 ^/$$       ^/$$$$$$$ ^/$$     ^/$$          
echo ^| $$__  $$                          ^| $$                                ^| $$      ^| $$__  $^|  $$   ^/$$^/          
echo ^| $$  ^\ $$ ^/$$$$$$ ^/$$    ^/$$^/$$$$$$^| $$ ^/$$$$$$  ^/$$$$$$  ^/$$$$$$  ^/$$$$$$$      ^| $$  ^\ $$^\  $$ ^/$$^/        ^/$$
echo ^| $$  ^| $$^/$$__  $^|  $$  ^/$$^/$$__  $^| $$^/$$__  $$^/$$__  $$^/$$__  $$^/$$__  $$      ^| $$$$$$$  ^\  $$$$^/        ^|__^/
echo ^| $$  ^| $^| $$$$$$$$^\  $$^/$$^| $$$$$$$^| $^| $$  ^\ $^| $$  ^\ $^| $$$$$$$^| $$  ^| $$      ^| $$__  $$  ^\  $$^/             
echo ^| $$  ^| $^| $$_____^/ ^\  $$$^/^| $$_____^| $^| $$  ^| $^| $$  ^| $^| $$_____^| $$  ^| $$      ^| $$  ^\ $$   ^| $$           ^/$$
echo ^| $$$$$$$^|  $$$$$$$  ^\  $^/ ^|  $$$$$$^| $^|  $$$$$$^| $$$$$$$^|  $$$$$$^|  $$$$$$$      ^| $$$$$$$^/   ^| $$          ^|__^/
echo ^|_______^/ ^\_______^/   ^\_^/   ^\_______^|__^/^\______^/^| $$____^/ ^\_______^/^\_______^/      ^|_______^/    ^|__^/              
echo                                                 ^| $$                                                             
echo   ^/$$$$$$                                       ^| $$      ^/$$$$$$                                                
echo  ^/$$__  $$                                      ^|__^/     ^/$$__  $$                                               
echo ^| $$  ^\__^/^/$$   ^/$$^/$$$$$$^/$$$$  ^/$$$$$$ ^/$$$$$$$       ^| $$  ^\ $$                                               
echo ^|  $$$$$$^| $$  ^| $^| $$_  $$_  $$^|____  $^| $$__  $$      ^| $$$$$$$$                                               
echo  ^\____  $^| $$  ^| $^| $$ ^\ $$ ^\ $$ ^/$$$$$$^| $$  ^\ $$      ^| $$__  $$                                               
echo  ^/$$  ^\ $^| $$  ^| $^| $$ ^| $$ ^| $$^/$$__  $^| $$  ^| $$      ^| $$  ^| $$                                               
echo ^|  $$$$$$^|  $$$$$$^| $$ ^| $$ ^| $^|  $$$$$$^| $$  ^| $$      ^| $$  ^| $$       ^/$$                                     
echo  ^\______^/ ^\______^/^|__^/ ^|__^/ ^|__^/^\_______^|__^/  ^|__^/      ^|__^/  ^|__^/      ^|__^/                                     
echo. 
echo.                                                                                                    
echo DEVELOPED BY: SUMAN ADHIKARI
echo FOR MORE, PLEASE VISIT : https://github.com/dralmostright   
echo.                                                                                                       
echo DESCRIPTION:
echo The script is designed to assign the IP-Address based on the user choice:
echo.  
pause
cls
echo. 
echo PLEASE CHOOSE THE CLIENT TO SET THE IP-ADDRESS:
echo. 
echo         :NT
echo         :HBL
echo         :NIBL
echo         :GIBL
echo         :MBL
echo         :NICA
echo         :NEPS
echo         :SCT
echo         :BOK
echo         :UTL
echo         :MnI
echo         :RESET
echo. 
SET /P CLIENT="    Your Desired Client Name : "
echo. 

2>NUL CALL :CASE_%CLIENT% # jump to :CASE_red, :CASE_blue, etc.
IF ERRORLEVEL 1 CALL :ERRDEFAULT # if label doesn't exist

ECHO Done.
pause
EXIT /B

:CASE_NT
	SET /P CHOICE=" If you want to put IP manually press (Y) else for using default press (N) : "
	IF /i "%CHOICE%"=="Y" goto SETIP
	IF /i "%CHOICE%"=="N" goto NTDEFAULT
	GOTO ERRDEFAULT

:CASE_NT
	SET /P CHOICE=" If you want to put IP manually press (Y) else for using default press (N) : "
	IF /i "%CHOICE%"=="Y" goto SETIP
	IF /i "%CHOICE%"=="N" goto NEPSDEFAULT
	GOTO ERRDEFAULT
	
:CASE_RESET
	netsh interface ipv4 set address name="Ethernet" source=dhcp
	netsh interface ipv4 set dns name="Ethernet" source=dhcp
	GOTO SHOWOFF
  
:NTDEFAULT
	netsh interface ipv4 set address name="Ethernet" static xxx.xxx.xxx.xxx xxx.xxx.xxx.xxx xxx.xxx.xxx.xxx
	netsh interface ipv4 set dns name="Ethernet" static x.x.x.x
	netsh interface ipv4 add dns name="Ethernet" x.x.x.x index=2
	GOTO SHOWOFF

:NEPSDEFAULT
	netsh interface ipv4 set address name="Ethernet" static xxx.xxx.xxx.xxx xxx.xxx.xxx.xxx xxx.xxx.xxx.xxx
	netsh interface ipv4 set dns name="Ethernet" static x.x.x.x
	netsh interface ipv4 add dns name="Ethernet" x.x.x.x index=2
	GOTO SHOWOFF
	
:ERRDEFAULT
	echo.
	echo ERROR: Invalid choice exiting.
	echo.
	GOTO END_CASE

:SETIP
	SET /P IP=" IPv4-ADDRESS: "
	SET /P SUBNET=" SUBNET MASK: "
	SET /P GATEWAY=" GATEWAY: "
	SET /P DNSADD1=" PRI-DNS: "
	SET /P DNSADD2=" SEC-DNS: "
	
	netsh interface ipv4 set address name="Ethernet" static %IP% %SUBNET% %GATEWAY%
	netsh interface ipv4 set dns name="Ethernet" static %DNSADD1%
	netsh interface ipv4 add dns name="Ethernet" %DNSADD2% index=2
	GOTO SHOWOFF
	
:END_CASE
  VER > NUL # reset ERRORLEVEL
  GOTO CASE_ENDNOTE
  GOTO :EOF # return from CALL

:SHOWOFF
	cls
	echo.
	echo The following IP-Configuration have updated.
	echo.
	netsh interface ipv4 show config name="Ethernet"
	echo.
	GOTO END_CASE

:CASE_ENDNOTE
	echo.
	ECHO Thank You! Enjoy Your Day :)
	Echo FOR MORE, PLEASE VISIT : https://github.com/dralmostright  
	echo. 
