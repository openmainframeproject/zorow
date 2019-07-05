//S1     EXEC USSBATCH,SU=Y
//STDOUT  DD SYSOUT=*
//STDERR  DD SYSOUT=*
//SYSIN   DD *
#!/bin/sh
# gaat recursief door directories vanaf startpunt, slaat links over
# reageert ook goed op spaties in directory namen
function dodir
{
        typeset fname savedir
        ls | while read "fname" ; do
                if [[ -L "$fname" ]] ; then
                        echo 'skipped link '  "$fname"
                elif [[ -f "$fname" ]] ; then
                        setfacl -m user:${instance-IIB_TIV_USER}:r-- "$fname"
            elif [[ -d "$fname" ]] ; then
                        savedir=$(pwd)
                        setfacl -m user:${instance-IIB_TIV_USER}:r-x "$fname"
                        setfacl -m d:user:${instance-IIB_TIV_USER}:r-x "$fname"
                        cd "$fname"
                        dodir $savedir/$fname
                        cd "$savedir"
                fi
        done
        return
}
fname2=/plex/var/mqsi/brokers/${instance-IIB_BROKER_NAME_LC}/registry
cd $fname2   &&  dodir $(pwd)
setfacl -m user:${instance-IIB_TIV_USER}:r-x ./
setfacl -m d:user:${instance-IIB_TIV_USER}:r-x ./
exit 0
