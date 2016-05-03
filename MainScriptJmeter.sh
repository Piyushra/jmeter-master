#!/bin/bash

# Owner: Piyush Rakhunde

# The main script file which does the following 2 things:
#       1) Updates the jmeter.properties file with the VM's available
#       2) Runs the Jmeter bash file with the arguments

echo "Updating the Jmeter Properties with the latest VM's....."

# Calling to ModifyJmeterProps.sh
bash /ModifyJmeterProps.sh

# Set the Arguments for the Jmeter bash file
DEFAULT_ARG="-n -t /scripts/"${INPUT_FILE_NAME}" -l /logs/"${OUTPUT_FILE_NAME}" "${REMOTE_COMMAND_MODE}

echo Remote Command Mode: ${REMOTE_COMMAND_MODE}

# Run the Jmeter Bash file
bash ${JMETER_PATH}/jmeter $DEFAULT_ARG

# Echo the file names produced
echo Input File Name: ${INPUT_FILE_NAME}
echo Output File Name: ${OUTPUT_FILE_NAME} 
