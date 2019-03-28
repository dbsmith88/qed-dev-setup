### QED Development Environment Setup README
#### Updated: 03/28/2019
------------------------------------------------------------------------------------------------

##### Requirements:
* Anaconda - https://www.anaconda.com/distribution/#download-section
* GDAL Windows Binary (WINDOWS ONLY)- https://www.lfd.uci.edu/~gohlke/pythonlibs/#gdal
	- GDAL-2.3.3-cp37-cp37m-win_amd64.whl (placed in the py_env_setup directory)
* Fiona Windows Binary (WINDOWS ONLY)- https://www.lfd.uci.edu/~gohlke/pythonlibs/#fiona 
	- Fiona-1.8.6-cp37-cp37m-win_amd64.whl (placed in the py_env_setup directory)
* REDIS - https://redis.io/download
    - (WINDOWS) install into Program Files directory
* MONGODB - https://www.mongodb.com/download-center/community
    - (WINDOWS) install into Program Files directory

##### Description:
py_env_setup_win.bat uses Anaconda3 to create a python conda environment (for Windows) that can be used for 
QED development. Intention is to replicate the qed_py3 base python environment used in production
for development purposes and testing. Differences between production and normal development are,
1) production uses docker containers (running linux debian os)
2) web servers are aws/azure
cloud environments.

Prior to executing the script run the command 'conda init TERMINAL', where TERMINAL is 
the current command line interface. Then restart the TERMINAL and execute the script. 
Common TERMINAL options are: 'cmd.exe', 'bash' and 'powershell'.

##### WINDOWS
Steps: 
1) install anaconda
2) install redis and mongodb
3) execute py_env_setup_win.bat
4) execute stack_setup.ps1,
5) execute run_stack.bat

The py_env_setup_win.bat script will create a conda environment called "qed-dev_3.7" that can
django, flask and celery. There may be some requirement issues that can be fixed by updating 
PATH and making sure that Anaconda is installed for the user, instead of the system. 

After executing the script, you will be prompted whether you want to create or update the conda
env. After initially creating the env, we will only need to update as necessary.

After completing the conda env setup and have redis and mongodb installed, run stack_setup.ps1.
This script will prompt you for 2 values, the previously created/updated conda env name and
the location of the flask_qed directory to run celery. If Redis and MongoDB are properly installed
in Program Files, the script should be able to find them and set the correct ENV variables for the
.exe files. If not, you can manually set the ENVS as follows:
REDIS_PATH = the location of the redis-server.exe executable
MONGODB_PATH = the location of the mongod.exe executable

To locally run the stack, you will need to run django and flask (can be done and debugged from pycharm),
and execute run_stack.bat (which will run redis, mongodb, and celery). To use HMS features, also run
quanted\hms.git repo through an IDE, like Visual Studio 2017 or Visual Studio Code.

##### Linux\MacOS
Run py_env_setup_linux.sh, which only requires Anaconda to be installed and the shell initialized.

run_stack.sh is in development...

##### pyCharm
Alternatively, pyCharm contains a feature that allows external tools to be run from inside the IDE.
Under File > Settings > Tools > External Tools, click the + icon. Fill in name and description, use the following (WINDOWS example):

| tool | program | arguments | working directory |
| ---- | ---- | ---- |---- |
| Celery | C:\Users\\%USERNAME%\\.conda\envs\qed-dev_3.7\Libs\Scripts\celery.exe | worker -A celery_cgi -Q qed --loglevel=DEBUG -c 2 -n qed_worker | C:\git\qed\flask_qed |
| Redis | C:\Program Files\Redis\redis-server.exe |  | C:\Program Files\Redis |
| MongoDB | C:\Program Files\MongoDB\Server\3.4\bin\mongod.exe |  | C:\Program Files\MongoDB\Server\3.4\bin |


Now, under Tools > External Tools, each of your added external tools will be listed. Clicking on them will execute the tool and provide the output to the run console. Multiple tools can be run in parallel, along with python run/debug configurations.
