//S1     EXEC USSBATCH,SU=Y
//SYSIN   DD *
#!/bin/sh
# setfacl recursief vanaf startpunt, slaat links over
# reageert ook goed op spaties in directory namen
function dodir
{
        typeset fname savedir
        ls | while read "fname" ; do
                if [[ -L "$fname" ]] ; then
                        echo 'skipped link '  "$fname"
                elif [[ -f "$fname" ]] ; then
                        setfacl -m user:${instance-IIB_PRD_USER}:r-- "$fname"
                elif [[ -d "$fname" ]] ; then
                        savedir=$(pwd)
                        setfacl -m user:${instance-IIB_PRD_USER}:r-x "$fname"
                        cd "$fname"
                        dodir $savedir/$fname
                        cd "$savedir"
                fi
        done
        return
}
cd /plex/var/mqsi/brokers/${instance-IIB_BROKER_NAME_LC}/registry && dodir $(pwd)
setfacl -m user:${instance-IIB_PRD_USER}:r-x ./
setfacl -m default:user:${instance-IIB_PRD_USER}:5 ./
setfacl -m fdefault:user:${instance-IIB_PRD_USER}:4 ./
cd /plex/var/mqsi/brokers/${instance-IIB_BROKER_NAME_LC}/common && dodir $(pwd)
setfacl -m user:${instance-IIB_PRD_USER}:r-x ./
setfacl -m default:user:${instance-IIB_PRD_USER}:5 ./
setfacl -m fdefault:user:${instance-IIB_PRD_USER}:4 ./
cd /plex/var/mqsi/brokers/${instance-IIB_BROKER_NAME_LC}/components && dodir $(pwd)
setfacl -m fdefault:user:${instance-IIB_PRD_USER}:4 ./
setfacl -m user:${instance-IIB_PRD_USER}:r-x ./
cd /plex/var/mqsi/brokers/${instance-IIB_BROKER_NAME_LC}/locks && dodir $(pwd)
setfacl -m fdefault:user:${instance-IIB_PRD_USER}:4 ./
setfacl -m user:${instance-IIB_PRD_USER}:r-x ./
cd /plex/var/mqsi/brokers/${instance-IIB_BROKER_NAME_LC}/common/log/
setfacl -m user:${instance-IIB_PRD_USER}:rwx ./
setfacl -m user:${instance-IIB_PRD_USER}:5 /u/miscuser/${instance-IIB_BROKER_NAME_LC}u/
setfacl -m user:${instance-IIB_PRD_USER}:5 /u/miscuser/${instance-IIB_BROKER_NAME_LC}u/ENVFILE
setfacl -m fdefault:user:${instance-IIB_PRD_USER}:6 ./
setfacl -m user:${instance-IIB_PRD_USER}:rwx ./
exit 0
