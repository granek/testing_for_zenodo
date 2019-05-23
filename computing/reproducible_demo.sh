DEMO_BASE="/tmp/reproducible_demo"
WORK_DIR="$DEMO_BASE/work"
DATA_DIR="$DEMO_BASE/data"
DOCKER_IMAGENAME="dukehtscourse/jupyter-hts-2019"

mkdir -p $WORK_DIR $DATA_DIR

echo "--------------------------------------------------"
echo "Pulling docker image: $DOCKER_IMAGENAME"
echo "--------------------------------------------------"
docker pull $DOCKER_IMAGENAME


echo "--------------------------------------------------"
echo "Downloading data from DDS"
echo "--------------------------------------------------"
~/.local/bin/ddsclient download -p HTS_course --include hts_2019_data/hts2019_pilot_rawdata/21_2019_P_M1_S21_L002_R1_001.fastq.gz $DATA_DIR


echo "--------------------------------------------------"
echo "Cloning repo from gitlab"
echo "--------------------------------------------------"
git clone https://gitlab.oit.duke.edu/hts2019/hts2019-notebooks.git $WORK_DIR/hts2019-notebooks


echo "--------------------------------------------------"
echo "Running Docker"
echo "--------------------------------------------------"
docker run -d -p 8888:8888 \
  -e PASSWORD="badpassword2983" \
  -v ${WORK_DIR}:/home/jovyan/work \
  -v ${DATA_DIR}:/data \
  -e NB_UID=1000 \
  $DOCKER_IMAGENAME
