@echo off
setlocal
set "outputFile=7z_check_results.txt"
set "dirPath=C:\Users\mcmco\Downloads\Compressed\FNF-JS-Engine\mods"  :: Defina o caminho do diretório que deseja verificar

:: Limpa o arquivo de saída, se já existir
if exist "%outputFile%" del "%outputFile%"

:: Itera por todas as pastas e subpastas
for /r "%dirPath%" %%F in (*.7z) do (
    echo Verificando arquivo %%F...
    "C:\Program Files\7-Zip\7z.exe" t "%%F" >nul 2>&1
    if %errorlevel% equ 0 (
        echo [OK] Arquivo válido: %%F >> "%outputFile%"
    ) else (
        echo [ERRO] Arquivo corrompido: %%F >> "%outputFile%"
    )
)

echo Verificação concluída. Resultados salvos em "%outputFile%"
endlocal
pause
