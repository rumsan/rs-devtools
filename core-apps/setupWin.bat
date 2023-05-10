@echo off

REM Set environment variables

:NAME
set /p NAME="Enter your name (lowercase only): "
set "valid_name=0"
echo %NAME%| findstr /r /c:"^[abcdefghijklmnopqrstuvwxyz]*$" >nul && set "valid_name=1" 
if "%valid_name%"=="0" (
  echo Invalid name! Please enter a name containing only lowercase letters.
  goto NAME
)

:PASSWORD
set /p PASSWORD="Enter your password (only text and numbers): "
set "valid_password=0"
echo %PASSWORD%| findstr /r /c:"^[a-zA-Z0-9]*$" >nul && set "valid_password=1"
if "%valid_password%"=="0" (
  echo Invalid password! Please enter a password with only text and numbers.
  goto PASSWORD
)

:EMAIL
set /p EMAIL="Enter your email: "
set "valid_email=0"
echo %EMAIL%| findstr /r /c:"@.*\." >nul && set "valid_email=1"
if "%valid_email%"=="0" (
  echo Invalid email! Please enter a valid email address.
  goto EMAIL
)

:MNEMONIC
set /p MNEMONIC="Enter your mnemonic: "
set "valid_mnemonic=0"
(for %%a in (%MNEMONIC%) do set /a valid_mnemonic+=1)>nul
if "%valid_mnemonic%"=="12" (
  echo Valid mnemonic.
) else (
  echo Invalid mnemonic! Please enter exactly 12 words.
  goto MNEMONIC
)

set /p DROPBOX_PORT="Enter the port number for Dropbox (default 3400): " || set DROPBOX_PORT=3400
set /p IPFS_PORT="Enter the port number for IPFS (default 4444): " || set IPFS_PORT=4444
set /p PGADMIN_PORT="Enter the port number for PgAdmin (default 4445): " || set PGADMIN_PORT=4445
set /p GANACHE_PORT="Enter the port number for Ganache (default 8545): " || set GANACHE_PORT=8545
set /p MONGOEX_PORT="Enter the port number for MongoExpress (default 4446): " || set MONGOEX_PORT=4446

REM Create data folder if it doesn't exist
if not exist "volumes" mkdir "volumes"

REM Create subfolders inside data folder
if not exist "volumes/ganache" mkdir "volumes/ganache"
if not exist "volumes/ipfs/data" mkdir "volumes/ipfs\data"
if not exist "volumes/ipfs/ipfs" mkdir "volumes/ipfs\ipfs"
if not exist "volumes/ipfs/ipns" mkdir "volumes/ipfs\ipns"
if not exist "volumes/mongodb" mkdir "volumes/mongodb"
if not exist "volumes/pgadmin" mkdir "volumes/pgadmin"
if not exist "dropbox" mkdir "dropbox"

echo Generating .env file...
echo NAME=%NAME%> .env
echo PASSWORD=%PASSWORD%>> .env
echo EMAIL=%EMAIL%>> .env
echo MNEMONIC=%MNEMONIC%>> .env
echo DROPBOX_PORT=%DROPBOX_PORT%>> .env
echo IPFS_PORT=%IPFS_PORT%>> .env
echo PGADMIN_PORT=%PGADMIN_PORT%>> .env
echo GANACHE_PORT=%GANACHE_PORT%>> .env
echo MONGOEX_PORT=%MONGOEX_PORT%>> .env

echo .env file created successfully!

echo Downloading docker-compose.yml file...
curl -o docker-compose.yml https://raw.githubusercontent.com/rumsan/rs-devtools/main/local-dockers/docker-compose.yml

echo Starting Docker containers...
docker-compose up -d

del setupWin.bat