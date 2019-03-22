#!/bin/bash
# QED Python Conda Environment Development setup

qed_name="qed-dev"
py_ver=3.7
qed_env="$qed_name"_"$py_ver"
req_file="./requirements.txt"

echo "QED Python Development Environment: $qed_env"
echo "Python Version: $py_ver"
echo "Update or Create? (u/c):" 
read update
if test "$update" = "c"
then
   echo "Creating conda environment..."
   echo y | conda create --name $qed_env python=$py_ver
   echo "Conda environment $qed_env created"
else
   echo "Updating conda environment..."
fi 

echo "Activating $qed_env environment for package updates"
source activate $qed_env

git clone https://github.com/quanted/requirements_qed.git
cd requirements_qed
git checkout dev
git pull

while IFS= read -r req
do
   pip install $req
done <$req_file

cd ..
rm -rf ./requirements_qed

echo "---------------------------------------------------"
echo "Installing required packages that need direct install."
pip install git+https://github.com/celery/celery.git#egg=celery
echo y | conda install gdal
echo y | conda install fiona
echo y | conda install numpy
echo y | conda install geopandas
conda deactivate

echo "Update completed."
echo "Use Conda environment by running 'conda activate $qed_env'"
