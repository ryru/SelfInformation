FROM openshift/base-centos7

...

EXPOSE 8080

...

# Install Java
RUN INSTALL_PKGS="tar unzip bc which lsof java-1.8.0-openjdk java-1.8.0-openjdk-devel" && \
    yum install -y $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y && \
    mkdir -p /opt/s2i/destination

USER 1001

# add application source

#ADD ./gradlew /opt/app-root/src/
#ADD gradle /opt/app-root/src/gradle
#ADD build.gradle /opt/app-root/src/
#ADD src /opt/app-root/src/src

ADD src /opt/app-root/src/src
ADD mvnw /opt/app-root/src/mvnw
ADD mvnw.cmd /opt/app-root/src/mvnw.cmd
ADD pom.xml /opt/app-root/src/pom.xml

# build
#RUN sh /opt/app-root/src/gradlew build
RUN sh /opt/app-root/src/mvnw package
# copy to correct location
RUN cp -a  /opt/app-root/src/target/self-information-0.0.1-SNAPSHOT.jar /opt/app-root/self-information-0.0.1-SNAPSHOT.jar
CMD java -Xmx64m -Xss1024k -jar /opt/app-root/self-information-0.0.1-SNAPSHOT.jar
