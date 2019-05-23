DEMO_BASE="/tmp/reproducible_demo"
WORK_DIR="$DEMO_BASE/work"
DATA_DIR="$DEMO_BASE/data"
DOCKER_IMAGENAME="dukehtscourse/jupyter-hts-2019"
MY_PASSWORD="BadPa55word"

mkdir -p $WORK_DIR $DATA_DIR

SEP_STRING="\n--------------------------------------------------\n"

printf "\n${SEP_STRING} Pulling docker image: $DOCKER_IMAGENAME ${SEP_STRING}"
docker pull $DOCKER_IMAGENAME


printf "\n${SEP_STRING} Downloading data from DDS ${SEP_STRING}"

~/.local/bin/ddsclient download -p HTS_course --include hts_2019_data/hts2019_pilot_rawdata/21_2019_P_M1_S21_L002_R1_001.fastq.gz $DATA_DIR


printf "\n${SEP_STRING} Cloning repo from gitlab ${SEP_STRING}"

git clone https://gitlab.oit.duke.edu/hts2019/hts2019-notebooks.git $WORK_DIR/hts2019-notebooks


printf "\n${SEP_STRING} Running Docker ${SEP_STRING}"
docker run -d -p 8888:8888 \
  -e PASSWORD=${MY_PASSWORD} \
  -v ${WORK_DIR}:/home/jovyan/work \
  -v ${DATA_DIR}:/data \
  -e NB_UID=1000 \
  $DOCKER_IMAGENAME

printf "\n${SEP_STRING} URL: http://localhost:8888/\n Password: ${MY_PASSWORD} ${SEP_STRING}"

printf "\n${SEP_STRING} To clean up: \n\n"
echo "rm -rf $DEMO_BASE"
echo "docker rm -f" `docker ps -aq`
echo "docker rmi" `docker images -aq`
printf "${SEP_STRING}\n"

