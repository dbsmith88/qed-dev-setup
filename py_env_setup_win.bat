@ECHO OFF

SET qed_name=qed-dev
SET py_ver=3.7
SET qed_env=%qed_name%_%py_ver%
SET req_file=requirements.txt

SET anaconda_path=%anaconda_path%
IF "%anaconda_path%" == "" (
	SET anaconda_path=C:\ProgramData\Anaconda3
	ECHO anaconda_path environment variable not set, using default instead.
)
ECHO Anaconda path: %anaconda_path%
SET path=%path%;%anaconda_path%\Library\bin;%anaconda_path%\Scripts

ECHO QED Python Development Environment: %qed_env%
ECHO Python Version: %py_ver%
SET /P update=Update or Create? (u/c):

IF /I %update% EQU c (
	ECHO Creating conda environment...
	ECHO y | conda create --name %qed_env% python=%py_ver%
	ECHO Conda environment %qed_env% created
) ELSE (
	ECHO Updating conda environment...
)
ECHO Activating %qed_env% environment for package updates
call conda.bat activate %qed_env%

git clone https://github.com/quanted/requirements_qed.git
CD requirements_qed
git checkout dev
git pull

ECHO Installing/Updating python packages from quanted/requirements_txt
FOR /F "tokens=1" %%r IN (%req_file%) DO (
	pip install %%r
)

cd ..
rm -rf "./requirements_qed/"

ECHO ------------------------------------------------------
ECHO Installing required packages that need direct install.
SET gdal_wheel=GDAL-2.3.3-cp37-cp37m-win_amd64.whl
SET fiona_wheel=Fiona-1.8.6-cp37-cp37m-win_amd64.whl 

pip install git+https://github.com/celery/celery.git#egg=celery --upgrade
pip install %gdal_wheel% --upgrade
pip install %fiona_wheel% --upgrade
pip install numpy --upgrade
pip install geopandas --upgrade
pip install redis --upgrade
call conda deactivate

ECHO Update completed.
ECHO Use Conda environment by running "conda activate %qed_env%"
