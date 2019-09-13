//S1     EXEC OMVSBAT,SU=Y
//SYSIN   DD *
 cd /var/mqsi/brokers && \
 rm ${instance-IIB_BROKER_NAME_LC}
/*
//