FROM ubuntu:22.04

ENV IS_DOCKER=true

COPY .config/ /root/.config/
COPY setup.sh /root

RUN /bin/bash -c "sed -i -e 's/\r$//' ~/setup.sh; ~/setup.sh"

WORKDIR /root

CMD [ "/bin/bash" ]
