FROM centos

#RUN apk add --no-cache hdparm gawk bash
RUN yum install -y hdparm

COPY overprovision.sh /bin/
RUN chmod a+x /bin/overprovision.sh

ENTRYPOINT /bin/overprovision.sh
