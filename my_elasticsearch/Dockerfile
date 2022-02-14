FROM docker.elastic.co/elasticsearch/elasticsearch:7.17.0

RUN groupadd -g 1010 archive
RUN usermod -a -G archive elasticsearch
RUN usermod -a -G archive root
RUN usermod -a -G elasticsearch root
