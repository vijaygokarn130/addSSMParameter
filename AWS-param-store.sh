   
#1. Script adds environment vraiables with the parameter_name as: /project/env/parameter_name
#   hence change script variables as per need.
#2. Save environment variables within file named vars.txt
#3. environment variables and its values should be seperated by spaces and NOT = symbol
# ex: 
#     name1   val1
#     name2   val2
#4. command line: ./AWS-param-store.sh {env} {add / delete}
###########################################################################

declare -r env=${1:?"$(echo "FATAL pass an environment")"}
declare -r aws_profile=${4:-GIVE_YOUR_PROFILE}
declare -r project="delta/BGTR"
declare -r command=${2:?"$(echo "FATAL YOU WANT TO "add" OR "delete" PARAMETERS ?")"}

function add_parameters {
 #add parameter one by one
while IFS=" " read -r parameter_name parameter_value;
do
    aws ssm put-parameter --name "/${project}/${env}/$parameter_name" --value $parameter_value --type SecureString --key-id "alias/aws/ssm" --profile ${aws_profile}

done < vars.txt

}

function delete_parameters {
  #deletes parameter one by one
while IFS=" " read -r parameter_name parameter_value;
do
    aws ssm delete-parameter --name "/${project}/${env}/$parameter_name" --profile ${aws_profile}
done < vars.txt
}


function overwrite_parameters {
  #deletes parameter one by one
while IFS=" " read -r parameter_name parameter_value;
do
    aws ssm put-parameter --name "/${project}/${env}/$parameter_name" --value $parameter_value --type SecureString  --overwrite --profile ${aws_profile}
done < vars.txt
}


case $command in
    "add") add_parameters
           ;;
    "delete") delete_parameters
           ;;
    "overwrite") overwrite_parameters
           ;;
esac
