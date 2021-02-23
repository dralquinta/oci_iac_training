#Author: DALQUINT - denny.alquinta@oracle.com
#Purpose: This script encapsulates the creation logic of an environment
#Copyright (c) 2021, Oracle and/or its affiliates. All rights reserved.


if [ "$#" -ne 1 ]; then
    echo "Missing system to create. Usage: ./destroy_environment.sh SYSTEMNAME"
else

#Terraform execution
echo 'Executing with terrform version:' $(terraform --version)

    if [[ -d ./$1 ]]; then 

        echo "=================== EXECUTING TERRAFORM ======================="
        cd $1
        for (( k=1; k<=5; k++ ))
        do  
            
            echo "--- Executing terraform init (pass $k of 5)" 
            terraform init            
            if [ $? == 0 ]; then 
                STATE_TERRAFORM_INIT="true"
                break ; 
            fi

            echo "--- Error in terraform init. Retrying terraform init in 10 seconds."
            sleep 10
        done

                for (( k=1; k<=5; k++ ))
        do  
            
            echo "--- Executing terraform validate (pass $k of 5)"        
            terraform validate
       
            if [ $? == 0 ]; then 
                STATE_TERRAFORM_INIT="true"
                break ; 
            fi

            echo "--- Error in terraform validate. Retrying terraform init in 10 seconds."
            sleep 10
        done

                for (( k=1; k<=5; k++ ))
        do  
            
        echo "--- Executing terraform destroy (pass $k of 5)" 
            terraform destroy --var-file=../commons.tfvars --var-file=system.tfvars 
            if [ $? == 0 ]; then 
                STATE_TERRAFORM_INIT="true"
                break ; 
            fi

            echo "--- Error in terraform retry. Retrying terraform init in 10 seconds."
            sleep 10
        done

        
    else 
        echo 'System does not exist. Try again'
    fi

#Ansible execution

fi