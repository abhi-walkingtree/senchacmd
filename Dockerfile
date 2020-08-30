FROM openjdk:8-jre-alpine

RUN apk update && apk upgrade && apk --update add \
    ruby build-base libstdc++ tzdata bash ttf-dejavu freetype fontconfig wget curl git

WORKDIR /opt/DDOUI
RUN git clone https://github.com/abhi-walkingtree/ddoui.git
RUN wget http://cdn.sencha.com/cmd/6.7.0.63/no-jre/SenchaCmd-6.7.0.63-linux-amd64.sh.zip -O senchacmd.zip && unzip senchacmd.zip && rm senchacmd.zip && chmod +x SenchaCmd-6.7.0.63-linux-amd64.sh
RUN ./SenchaCmd-6.7.0.63-linux-amd64.sh -q -dir /opt/Sencha/Cmd/6.7.0.63 -Dall=true
RUN rm SenchaCmd-6.7.0.63-linux-amd64.sh && chmod +x /opt/Sencha/Cmd/6.7.0.63/sencha


RUN ln -s /opt/sencha/sencha /usr/local/bin/sencha
RUN apk add nginx
RUN service nginx start
WORKDIR /opt/DDOUI/ddoui
RUN /opt/Sencha/Cmd/6.7.0.63/sencha app build production
RUN cp -r /opt/DDOUI/ddoui/build/production/DDO /usr/share/nginx/html
EXPOSE 80

