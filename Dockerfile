FROM ubuntu

RUN apt-get update
RUN apt-get -y install wget pulseaudio

# audio video related setup
RUN echo enable-shm=no >> /etc/pulse/client.conf
RUN groupadd -f -g 1000 game
RUN adduser --uid 1000 --gid 1000 --disabled-login --gecos 'Game' game

ENV DISPLAY=:0
ENV PULSE_SERVER /run/pulse/native

RUN apt-get install -y libsdl2-dev libpng-dev gettext libboost-all-dev libalut-dev libsndfile-dev libglew-dev libphysfs-dev libsdl2-image-dev libsdl2-ttf-dev librsvg2-bin xmlstarlet po4a
RUN apt-get install -y git

RUN mkdir -p /usr/local/share/games
RUN cd /usr/local/share/games && git clone --recursive https://github.com/colobot/colobot.git

RUN mkdir -p /usr/local/share/games/colobot/build
WORKDIR /usr/local/share/games/colobot/build

RUN apt-get install -y cmake

RUN cmake ..
RUN make
RUN make install

# store local game data
ADD .colobot /home/game/.local/share/colobot
RUN chown -R game:game /home/game/.local/share/colobot

USER game

CMD /usr/local/share/games/colobot/build/colobot
