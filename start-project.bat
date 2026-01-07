@echo off
chcp 65001 >nul
echo ========================================
echo Gym Reservation System Startup Script
echo ========================================
echo.

echo [1/3] Starting Backend Service (Spring Boot)...
echo Starting backend service, please wait...
start "Backend Service" cmd /k "cd /d backend && mvn spring-boot:run"

echo.
echo [2/3] Waiting for backend service to start...
timeout /t 10 /nobreak > nul

echo.
echo [3/3] Starting Frontend Admin (Vue.js)...
echo Starting frontend admin system, please wait...
start "Frontend Admin" cmd /k "cd /d frontend-admin && npm run dev"

echo.
echo ========================================
echo Startup Complete!
echo ========================================
echo Backend API: http://localhost:8080
echo Frontend Admin: http://localhost:5173
echo API Documentation: http://localhost:8080/doc.html
echo.
echo Notes:
echo - WeChat Mini Program: Open frontend-miniapp in WeChat DevTools
echo - Ensure Java 17, Maven, Node.js are installed
echo - Ensure MySQL and Redis services are running
echo ========================================
pause