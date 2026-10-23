@echo off
title Liberador de Procesos y Puertos - GymManager
echo ===================================================
echo   CERRANDO INSTANCIAS Y LIBERANDO PUERTOS
echo ===================================================
echo.

:: 1. Cierra el proceso por nombre de imagen de forma forzada
echo [1/3] Terminando procesos GymManager.exe...
taskkill /F /IM GymManager.exe /T 2>nul
taskkill /F /IM GymManager_corregido.exe /T 2>nul
taskkill /F /IM GymManager_nuevo.exe /T 2>nul

:: 2. Busca y cierra procesos huérfanos que apunten a la carpeta dist
echo [2/3] Buscando procesos ocultos en C:\gy\dist\...
for /f "tokens=2 delims=," %%A in ('wmic process where "ExecutablePath like 'C:\\gy\\dist\\%%'" get ProcessId /format:csv 2^>nul ^| findstr /r "^[a-zA-Z0-9]"') do (
    if not "%%A" == "" (
        echo Cerrando PID residual: %%A
        taskkill /F /PID %%A >nul 2>&1
    )
)

:: 3. Verificar estado actual
echo.
echo [3/3] Verificando si quedan puertos o procesos activos:
echo ---------------------------------------------------
tasklist | findstr /I "GymManager"
if %errorlevel% neq 0 (
    echo [OK] Todos los procesos e instancias fueron cerrados. Puertos liberados.
) else (
    echo [ALERTA] Aun quedan procesos activos en memoria.
)

echo.
echo ===================================================
pause
