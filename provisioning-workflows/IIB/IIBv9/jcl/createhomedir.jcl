//******************************************************************
//* Copyright Contributors to the zOS-Workflow Project.            *
//* PDX-License-Identifier: Apache-2.0                             *
//******************************************************************
//S1     EXEC OMVSBAT,SU=Y
//SYSIN   DD *
 mkdir ${instance-IIB_HOME_DIR}
 chmod 755 ${instance-IIB_HOME_DIR}
 chown ${instance-IIB_STCUSER}:${instance-IIB_STCGROUP} ${instance-IIB_HOME_DIR}
/*
//
