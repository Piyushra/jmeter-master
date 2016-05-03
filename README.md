# JMETER MASTER Container

<h3>Prerequisites:</h3>
<p>
1) Do the setup as on https://github.com/Piyushra/jmeter-slave </br>
2) Verify on the Marathon UI that the slaves are running properly. 
</p>

<h3> How to run the tests:</h3>
<p>
1) Copy the JMX files in the <code>scripts</code> folder.</br>
2) Build the Dockerfile using below command</br>
<code>docker build -t any_name_of_image .</code></br>
3) On the successful build, you can do the docker run with the below command. The JMX file should be from the <code>scripts</code> folder only as those files are copied with the <code>docker build</code> command, into the container. </br>
   <code> docker run -e INPUT_FILE_NAME=input_file_name.jmx -e OUTPUT_FILE_NAME=output_file_name.jtl -e MARATHON_SERVER=marathon_server_ip --net=weave -n -v absolute_host_path_to_store_the_logs_and_output:/logs <image-name>
   </code></br>
   (Note: The above steps should be done on the same mesos cluster on one of the VM's. Which means that your output file will be saved on the VM where you are running the above commands.)
</p>

