FROM meteor/ubuntu:20210720 as meteor_builder
SHELL ["/bin/bash", "-c"]

RUN useradd -ms /bin/bash mt
USER mt
WORKDIR /home/mt

ENV NVM_DIR /home/mt/.nvm
ENV NODE_VERSION 14.19.3
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:/home/mt/.meteor:$PATH

# Install nvm with node and npm
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.39.0/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && npm install -g @rocket.chat/apps-cli

RUN rc-apps --version

USER root
WORKDIR /app
RUN git clone https://github.com/sampaiodiego/rocket.chat.app-poll.git
RUN git clone https://github.com/croz-ltd/Rocket.Chat.App-Remind.git
RUN git clone https://github.com/RocketChat/Apps.Jitsi.git
RUN git clone https://github.com/RocketChat/Apps.ClamAV.git

WORKDIR /app/rocket.chat.app-poll
RUN npm i
WORKDIR /app/Rocket.Chat.App-Remind
RUN npm i
WORKDIR /app/Apps.Jitsi
RUN npm i
WORKDIR /app/Apps.ClamAV
RUN npm i

#rc-apps deploy --url https://binchat2.workcec.com --username root --password Heatmob123