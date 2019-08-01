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
                        setfacl -m group:${instance-SYSPROG_RACF_GROUP}:rwx "$fname"
                        setfacl -m user:${instance-ZOSMF_INSTALL_USER}:rwx "$fname"

                elif [[ -d "$fname" ]] ; then
                        savedir=$(pwd)
                        setfacl -m group:${instance-SYSPROG_RACF_GROUP}:rwx "$fname"
                        setfacl -m user:${instance-ZOSMF_INSTALL_USER}:rwx "$fname"
                        setfacl -m f:group:${instance-SYSPROG_RACF_GROUP}:rwx   ./ 
                        setfacl -m f:user:${instance-ZOSMF_INSTALL_USER}:rwx   ./

                        cd "$fname"
                        dodir $savedir/$fname
                        cd "$savedir"
                fi
        done
        return
}

fname2=/plex/var/mqsi/brokers/${instance-IIB_BROKER_NAME_LC}/
cd $fname2 && \
dodir $(pwd)
setfacl -m group:${instance-SYSPROG_RACF_GROUP}:rwx ./           
setfacl -m d:group:${instance-SYSPROG_RACF_GROUP}:rwx   ./       

setfacl -m user:${instance-ZOSMF_INSTALL_USER}:rwx ./           
setfacl -m d:user:${instance-ZOSMF_INSTALL_USER}:rwx   ./

exit 0

