FROM centos:7

ENV USER dev_user
ENV HOME  /home/${USER}
ENV PYENV_ROOT ${HOME}/.pyenv
ENV PATH ${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:$PATH

# Install tools
RUN yum -y install epel-release \
    && yum -y update \
    && yum -y install git curl make zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl openssl-devel cmake patch gcc make autoconf libtool automake pkgconfig\
    yum -y autoremove &&\
    yum clean all &&\
    rm -rf /var/cache/yum

# User management
RUN useradd -m ${USER} &&\
    mkdir /var/www &&\
    chmod -R u+rw /var/www &&\
    chmod -R a+r /var/www

USER ${USER}
WORKDIR ${HOME}

# You could select any version available to pyenv:
ARG pythonversion=3.6.9
# RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python get-pip.py
RUN git clone git://github.com/yyuu/pyenv.git .pyenv \
    && pyenv install ${pythonversion} \
    && pyenv global ${pythonversion} \
    && pip install --upgrade pip \
    && pyenv rehash

CMD [ "bash" ]

