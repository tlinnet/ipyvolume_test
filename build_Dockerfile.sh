# To build this image, source the file

# Build user setup
docker build -t $USER/ipyvolume -f Dockerfile .
alias dv='docker run -ti --rm -p 8888:8888 -e DISPLAY=$(ifconfig|grep "inet "|grep -v 127.0.0.1|cut -d" " -f2):0 -v /tmp/.X11-unix:/tmp/.X11-unix -v "$PWD":/home/jovyan/work --name ipyvolume $USER/ipyvolume'
alias dve='docker exec -it ipyvolume'