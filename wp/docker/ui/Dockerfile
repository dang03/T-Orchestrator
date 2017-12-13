FROM ubuntu

MAINTAINER Josep Batallé "josep.batalle@i2cat.net"
#docker run -itd -p 8080:8080 tnova/ui

ENV MS_NAME dashboard
ENV MS_FOLDER orchestrator_mgt-gui
ENV MS_PORT 8080

# Update aptitude with new repo
RUN apt-get update

# Install software
RUN apt-get install -y git openjdk-7-jdk maven nodejs-legacy npm

RUN npm install bower -g

# Make ssh dir
RUN mkdir /root/.ssh/

# Copy over private key, and set permissions
ADD id_rsa /root/.ssh/id_rsa

# Create known_hosts
RUN touch /root/.ssh/known_hosts

# Add bitbuckets key
RUN ssh-keyscan stash.i2cat.net >> /root/.ssh/known_hosts
RUN ssh-keyscan -p 7999 stash.i2cat.net >> /root/.ssh/known_hosts

# Clone the conf files into the docker container
RUN git init /srv/$MS_NAME && cd /srv/$MS_NAME && git remote add -f origin ssh://git@stash.i2cat.net:7999/TNOV/wp3.git && git config core.sparseCheckout true && echo $MS_FOLDER >> .git/info/sparse-checkout && git pull origin master

EXPOSE $MS_PORT

#RUN cd /srv/$MS_NAME/WP3/$MS_FOLDER/ && bundle install && rake db:migrate && rake db:seed && rake start

RUN cd /srv/$MS_NAME/WP3/$MS_FOLDER/ && bower install --allow-root --config.interactive=false && mvn install -DskipTests

WORKDIR /srv/$MS_NAME/WP3/$MS_FOLDER
ENTRYPOINT ["mvn", "jetty:run"]
