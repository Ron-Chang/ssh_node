FROM python:3.8-slim-buster
LABEL maintainer="Ron Chang<ron.hsien.chang@gmail.io>"

# Env
ENV ENV="/root/.bashrc"
ENV PYTHON_CONFIGURE_OPTS --enable-shared
# - Set LC_* to C.UTF-8
ENV LC_ALL C.UTF-8
# - Avoid interaction
ARG DEBIAN_FRONTEND=noninteractive
# - Install Directory
WORKDIR /root

# Install prerequisite
RUN apt update
# - Essential
RUN apt install -y ssh sudo rsync curl wget git
# - Optional
# -- Compile
RUN apt install -y make cmake
# -- To run add-apt-repository
RUN apt install -y software-properties-common
# - Tools
# -- internet
RUN apt install -y iputils-ping net-tools
# -- better vim
RUN add-apt-repository ppa:neovim-ppa/stable
RUN apt install -y neovim
RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Create Login User
ARG USERNAME
# add user
RUN useradd $USERNAME -s /bin/bash
# generate 8 random (regex: [\w\d]{8}) password and SAVE to $HOME dir
RUN tr -cd "[:alnum:]" < /dev/urandom \
	| fold -w8 \
	| head -n1 \
	| tee password \
	| xargs -i echo ${USERNAME}:{} \
	| chpasswd
# grant sudo permission
RUN usermod -G sudo ${USERNAME}
# sudo no-password required
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> "/etc/sudoers.d/${USERNAME}"

# Launch SSH automatically
ENTRYPOINT service ssh restart && bash

# Display message if no command override
CMD ["sh", "-c", "echo $(date +'%Y-%m-%d %T') [c] No Service! specify your COMMAND in compose file; sh"]
