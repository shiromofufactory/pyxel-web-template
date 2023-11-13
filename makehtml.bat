@echo off
REM パッケージングとHTML変換
pyxel package .\app .\app\main.py
pyxel app2html app.pyxapp

REM 古いファイルの削除と新しいファイルの移動
if exist public\ del /Q public\*
move app.html public\index.html

REM HTMLファイルの更新
setlocal enabledelayedexpansion
set "OLD=<!DOCTYPE html>"
set "NEW=<!DOCTYPE html><meta name='viewport' content='width=512' /><link rel='manifest' href='/manifest.json' /><script> if ('serviceWorker' in navigator) navigator.serviceWorker.register('/sw.js')</script>"
set "FILE=public\index.html"
set "TEMPFILE=%FILE%.tmp"

REM ファイルの置換
(
    for /f "tokens=*" %%a in ('type "%FILE%"') do (
        set "line=%%a"
        set "line=!line:%OLD%=%NEW%!"
        echo !line!
    )
) > "%TEMPFILE%"
move /Y "%TEMPFILE%" "%FILE%"

REM 静的ファイルのコピー
xcopy /Y static\* public\

REM 不要なファイルの削除
del app.pyxapp

REM サーバの起動
cd public
python -m http.server 8000
