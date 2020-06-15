#!/bin/sh
###############################################################################
# Copyright Contributors to the zOS-Workflow Project.
# PDX-License-Identifier: Apache-2.0
#
# WebSphere Application Server liberty Provision script
#
# ----------------------------------------------------------------------------
#

create()
{
    export WLP_USER_DIR="${instance-WLP_USER_DIR}"
    export JAVA_HOME="${instance-JAVA_HOME}"
	export WLP_INSTALL_DIR="${instance-WLP_INSTALL_DIR}"
	export WLP_SERVER_NAME="${_workflow-softwareServiceInstanceName}"

	export LOG_DIR="$WLP_USER_DIR/servers/$WLP_SERVER_NAME/logs"
	export WLP_OUTPUT_DIR="$WLP_USER_DIR/servers"



	# Create the server
	$WLP_INSTALL_DIR/bin/server create $WLP_SERVER_NAME
}

configure()
{
    export JAVA_HOME="${instance-JAVA_HOME}"
	export WLP_INSTALL_DIR="${instance-WLP_INSTALL_DIR}"
	export WLP_USER_DIR="${instance-WLP_USER_DIR}"
	export WLP_SERVER_NAME="${_workflow-softwareServiceInstanceName}"

	iconv -f IBM-1047 -t ISO8859-1 $WLP_USER_DIR/servers/$WLP_SERVER_NAME/server.xml > $WLP_USER_DIR/servers/$WLP_SERVER_NAME/server.xml.tmp
	mv $WLP_USER_DIR/servers/$WLP_SERVER_NAME/server.xml.tmp $WLP_USER_DIR/servers/$WLP_SERVER_NAME/server.xml
	chtag -t -c iso8859-1 $WLP_USER_DIR/servers/$WLP_SERVER_NAME/server.xml

	# Create server.env file with JAVA_HOME
	echo "JAVA_HOME=$JAVA_HOME" >$WLP_USER_DIR/servers/$WLP_SERVER_NAME/server.env
	echo "_BPX_JOBNAME=${_workflow-softwareServiceInstanceName}" >> $WLP_USER_DIR/servers/$WLP_SERVER_NAME/server.env

	# Set permissions
	chmod 775 $WLP_USER_DIR
	chmod 775 $WLP_USER_DIR/servers
	chmod 775 $WLP_USER_DIR/servers/$WLP_SERVER_NAME
}

configureDatasource()
{
    export JAVA_HOME="${instance-JAVA_HOME}"
	export WLP_INSTALL_DIR="${instance-WLP_INSTALL_DIR}"
	export WLP_USER_DIR="${instance-WLP_USER_DIR}"
	export WLP_SERVER_NAME="${_workflow-softwareServiceInstanceName}"

    export LOG_DIR="$WLP_USER_DIR/servers/$WLP_SERVER_NAME/logs"
	export WLP_OUTPUT_DIR="$WLP_USER_DIR/servers"

	iconv -f IBM-1047 -t ISO8859-1 $WLP_USER_DIR/servers/$WLP_SERVER_NAME/datasource.xml > $WLP_USER_DIR/servers/$WLP_SERVER_NAME/datasource.xml.tmp
	mv $WLP_USER_DIR/servers/$WLP_SERVER_NAME/datasource.xml.tmp $WLP_USER_DIR/servers/$WLP_SERVER_NAME/datasource.xml
	chtag -t -c iso8859-1 $WLP_USER_DIR/servers/$WLP_SERVER_NAME/datasource.xml

	# Create db2jcc.properties file
	echo "db2.jcc.ssid=${instance-DB2_REGISTRY_NAME}" > $WLP_USER_DIR/servers/$WLP_SERVER_NAME/db2jcc.properties

	# Create jvm.options file pointing to db2jcc.properties
	echo "-Ddb2.jcc.propertiesFile=$WLP_USER_DIR/servers/$WLP_SERVER_NAME/db2jcc.properties" > $WLP_USER_DIR/servers/$WLP_SERVER_NAME/jvm.options

	# Add STEPLIB datasets to server.env
	echo "STEPLIB=${instance-DB2_HLQ}.SDSNEXIT:${instance-DB2_HLQ}.SDSNLOAD:${instance-DB2_HLQ}.SDSNLOD2" >> $WLP_USER_DIR/servers/$WLP_SERVER_NAME/server.env

	# Add datasource properties to bootstrap
	echo "\nbootstrap.include=./datasource.properties" >> $WLP_USER_DIR/servers/$WLP_SERVER_NAME/bootstrap.properties
}

removeDatasource()
{
    export JAVA_HOME="${instance-JAVA_HOME}"
	export WLP_INSTALL_DIR="${instance-WLP_INSTALL_DIR}"
	export WLP_USER_DIR="${instance-WLP_USER_DIR}"
	export WLP_SERVER_NAME="${_workflow-softwareServiceInstanceName}"

    export LOG_DIR="$WLP_USER_DIR/servers/$WLP_SERVER_NAME/logs"
	export WLP_OUTPUT_DIR="$WLP_USER_DIR/servers"

	# Remove db2jcc.properties
	if [ -e  "$WLP_USER_DIR/servers/$WLP_SERVER_NAME/db2jcc.properties" ]; then
        rm "$WLP_USER_DIR/servers/$WLP_SERVER_NAME/db2jcc.properties"
    fi

    # Remove jvm.options
    if [ -e  "$WLP_USER_DIR/servers/$WLP_SERVER_NAME/jvm.options" ]; then
        rm "$WLP_USER_DIR/servers/$WLP_SERVER_NAME/jvm.options"
    fi

    #Remove STEPLIB datasets from server.env
    sed '/STEPLIB/d' $WLP_USER_DIR/servers/$WLP_SERVER_NAME/server.env > $WLP_USER_DIR/servers/$WLP_SERVER_NAME/server.env.tmp
	mv $WLP_USER_DIR/servers/$WLP_SERVER_NAME/server.env.tmp $WLP_USER_DIR/servers/$WLP_SERVER_NAME/server.env

    #Remove datasource.xml
    if [ -e  "$WLP_USER_DIR/servers/$WLP_SERVER_NAME/datasource.xml" ]; then
        rm "$WLP_USER_DIR/servers/$WLP_SERVER_NAME/datasource.xml"
    fi

    # Remove datasource.properties
	if [ -e  "$WLP_USER_DIR/servers/$WLP_SERVER_NAME/datasource.properties" ]; then
        rm "$WLP_USER_DIR/servers/$WLP_SERVER_NAME/datasource.properties"
    fi

    # Remove datasource properties from bootstrap
    sed '/bootstrap.include/d' $WLP_USER_DIR/servers/$WLP_SERVER_NAME/bootstrap.properties > $WLP_USER_DIR/servers/$WLP_SERVER_NAME/bootstrap.properties.tmp
	mv $WLP_USER_DIR/servers/$WLP_SERVER_NAME/bootstrap.properties.tmp $WLP_USER_DIR/servers/$WLP_SERVER_NAME/bootstrap.properties
}

configureKeystore()
{
    export JAVA_HOME="${instance-JAVA_HOME}"
	export WLP_INSTALL_DIR="${instance-WLP_INSTALL_DIR}"
	export WLP_USER_DIR="${instance-WLP_USER_DIR}"
	export WLP_SERVER_NAME="${_workflow-softwareServiceInstanceName}"

    export LOG_DIR="$WLP_USER_DIR/servers/$WLP_SERVER_NAME/logs"
	export WLP_OUTPUT_DIR="$WLP_USER_DIR/servers"

	iconv -f IBM-1047 -t ISO8859-1 $WLP_USER_DIR/servers/$WLP_SERVER_NAME/keystore.xml > $WLP_USER_DIR/servers/$WLP_SERVER_NAME/keystore.xml.tmp
	mv $WLP_USER_DIR/servers/$WLP_SERVER_NAME/keystore.xml.tmp $WLP_USER_DIR/servers/$WLP_SERVER_NAME/keystore.xml
	chtag -t -c iso8859-1 $WLP_USER_DIR/servers/$WLP_SERVER_NAME/keystore.xml

}

configureServerProc()
{

	# Copy the wlp bbgzsrv.jcl template proc into a tmp file
	cp ${instance-WLP_INSTALL_DIR}/templates/zos/procs/bbgzsrv.jcl ${instance-WLP_USER_DIR}/servers/${_workflow-softwareServiceInstanceName}/${_workflow-softwareServiceInstanceName}.jcl.tmp

	# Edit proc template
	sed "s#BBGZSRV PROC#${_workflow-softwareServiceInstanceName} PROC#" ${instance-WLP_USER_DIR}/servers/${_workflow-softwareServiceInstanceName}/${_workflow-softwareServiceInstanceName}.jcl.tmp | sed "s#USERDIR='/u/MSTONE1/wlp/usr'#USERDIR='${instance-WLP_USER_DIR}'#" | sed "s#INSTDIR='/u/MSTONE1/wlp'#INSTDIR='${instance-WLP_INSTALL_DIR}'#" > ${instance-WLP_USER_DIR}/servers/${_workflow-softwareServiceInstanceName}/${_workflow-softwareServiceInstanceName}.jcl

	if [ "${instance-DB2_HLQ}" != "" -a "${instance-DB2_HLQ}" != "DB2_HLQ" ]; then
	    echo "//STEPLIB  DD DISP=SHR,DSN=${instance-DB2_HLQ}.SDSNEXIT" >> ${instance-WLP_USER_DIR}/servers/${_workflow-softwareServiceInstanceName}/${_workflow-softwareServiceInstanceName}.jcl
	    echo "//         DD DISP=SHR,DSN=${instance-DB2_HLQ}.SDSNLOD2" >> ${instance-WLP_USER_DIR}/servers/${_workflow-softwareServiceInstanceName}/${_workflow-softwareServiceInstanceName}.jcl
        echo "//         DD DISP=SHR,DSN=${instance-DB2_HLQ}.SDSNLOAD" >> ${instance-WLP_USER_DIR}/servers/${_workflow-softwareServiceInstanceName}/${_workflow-softwareServiceInstanceName}.jcl

	fi
	# Add comments to proc
	echo "//*------------------------------------------------------------------" >> ${instance-WLP_USER_DIR}/servers/${_workflow-softwareServiceInstanceName}/${_workflow-softwareServiceInstanceName}.jcl
	echo "//* This proc has been created via wlp server cloud provisioning and " >> ${instance-WLP_USER_DIR}/servers/${_workflow-softwareServiceInstanceName}/${_workflow-softwareServiceInstanceName}.jcl
	echo "//* will be removed when the server is deprovisioned.                " >> ${instance-WLP_USER_DIR}/servers/${_workflow-softwareServiceInstanceName}/${_workflow-softwareServiceInstanceName}.jcl
	echo "//*------------------------------------------------------------------" >> ${instance-WLP_USER_DIR}/servers/${_workflow-softwareServiceInstanceName}/${_workflow-softwareServiceInstanceName}.jcl

	rm ${instance-WLP_USER_DIR}/servers/${_workflow-softwareServiceInstanceName}/${_workflow-softwareServiceInstanceName}.jcl.tmp
}

startServer()
{

	export JAVA_HOME="${instance-JAVA_HOME}"
	export WLP_INSTALL_DIR="${instance-WLP_INSTALL_DIR}"
	export WLP_USER_DIR="${instance-WLP_USER_DIR}"
	export WLP_SERVER_NAME="${_workflow-softwareServiceInstanceName}"

	# Start the server
	nohup $WLP_INSTALL_DIR/bin/server start $WLP_SERVER_NAME

	started=0
	count=0
	while [ $started = 0 -a $count -le 25 ]
	do
	    # Search for start message in message.log
	    if [ $(grep -c "CWWKF0011I" $WLP_USER_DIR/servers/$WLP_SERVER_NAME/logs/console.log) = 1 ]
	    then
	    	started=1
	    else
	    	count=$(expr $count + 1)
	    	sleep 5
	    fi
	done

	if [ $started = 0 ]; then
	    echo "The server has not started in the expected time. Check the logs for errors."
	    exit 1
	fi
}

stopServer()
{
	export JAVA_HOME="${instance-JAVA_HOME}"
	export WLP_INSTALL_DIR="${instance-WLP_INSTALL_DIR}"
	export WLP_USER_DIR="${instance-WLP_USER_DIR}"
	export WLP_SERVER_NAME="${_workflow-softwareServiceInstanceName}"

	# Stop the server if running
	status=$($WLP_INSTALL_DIR/bin/server status $WLP_SERVER_NAME)
	if [ $(echo "$status" | grep -c "is running") = 1 ]
	then
	    $WLP_INSTALL_DIR/bin/server stop $WLP_SERVER_NAME
	    stopped=0
	    count=0
	    while [ $stopped = 0 -a $count -le 25 ]
		do
	    	# Search for start message in message.log
	    	if [ $(grep -c "CWWKF0011I" $WLP_USER_DIR/servers/$WLP_SERVER_NAME/logs/console.log) = 1 ]
	    	then
	    		stopped=1
	    	else
	    		count=$(expr $count + 1)
	    		sleep 5
	    	fi
		done

		if [ $stopped = 0 ]; then
	    	echo "The server has not stopped in the expected time. The process will be killed."
	    	kill -9 `cat $WLP_USER_DIR/servers/.pid/$WLP_SERVER_NAME.pid`
		fi
	fi


}

case "$1" in

    #Create a new Liberty server
	"--create")
	    shift
	    create "$@"
	;;

	#Start the server
	"--start")
	    shift
	    startServer "$@"
	;;

	#Stop the server
	"--stop")
	    shift
	    stopServer "$@"
	;;

    #Configure the DB2 datasource
    "--configureDatasource")
        shift
        configureDatasource "$@"
    ;;

    #Configure server
    "--configure")
        shift
        configure "$@"
    ;;

    #Configure keystore
    "--configureKeystore")
        shift
        configureKeystore "$@"
    ;;

    #Configure server proc
    "--configureServerProc")
        shift
        configureServerProc "$@"
    ;;

    #Remove DB2 Bind
    "--removeDatasource")
        shift
        removeDatasource "$@"
    ;;

esac
