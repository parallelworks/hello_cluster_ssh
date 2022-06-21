#!/bin/bash

# arg--pname pvalue --> pname=pvalue
f_read_cmd_args() {
    index=1
    args=""
    rm -rf $(dirname $0)/env.sh
    echo $@
    for arg in $@; do
        prefix=$(echo "${arg}" | cut -c1-5)
	if [[ ${prefix} == 'arg--' ]]; then
	    pname=$(echo $@ | cut -d ' ' -f${index} | sed 's/arg--//g')
	    pval=$(echo $@ | cut -d ' ' -f$((index + 1)))
	    echo "export ${pname}=${pval}" >> $(dirname $0)/env.sh
	    export "${pname}=${pval}"
	fi
        index=$((index+1))
    done
}

f_read_cmd_args $@

# Print hostname of controller node
hostname >> ${rundir}/${jobdir}/rsync_files/hello.txt
# Print hostnames of compute nodes
echo "srun --nodes=${nodes}-${nodes} --partition=${partition} --ntasks-per-node=${ntasks_per_node} --exclusive hostname >> ${rundir}/${jobdir}/rsync_files/rsync_files/hello.txt"
srun --nodes=${nodes}-${nodes} --partition=${partition} --ntasks-per-node=${ntasks_per_node} --exclusive hostname >> ${rundir}/${jobdir}/rsync_files/hello.txt
