set -u
TARGET_DIR=`readlink -f ${1:-"/tmp/reproducible_demo"}`
GIT_METHOD=${2:-"https"}

if [ $# -lt 1 ]; then
  echo "Usage: $0 TARGET_DIR [GIT_CLONE_METHOD]"
  echo "       TARGET_DIR: parent directory for downloading data and repos (required)."
  echo "       GIT_CLONE_METHOD: Use 'ssh' or 'https' for cloning git repos (default: 'https')."
  exit
fi

WORK_DIR=$TARGET_DIR/jovyan/work
DATA_DIR=$TARGET_DIR/data
JUPYTER_DIR=$TARGET_DIR/jupyter-HTS-2018
NOTEBOOK_DIR=$WORK_DIR/HTS2019-notebooks
DOCKER_IMAGENAME="dukehtscourse/jupyter-hts-2019"
MY_PASSWORD="BadPa55word"

SEP_STRING="\n--------------------------------------------------\n"


rm -rf $NOTEBOOK_DIR $JUPYTER_DIR
mkdir -p $WORK_DIR $DATA_DIR
# JUPYTER_PASSWORD="dklf8FHidsah98gdpoadjsf"

DownloadData() {
    # Get data subset
    printf "\n${SEP_STRING} Downloading data from DDS ${SEP_STRING}"

    ddsclient download -p HTS_course --include hts_2019_data/hts2019_pilot_rawdata/21_2019_P_M1_S21_L002_R1_001.fastq.gz $DATA_DIR

}

DownloadNotebooks() {

    if [ $GIT_METHOD == "ssh" ] ; then
	echo "Cloning HTS2018-notebooks.git with ssh"
	NOTEBOOK_URL="git@gitlab.oit.duke.edu:HTS2018/HTS2018-notebooks.git"
    else
	echo "Cloning HTS2018-notebooks.git with https"
	NOTEBOOK_URL="https://gitlab.oit.duke.edu/HTS2018/HTS2018-notebooks.git"
    fi
    git clone $NOTEBOOK_URL $NOTEBOOK_DIR
}


PullImage() {
    printf "\n${SEP_STRING} Pulling docker image: $DOCKER_IMAGENAME ${SEP_STRING}"
    docker pull $DOCKER_IMAGENAME
}

RunImage() {
    JUPYTER_PORT="9999"
    SESSION_INFO_FILE="session_info_${DOCKER_IMAGE}_${JUPYTER_PORT}.txt"
    echo $SESSION_INFO_FILE
    # export JUPYTER_PASSWORD="`shuf -zer -n20  {A..Z} {a..z} {0..9}`"
    export JUPYTER_PASSWORD=`shuf -zer -n30  {A..Z} {a..z} {0..9}`
    # export JUPYTER_PASSWORD="blahblahblah123994t7"
    printf "\n\nJupyter URL should be one of the following.\n" > $SESSION_INFO_FILE
    printf "If running on your local machine, it will be:\n"  >> $SESSION_INFO_FILE
    printf "\t\thttps://localhost:${JUPYTER_PORT}/\n" >> $SESSION_INFO_FILE
    printf "\nIf running on a server, e.g. Duke VCM, it should be:\n"  >> $SESSION_INFO_FILE
    printf "\t\thttps://`hostname -A`:${JUPYTER_PORT}/\n" | tr -d ' ' >> $SESSION_INFO_FILE
    printf "\nJupyter Username:\t$USER\n"  >> $SESSION_INFO_FILE
    printf "Jupyter Password:\t$JUPYTER_PASSWORD\n" >> $SESSION_INFO_FILE

    cat $SESSION_INFO_FILE
    trap "{ rm -f $SESSION_INFO_FILE; }" EXIT

    # singularity run  --app rstudio $BIND_ARGS $SINGULARITY_IMAGE --auth-none 0 --auth-pam-helper rstudio_auth --www-port $JUPYTER_PORT
    echo "docker run --name ${DOCKER_IMAGE} \
      -e USE_HTTPS=yes \
      -d -p ${JUPYTER_PORT}:8888 \
      -e PASSWORD="$JUPYTER_PASSWORD" \
      -v $(dirname ${DATA_DIR}):/data \
      -v ${WORK_DIR}:/home/jovyan/work \
      -e NB_UID=1000 \
      mccahill/${DOCKER_IMAGE}" > $TARGET_DIR/run_${DOCKER_IMAGE}.sh
    bash $TARGET_DIR/run_${DOCKER_IMAGE}.sh
}

# # Clone Notebook Repo

if [ $GIT_METHOD == "ssh" ] ; then
    echo "Downloading FASTQs"
    DownloadData
else
    echo "Cannot download FASTQs without proper ssh key"
fi


DownloadNotebooks
# BuildImage
PullImage
RunImage

