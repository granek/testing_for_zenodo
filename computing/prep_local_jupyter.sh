set -u
TARGET_DIR=`readlink -f ${1:-"hts2018"}`
GIT_METHOD=${2:-"https"}

if [ $# -lt 1 ]; then
  echo "Usage: $0 TARGET_DIR [GIT_CLONE_METHOD]"
  echo "       TARGET_DIR: parent directory for downloading data and repos (required)."
  echo "       GIT_CLONE_METHOD: Use 'ssh' or 'https' for cloning git repos (default: 'https')."
  exit
fi

WORK_DIR=$TARGET_DIR/jovyan/work
DATA_DIR=$TARGET_DIR/data/hts2018_pilot
JUPYTER_DIR=$TARGET_DIR/jupyter-HTS-2018
NOTEBOOK_DIR=$WORK_DIR/HTS2018-notebooks

rm -rf $NOTEBOOK_DIR $JUPYTER_DIR
mkdir -p $WORK_DIR $DATA_DIR
# JUPYTER_PASSWORD="dklf8FHidsah98gdpoadjsf"

DownloadData() {
    # Get data subset
    # https://unix.stackexchange.com/a/76242
    # rsync  -avvzC --include="*/" --include='*.checksum' --include='35_MA_*.fastq.gz' --include='27_MA_*.fastq.gz' --exclude="*" vcm3:/tmp/hts2018/Granek_4837_180427A5 $DATA_DIR
    rsync  -avvzC --include="*/" --include='*.checksum' --include='35_MA_*.fastq.gz' --exclude="*" vcm3:/tmp/hts2018/Granek_4837_180427A5 $DATA_DIR
    # md5sum -vc Granek_4837_180427A5/Granek_4837_180427A5.checksum 
    # md5sum -vc Granek_4837_180427A5/Granek_4837_180427A5.checksum | grep -v open
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


# Build Jupyter Docker Image
BuildImage() {
    if [ $GIT_METHOD == "ssh" ] ; then
	echo "Cloning jupyter-HTS-2018.git with ssh"
	JUPYTER_GIT="git@gitlab.oit.duke.edu:HTS2018/jupyter-HTS-2018.git"
    else
	echo "Cloning jupyter-HTS-2018.git with https"
	JUPYTER_GIT="https://gitlab.oit.duke.edu/HTS2018/jupyter-HTS-2018.git"
    fi
    git clone $JUPYTER_GIT $JUPYTER_DIR
    docker build -t mccahill/jupyter-hts-2018 $JUPYTER_DIR
}

PullImage() {
    docker pull mccahill/jupyter-hts-2018
}

RunImage() {
    DOCKER_IMAGE="jupyter-hts-2018"
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

