FROM amazonlinux:2022
RUN ulimit -n 1024 && yum -y update && yum -y install \
python3 \
python3-pip \
python3-devel \
zip \
&& yum clean all

RUN python3 -m pip install pip==22.1.2
RUN python3 -m pip install virtualenv==20.14.1