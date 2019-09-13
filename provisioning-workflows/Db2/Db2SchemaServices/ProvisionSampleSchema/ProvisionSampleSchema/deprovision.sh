# Define base paths.
export DESP_JAR=/u/devops/schprovlike/SchemaProvisioningService/
export JAVA_HOME=/usr/lpp/java/java800/J8.0_64
export JDBC_HOME=/usr/lpp/db2/db2v12/jdbc
export RACF_HOME=/usr/include/java_classes
# Export path and classpath.
export CLASSPATH=.:$CLASSPATH
export CLASSPATH=$CLASSPATH:$RACF_HOME/IRRRacf.jar
export CLASSPATH=$CLASSPATH:$RACF_HOME/IRRRacfDoc.jar
export CLASSPATH=$CLASSPATH:$JDBC_HOME/classes/db2jcc4.jar
export CLASSPATH=$CLASSPATH:$JDBC_HOME/classes/db2jcc_license_cisuz.jar
export CLASSPATH=$CLASSPATH:$DESP_JAR/DeprovisionService.jar
export PATH=$PATH:$JAVA_HOME/bin
export LIBPATH=.:/lib:/usr/lib:$LIBPATH
# Run Java program.
exec "$JAVA_HOME/bin/java" -cp "$CLASSPATH" DeprovisionService "$@"
