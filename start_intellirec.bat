@echo off
set "JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-21.0.10.7-hotspot"
set "CATALINA_HOME=C:\xampp\tomcat"
set "PATH=%JAVA_HOME%\bin;%PATH%"
cd /d "C:\xampp\tomcat\bin"
catalina.bat run
