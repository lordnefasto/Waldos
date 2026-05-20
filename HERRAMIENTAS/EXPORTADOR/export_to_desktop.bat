@echo off
setlocal EnableExtensions
set "MPMissionsCache=%LOCALAPPDATA%\Arma 3\MPMissionsCache\Waldos.pbo"

rem =========================
rem ORIGEN Y DESTINO
rem =========================
for %%I in ("%~dp0..\..") do set "src=%%~fI"
set "target=%USERPROFILE%\Desktop\TOPE\Waldos.Altis"

echo ======================================
echo Exportando "%src%"
echo a "%target%"
echo ======================================

rem =========================
rem LIMPIAR DESTINO
rem =========================
if exist "%target%" (
    rd /s /q "%target%"
)

mkdir "%target%"

rem =========================
rem COPIAR ARCHIVOS
rem =========================
xcopy "%src%\*" "%target%\" /E /I /H /Y ^
/EXCLUDE:export_exclude.txt

if errorlevel 1 (
    echo ERROR: Fallo en la copia
    exit /b 1
)

rem =========================
rem DETECTAR PBO MANAGER
rem =========================
set "pbom1=C:\Program Files\PBO Manager\pbom.exe"
set "pbom2=%LOCALAPPDATA%\PBO Manager\pbom.exe"

if exist "%pbom1%" (
    set "pbom=%pbom1%"
) else if exist "%pbom2%" (
    set "pbom=%pbom2%"
) else (
    echo ERROR: No se encontro PBO Manager en el sistema
    exit /b 2
)

echo ======================================
echo Usando PBO Manager: "%pbom%"
echo ======================================

rem =========================
rem CREAR PBO
rem =========================
"%pbom%" pack "%target%" -o "%USERPROFILE%\Desktop\TOPE"

if errorlevel 1 (
    echo ERROR: Fallo al crear el PBO
    exit /b 3
)

rem =========================
rem BORRAR CARPETA TEMPORAL
rem =========================
echo ======================================
echo Eliminando carpeta temporal...
echo ======================================

rd /s /q "%target%"

echo ======================================
echo LISTO
echo ======================================

if exist "%MPMissionsCache%" (
    del /f /q "%MPMissionsCache%"
    echo Archivo cache de mision eliminado: %MPMissionsCache%
)

exit /b 0