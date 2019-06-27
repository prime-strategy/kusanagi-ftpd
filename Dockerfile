FROM alpine:3.10
MAINTAINER kusanagi@prime-strategy.co.jp

RUN apk add --no-cache vsftpd \
&& addgroup -g 1000 kusanagi \
&& adduser -h /home/kusanagi -s /bin/false -u 1000 -G kusanagi -D kusanagi
COPY files/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY files/user_list /etc/vsftpd/user_list
COPY files/docker-entrypoint.sh /
EXPOSE 21 50021-50040

ARG MICROSCANNER_TOKEN
RUN if [ x${MICROSCANNER_TOKEN} != x ] ; then \
	apk add --no-cache --virtual .ca ca-certificates \
	&& update-ca-certificates\
	&& wget --no-check-certificate https://get.aquasec.com/microscanner \
	&& chmod +x microscanner \
	&& ./microscanner ${MICROSCANNER_TOKEN} || exit 1\
	&& rm ./microscanner \
	&& apk del --purge .ca ;\
    fi

CMD /docker-entrypoint.sh
