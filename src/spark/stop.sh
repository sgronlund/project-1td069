#!/usr/bin/bash
#

num_of_container=$(sudo docker ps | wc -l)
((num_of_container--))

if [[ $num_of_container -gt 0 ]]; then
	sudo docker kill $(sudo docker ps | awk '{print $1}' | tail -n $num_of_container)
fi

