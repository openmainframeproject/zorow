#/bin/sh
zowe profiles set zosmf zpdt
bd="/u/er428h"
ls . | grep -i ZOS  \
     | awk {'print $1'}  \
     | while read line; 
        do zowe files ul ftu $line $bd/$line -b; 
      done