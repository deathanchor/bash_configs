#!/bin/bash

hostFile=~/.ssh/known_hosts
removeBad=0
verbose=0

usage="
$0 [-f <hostfile>] [-r] [-v]
	This will find mismatching ssh known_hosts keys and remove them.
	-f <hostfile> - file to scan and modify if using -r
	-r - remove mismatching host keys from file
	-v - verbose, includes printing OK host keys
"

while getopts 'f:rvh' opt; do
	case $opt in
		f)
			hostFile=$OPTARG
			;;
		r)
			removeBad=1
			;;
		v)
			verbose=1
			;;
		h)
			echo $usage
			exit
			;;
	esac
done

shift $((OPTIND-1))

for host in `ssh-keygen -l -f $hostFile | cut -d' ' -f3 | cut -d, -f1 | grep -v '^\W'`; do
	eval ssh $host -o 'StrictHostKeyChecking=yes' -o 'PasswordAuthentication=no' \\exit 2>&-
	if [[ $? != 0 ]]; then
		eval ssh $host -o 'StrictHostKeyChecking=yes' -o 'PasswordAuthentication=no' -o 'ConnectTimeout=5' \\exit 2>&1 | grep -e 'Permission denied' -e 'timed out' 1>&-
		if [[ $? == 0 ]]; then
			echo $host : Could not connect with ssh key
			continue
		fi
		if [[ $removeBad == 1 ]]; then
			ssh-keygen -R $host -f $hostFile
			echo $host : removed host key from $hostFile
		else
			echo $host : host key mismatch found in $hostFile
		fi
	elif [[ $verbose == 1 ]]; then
		echo $host : host key matches OK
	fi
done

# Niko The Dread Pirate (@deathanchor)
