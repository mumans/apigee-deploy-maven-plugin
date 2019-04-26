FROM jenkins/jnlp-slave

USER root

# Make sure the package repository is up to date.
RUN apt-get update && apt-get -y upgrade

# Install GIT
RUN apt-get install -y git sudo

# passwordless sudo for Jenkins
RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/jenkins

# Install pip for python2 and others packages
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py && \
    rm get-pip.py && \
    pip install awscli boto3

ENV TERRAFORM_VERSION 0.11.13
ENV PACKER_VERSION latest

# Make sure the package repository is up to date.
RUN sudo apt-get update && sudo apt-get -y upgrade


RUN git clone https://github.com/kamatama41/tfenv.git ~/.tfenv && \
    sudo ln -s ~/.tfenv/bin/* /usr/local/bin && \
    tfenv install ${TERRAFORM_VERSION} && \
    # packer
    git clone https://github.com/iamhsa/pkenv.git ~/.pkenv && \
    sudo ln -s ~/.pkenv/bin/* /usr/local/bin && \
    pkenv install ${PACKER_VERSION} && \
    # ansible
    sudo pip install ansible

RUN terraform -v && ansible --version && packer -v

RUN sudo apt-get install maven -y

# cleanup
RUN sudo apt-get -qy autoremove

USER jenkins
ENV USER jenkins