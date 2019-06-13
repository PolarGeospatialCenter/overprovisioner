FROM centos

RUN yum install -y hdparm

COPY overprovision.sh /bin/
RUN chmod a+x /bin/overprovision.sh

ENTRYPOINT ["/bin/overprovision.sh"]
