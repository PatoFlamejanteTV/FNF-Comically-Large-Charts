@echo off
setlocal

:: Define o diretório principal e o arquivo de saída
set "dirPath=C:\Users\mcmco\Downloads\Compressed\FNF-JS-Engine\mods\bigmod"
set "outputFile=json_check_results.txt"

:: Limpa o arquivo de saída, se já existir
if exist "%outputFile%" del "%outputFile%"

:: Itera por todas as subpastas e arquivos JSON
for /r "%dirPath%" %%F in (*.json) do (
    echo Verificando arquivo %%F...
    jq . "%%F" >nul 2>&1
    if %errorlevel% equ 0 (
        echo [OK] JSON válido: %%F >> "%outputFile%"
    ) else (
        echo [ERRO] JSON inválido ou corrompido: %%F >> "%outputFile%"
    )
)

echo Verificação concluída. Resultados salvos em "%outputFile%"
endlocal
pause
