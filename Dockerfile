#
# Dockerfile for a jmeter master.
# A container from this image will be ready to run a jmeter master / jmeter client.
# 
# Usage:
#
#  docker 
#         run -e INPUT_FILE_NAME=<filename_which_is_added_in_scripts>.jmx 
#             -e OUTPUT_FILE_NAME=<any_output_filename>.jtl 
#             -e MARATHON_SERVER=<Marathon_server_ip> 
#             --net=weave 
#             -n -v <absolute path on host where the logs will created>:/logs 
#             <docker image name>

# TODO - The current recipe demands that the jmeter.properties used by jmeter-server image and
#        the one used by *this* image be in lock step; at least as far as the ports are concerned.
#        That seems icky.  Fix it, yo!
# TODO - Can't seem to get around hard coded JMeter version number in ENTRYPOINT.  Variable does
#        not get expanded (probably because it is in a string literal).

# Use jmeter-base as the foundation
FROM vaibhavja/jmeter-docker-base

MAINTAINER Piyush

# Describe the environment
ENV JMETER_VERSION 2.13

ENV JMETER_PATH /var/lib/apache-jmeter-2.13/bin/

# Create mount point for script, data and log files
VOLUME ["/scripts"]
VOLUME ["/logs"]

# Use a predefined configuration.  This sets the contract for connecting to jmeter servers.
ADD jmeter.properties /var/lib/apache-jmeter-2.13/bin/

COPY ModifyJmeterProps.sh /ModifyJmeterProps.sh

COPY MainScriptJmeter.sh /MainScriptJmeter.sh

# Provide all the JMX to the docker build
COPY scripts/*.jmx /scripts/

# Override this environment variable to give the JMX file name you want to run
ENV INPUT_FILE_NAME Default.jmx

# Override this environment variable to give the output file name (.jtl or anything) you want
ENV OUTPUT_FILE_NAME Default_output.jtl

# Override this environment variable if specific slaves are to be used instead of all (by default)
ENV REMOTE_COMMAND_MODE -r

# Always override this environment variable to get the Marathon server IP
ENV MARATHON_SERVER 0.0.0.0

ENTRYPOINT [ "/MainScriptJmeter.sh" ]
