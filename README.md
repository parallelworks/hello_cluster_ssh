# Hello Cluster SSH
Sample workflow using SSH to:
1. Copy the directory `./rsync_files` from PW to the remote cluster with `rsync`
2. Running a script `./main_remote.sh` on the remote cluster
3. Copying the directory `./rsync_files` back from the remote custer to PW with `rsync`

The remote cluster must use Slurm


### Inputs:
All inputs are defined in the workflow's input form and passed all the way to the `./main_remote.sh` script.

1. **Workflow host**: Host for the `ssh` and `rsync` commands. Can have the format `User@IpAddress` or `PoolName.clusters.pw` (if the pool is a PW cluster).
2. **Run directory**: Path to the work directory on the remote cluster
3. **Number of nodes**: Parameter of the srun command in the  `./main_remote.sh`
4. **Partition**: Parameter of the srun command in the  `./main_remote.sh`
5. **Tasks per node**: Parameter of the srun command in the  `./main_remote.sh`

```
srun --nodes=${nodes}-${nodes} --partition=${partition} --ntasks-per-node=${ntasks_per_node} --exclusive hostname >> ${rundir}/${jobdir}/rsync_files/hello.txt

```

### Outputs:
Updated contents of the `./rsync_files` directory