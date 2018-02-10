#!/bin/bash
SECONDS=0
# --------------------------------
if [ -z "$WHEREAMI" ]; then
    pushd .. > /dev/null
    export WHEREAMI=$PWD
    popd > /dev/null
fi
# --------------------------------
export JAVA_HOME=$(/usr/libexec/java_home -v1.8)
export DYLD_LIBRARY_PATH=/Applications/instantclient_11_2/
export ANT_HOME=$WHEREAMI/ant
export PATH=$PATH:$ANT_HOME/bin
export TOMCAT_HOME=$WHEREAMI/tomcat
export WEBAPPS=$TOMCAT_HOME/webapps
export JAVA_OPTS=
export CATALINA_OPTS="-Doracle.jdbc.autoCommitSpecCompliant=false"
echo -----------------------------
say "go"
case "$1" in
	'-?'|'-help'|'--help')
		echo "usage: go"
		echo "       compile and deploy nom"
		echo -----------------------------
		;;
	*)
		cd src/sql/
		sqlplus nom/n0mb8by@vm3 @nom.all.sql
		grep -e "LINE/COL ERROR" -e "ERROR at" nom.all.sql.err
		if [ $? = 1 ] ; then
			echo -----------------------------
			cd ../..
			unitTest > test.txt
			echo -----------------------------
			say "success"
		else
			say "fail"
		fi
		;;
esac
duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."