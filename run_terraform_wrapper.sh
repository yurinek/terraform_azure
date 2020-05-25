#!/bin/bash

usage()
{
cat << EOF


usage: $0 options

This script creates takes arguments for app_name, vm_instances and environment and (if it doesnt exist) creates new directory for terraform variables and state files
In case directory and files exist, it only updates vm_instances (count for number of vms)
Additionaly ansible deploys on existing vms


OPTIONS:

   -a      app_name
   -e      Environment suffix e.g. p for appname-db-p01 or s for appname-db-s01
   -i      vm_instances (count for number of vms)
   -r      run terraform with eather plan or apply 

Example:
    
     $0 -a demoapp2 -e staging -i 2 -r plan
     $0 -a demoapp1 -e production -i 2 -r apply
     $0 -a demoapp1 -e staging -i 2 -r destroy
    
EOF
}

option_with_argument () {
	test "$OPTIND" -gt "$argc" && return 1
	if [ "${next:0:1}" = '-' ]; then
		return 1
	else
		return 0
	fi
}

argc=$#

while getopts a:e:i:r: opts; do
	case ${opts} in
        h)
          usage
          exit 1
          ;;
        a)
          APPNAME=$OPTARG
          ;;
        e)
          ENVIRONMENT=$OPTARG
          ;;
        i)
          INSTANCE_COUNT=$OPTARG
          ;;
        r)
          RUN=$OPTARG
          ;;
        ?)
          usage
          exit
          ;;
     esac
done

if [[ -z $APPNAME ]] || [[ -z $ENVIRONMENT ]] || [[ -z $INSTANCE_COUNT ]] || [[ -z $RUN ]]
then
     usage
     exit 1
fi

# find relative repository path, in order to work on each workstation
script=$(readlink -f "$0")
repo_path=$(dirname "$script")
ansible_repo=/home/yura/Documents/yuri_work/private_projects/devops/ansible/playbooks/postgres_in_docker
ansible_inventory_file=$ansible_repo/inventory_${ENVIRONMENT}/${APPNAME}_${ENVIRONMENT}
ansible_host_group_dir=$ansible_repo/group_vars/${APPNAME}_${ENVIRONMENT}

cd $repo_path

if [ ! -d ${APPNAME}_${ENVIRONMENT} ] ; then
  mkdir ${APPNAME}_${ENVIRONMENT}
fi

cd ${APPNAME}_${ENVIRONMENT}

if [ -f ${APPNAME}_${ENVIRONMENT}.tfvars ] ; then
   echo "######################### ${APPNAME}_${ENVIRONMENT}.tfvars already exists - skipping creation"
else
   echo "######################### Creating ${APPNAME}_${ENVIRONMENT}.tfvars file from environment template..."
   cp ../.templates/${ENVIRONMENT}.tfvars ${APPNAME}_${ENVIRONMENT}.tfvars
fi

sed -i "s/APPNAMEPLACEHOLDER/$APPNAME/g" ${APPNAME}_${ENVIRONMENT}.tfvars


cd $repo_path
sleep 1

# in case "$RUN = apply" run it twice in order to get output of public ips

if [ "$RUN" = "apply" ]; then
  run_times="2";
  autoapprove="-auto-approve"
else
  run_times="";
  autoapprove=""
fi

if [ "$RUN" = "destroy" ]; then
  run_times="";
  autoapprove="-auto-approve"
fi

for i in $(seq 1 $run_times) ; do
  echo "######################### terraform run number: $i"
  # only use command line vars which can vary inside the same app + env
  terraform $RUN $autoapprove -var-file="../terraform.tfvars" -var-file="${APPNAME}_${ENVIRONMENT}/${APPNAME}_${ENVIRONMENT}.tfvars" -state="${APPNAME}_${ENVIRONMENT}/${APPNAME}_${ENVIRONMENT}.state" -var="app_name=$APPNAME" -var="vm_instances=$INSTANCE_COUNT" 2>&1 | tee -a /tmp/terraform_${RUN}.log
done


if [ "$RUN" = "apply" ]; then
  # create ansible inventory
  echo "######################### Hand over public ips to ansible" #(works only if var public_ip_address is the last variable in file outputs.tf) 
  echo "[${APPNAME}_${ENVIRONMENT}]" > $ansible_inventory_file
  terraform output -state="${APPNAME}_${ENVIRONMENT}/${APPNAME}_${ENVIRONMENT}.state" |grep -A 100 public_ip_address |grep -E [0-9.] >> $ansible_inventory_file
  sed -i "s/,//g" $ansible_inventory_file
  sed -i "s/\"//g" $ansible_inventory_file
  echo "[${APPNAME}_${ENVIRONMENT}:vars]
ansible_user=ansible
[all_apps_hosts_${ENVIRONMENT}:children]
${APPNAME}_${ENVIRONMENT} 
" >> $ansible_inventory_file
  
  # create ansible host_group
  mkdir -p $ansible_host_group_dir/vars
  cp $ansible_repo/.templates/main.yml $ansible_host_group_dir/vars

  cd $ansible_repo
  echo "###################### Beginning with ansible run..."
  sleep 2
  ansible-playbook -i inventory_${ENVIRONMENT}/${APPNAME}_${ENVIRONMENT} main.yml

fi

if [ "$RUN" = "destroy" ]; then
  echo "######################### Remove ansible inventory file & host_group as for this app+env no vms remain"
  rm $ansible_inventory_file
  rm -r $ansible_host_group_dir
  echo "######################### Remove terraform ${APPNAME}_${ENVIRONMENT} directory as for this app+env no vms remain"
  rm -r ${APPNAME}_${ENVIRONMENT}
fi




