# Gym Reservation System Startup Script (PowerShell)
# Set console encoding to UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Gym Reservation System Startup Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check required tools
Write-Host "[Check] Verifying required tools..." -ForegroundColor Yellow

# Check Java
try {
    $javaVersion = java -version 2>&1 | Select-String "version"
    Write-Host "✓ Java: $($javaVersion.Line)" -ForegroundColor Green
} catch {
    Write-Host "✗ Java not installed or not in PATH" -ForegroundColor Red
    exit 1
}

# Check Maven
try {
    $mavenVersion = mvn -version 2>&1 | Select-String "Apache Maven"
    Write-Host "✓ Maven: $($mavenVersion.Line)" -ForegroundColor Green
} catch {
    Write-Host "✗ Maven not installed or not in PATH" -ForegroundColor Red
    exit 1
}

# Check Node.js
try {
    $nodeVersion = node --version
    Write-Host "✓ Node.js: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Node.js not installed or not in PATH" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Start backend service
Write-Host "[1/3] Starting Backend Service (Spring Boot)..." -ForegroundColor Yellow
Write-Host "Starting backend service, please wait..." -ForegroundColor Gray

$backendJob = Start-Job -ScriptBlock {
    Set-Location "backend"
    mvn spring-boot:run
}

Write-Host "Backend service started in background (Job ID: $($backendJob.Id))" -ForegroundColor Green

# Wait for backend service to start
Write-Host ""
Write-Host "[2/3] Waiting for backend service to start..." -ForegroundColor Yellow
Write-Host "Waiting 15 seconds for backend service to fully start..." -ForegroundColor Gray
Start-Sleep -Seconds 15

# Start frontend admin system
Write-Host ""
Write-Host "[3/3] Starting Frontend Admin (Vue.js)..." -ForegroundColor Yellow

# Check if dependencies are installed
if (!(Test-Path "frontend-admin/node_modules")) {
    Write-Host "Installing frontend dependencies..." -ForegroundColor Gray
    Set-Location "frontend-admin"
    npm install
    Set-Location ".."
}

Write-Host "Starting frontend admin system..." -ForegroundColor Gray

$frontendJob = Start-Job -ScriptBlock {
    Set-Location "frontend-admin"
    npm run dev
}

Write-Host "Frontend admin system started in background (Job ID: $($frontendJob.Id))" -ForegroundColor Green

# Display startup information
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Startup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "🌐 Backend API: http://localhost:8080" -ForegroundColor White
Write-Host "🖥️  Frontend Admin: http://localhost:5173" -ForegroundColor White
Write-Host "📚 API Documentation: http://localhost:8080/doc.html" -ForegroundColor White
Write-Host ""
Write-Host "Notes:" -ForegroundColor Yellow
Write-Host "- WeChat Mini Program: Open frontend-miniapp in WeChat DevTools" -ForegroundColor Gray
Write-Host "- Ensure MySQL and Redis services are running" -ForegroundColor Gray
Write-Host "- Press Ctrl+C to stop services" -ForegroundColor Gray
Write-Host "========================================" -ForegroundColor Cyan

# Keep script running and show logs
Write-Host ""
Write-Host "Services running... Press Ctrl+C to stop all services" -ForegroundColor Green
Write-Host ""

try {
    while ($true) {
        Start-Sleep -Seconds 5
        
        # Check job status
        $backendStatus = Get-Job -Id $backendJob.Id | Select-Object -ExpandProperty State
        $frontendStatus = Get-Job -Id $frontendJob.Id | Select-Object -ExpandProperty State
        
        Write-Host "$(Get-Date -Format 'HH:mm:ss') - Backend: $backendStatus, Frontend: $frontendStatus" -ForegroundColor DarkGray
        
        # Show errors if jobs failed
        if ($backendStatus -eq "Failed") {
            Write-Host "Backend service failed to start!" -ForegroundColor Red
            Receive-Job -Id $backendJob.Id
        }
        
        if ($frontendStatus -eq "Failed") {
            Write-Host "Frontend service failed to start!" -ForegroundColor Red
            Receive-Job -Id $frontendJob.Id
        }
    }
} finally {
    # Cleanup jobs
    Write-Host ""
    Write-Host "Stopping services..." -ForegroundColor Yellow
    Stop-Job -Id $backendJob.Id -ErrorAction SilentlyContinue
    Stop-Job -Id $frontendJob.Id -ErrorAction SilentlyContinue
    Remove-Job -Id $backendJob.Id -ErrorAction SilentlyContinue
    Remove-Job -Id $frontendJob.Id -ErrorAction SilentlyContinue
    Write-Host "All services stopped." -ForegroundColor Green
}