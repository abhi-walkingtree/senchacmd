FROM java:8-jre as builder
RUN echo "deb [check-valid-until=no] http://cdn-fastly.deb.debian.org/debian jessie main" > /etc/apt/sources.list.d/jessie.list
RUN echo "deb [check-valid-until=no] http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list
RUN sed -i '/deb http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list
RUN echo "Acquire::Check-Valid-Until \"false\";" > /etc/apt/apt.conf.d/100disablechecks

RUN apt-get update && \
    apt-get install -y curl ruby unzip git npm
    WORKDIR /opt/DDOUI
RUN git clone https://github.com/abhi-walkingtree/ddoui.git
RUN wget http://cdn.sencha.com/cmd/6.7.0.63/no-jre/SenchaCmd-6.7.0.63-linux-amd64.sh.zip -O senchacmd.zip && unzip senchacmd.zip && rm senchacmd.zip && chmod +x SenchaCmd-6.7.0.63-linux-amd64.sh
RUN ./SenchaCmd-6.7.0.63-linux-amd64.sh -q -dir /opt/Sencha/Cmd/6.7.0.63 -Dall=true
RUN rm SenchaCmd-6.7.0.63-linux-amd64.sh && chmod +x /opt/Sencha/Cmd/6.7.0.63/sencha


RUN ln -s /opt/sencha/sencha /usr/local/bin/sencha
WORKDIR /opt/DDOUI/ddoui
RUN /opt/Sencha/Cmd/6.7.0.63/sencha app build production
#### RUN cp -r /opt/DDOUI/ddoui/build/production/DDO/ /usr/share/nginx/html
FROM nginx
COPY --from=builder /opt/DDOUI/ddoui/build/production/DDO/ /usr/share/nginx/html