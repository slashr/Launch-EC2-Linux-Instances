#!/bin/bash

#Instance Configuration Info
subnet_id=
key_name=keyname
key_path=/path/to/keyfile.pem

#AMI IDs
amazon_linux=
redhat_linux=
suse_linux=
ubuntu=

#Global Variables
distro=""
user=ec2-user

function launch {

		echo "Launching Instance"
                instance_id=$(aws ec2 run-instances --image-id $distro --instance-type t2.micro --subnet-id $subnet_id --key-name $key_name --associate-public-ip-address --output text | grep ^INSTANCES | cut -f 8)
                echo "Instance ID:" $instance_id
                sleep 5
                public_ip=$(aws ec2 describe-instances --instance-ids $instance_id --output text | grep ^INSTANCES | cut -f 15)
		echo "Public IP:" $public_ip
		echo "Connecting to Instance"
                sleep 20
		ssh -i $key_path $user@$public_ip
		aws ec2 terminate-instances --instance-ids $instance_id
}




echo -e "Choose a distribution \n1.Amazon \n2.RedHat \n3.SUSE \n4.Ubuntu"
read dist_choice


#AmazonLinux
if [ $dist_choice -eq 1 ]
	then
		distro=$amazon_linux
		launch

#RedHatLinux
elif [ $dist_choice -eq 2 ]
	then
		distro=$redhat_linux
		launch

#SUSELinux
elif [ $dist_choice -eq 3 ]
	then
		distro=$suse_linux
		launch

#Ubuntu
elif [ $dist_choice -eq 4 ]
	then
		distro=$ubuntu
		user=ubuntu
		launch

fi
