## New Kid on the block

Docker is the new kid on the block, and it has absolutely changed the way every tech company writes their code, builds their infrastructure, to even how they form their teams. While it's _not_ a VM (Virtual Machine), I find it best to think of it as if it were a VM. (For more info on what it really is, see [this](https://www.docker.com/what-docker))

In the past, if you were a Mac/Windows user, you had to run it inside a VM. For Linux, and now Mac, this is not the case. For how to use docker in your particular OS see [this](https://www.docker.com/products/overview).

## Containers vs Images
This question is sure to come up, and it might be confusing. Container's are running instances of an image. So an image is a snapshot of your container, and a container is what the image becomes when you boot it up.

Images can be created, modified and pushed --much like a GIT repository. You can also build an image with a _Dockerfile_. This file is a set of instructions that tell the operating system what to do. This is basically just bash commands that create files, install programs, defines paths and environment variables, manages networking, etc. More information [here](https://docs.docker.com/engine/reference/builder/#/dockerfile-examples).

## DockerHub
Dockerhub.com is the docker equivelent to github.com. Except instead of code versioned with git, you have servers versioned in docker. You can even checkout specific SHA commits or tags just like you can in git!

You can set up a dockerhub repo in two different ways. You can use the default method and push to dockerhub directly, or (my favorite) connect to a git repository that has a Dockerfile and build the image automatically.

## Hello World
Starting off simple.

`$ docker run alpine /bin/echo 'hello'`

Word for word: <br>
`docker` is the executable. <br>
`run` is the docker command, <br>
`alpine` is the image. <br>
`/bin/echo` is the executable inside the container and <br>
`'hello'` is an argument being passed to that executable.

## Example service
After installing docker you can try to build an image with this really simple echo server.

1) Clone
`$ git clone git@github.com:alairock/python-docker-example.git`

2) `$ cd python-docker-example`

3) `$ docker build . -t exampy`<br>
as you will probably learn
