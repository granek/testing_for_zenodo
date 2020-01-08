# DEMO_BASE="/tmp/reproducible_demo"
# DATA_DIR="$DEMO_BASE/data"





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

