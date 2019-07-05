//S1     EXEC USSBATCH,SU=Y
//STDOUT  DD SYSOUT=*
//STDERR  DD SYSOUT=*
//* create directories if they do not yet exist
//* then create symbolic link
//SYSIN   DD *
mkdir -p /${instance-IIB_PLEX}5${instance-IIB_WORK_DIR_SYMLINK} 
mkdir -p /${instance-IIB_PLEX}6${instance-IIB_WORK_DIR_SYMLINK} 

ls -alF /${instance-IIB_PLEX}5${instance-IIB_WORK_DIR_SYMLINK}                               
ls -alF /${instance-IIB_PLEX}6${instance-IIB_WORK_DIR_SYMLINK}                               
ln -s ${instance-IIB_WORK_DIR} /${instance-IIB_PLEX}5${instance-IIB_WORK_DIR_SYMLINK}   
ln -s ${instance-IIB_WORK_DIR} /${instance-IIB_PLEX}6${instance-IIB_WORK_DIR_SYMLINK}   
ls -alF /${instance-IIB_PLEX}5${instance-IIB_WORK_DIR_SYMLINK} 
ls -alF /${instance-IIB_PLEX}6${instance-IIB_WORK_DIR_SYMLINK} 
/*
