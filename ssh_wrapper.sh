#!/bin/bash
set -e
echo ARGUMENTS:
echo $@

# Inputs:
# - whost
# - rundir
# - nodes
# - partition
# - ntasks_per_node
# - walltime

ssh_options="-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

f_read_cmd_args() {
    index=1
    args=""
    for arg in $@; do
	    prefix=$(echo "${arg}" | cut -c1-2)
	    if [[ ${prefix} == '--' ]]; then
	        pname=$(echo $@ | cut -d ' ' -f${index} | sed 's/--//g')
	        pval=$(echo $@ | cut -d ' ' -f$((index + 1)))
	        echo "export ${pname}=${pval}" >> $(dirname $0)/env.sh
	        export "${pname}=${pval}"
	    fi
        index=$((index+1))
    done
}

f_read_cmd_args $@

jobdir=$(basename $(dirname ${PWD}))

# CREATE INPUTS
mkdir -p ${PWD}/rsync_files
date > ${PWD}/rsync_files/hello.txt
hostname >> ${PWD}/rsync_files/hello.txt

# STAGE INPUTS FROM PW TO THE CLUSTER
echo; echo  STAGE INPUTS FROM PW TO THE CLUSTER
echo "rsync -avzq --rsync-path=\"mkdir -p ${rundir}/${jobdir} && rsync\" ${PWD}/rsync_files ${whost}:${rundir}/${jobdir}"
rsync -avzq --rsync-path="mkdir -p ${rundir}/${jobdir} && rsync" ${PWD}/rsync_files ${whost}:${rundir}/${jobdir}

# RUN SCRIPT ON THE CLUSTER
echo; echo RUN SCRIPT ON THE CLUSTER
ssh_args=$(echo $@ | sed "s/--/arg--/g")
echo "ssh ${ssh_options} ${whost} 'bash -s' < ./main_remote.sh ${ssh_args} arg--jobdir ${jobdir}"
ssh ${ssh_options} ${whost} 'bash -s' < ./main_remote.sh ${ssh_args} arg--jobdir ${jobdir}

# STAGE OUTPUTS FROM THE CLUSTER TO PW
echo; echo "rsync -avzq ${whost}:${rundir}/${jobdir}/rsync_files ${PWD}"
rsync -avzq ${whost}:${rundir}/${jobdir}/rsync_files ${PWD}

# PRINT OUTPUTS
cat ${PWD}/rsync_files/hello.txt