def rds_start_stop(def rdsClusterName, def regionName, def actionName) {
    sh """#!/bin/bash
        echo "DB Cluster Name:" $rdsClusterName
        status=''
        flag=0
        pp="\$(aws rds describe-db-clusters --region $regionName --db-cluster-identifier $rdsClusterName | jq '.DBClusters[].Status')"
        if [ '"$actionName"' = '"start"' ];
        then
            status='"available"'
            if [ "\$pp" = '"starting"' ] || [ "\$pp" = '"available"' ];
            then
                echo "RDS is already in available state"
            else
                aws rds start-db-cluster --region $regionName --db-cluster-identifier $rdsClusterName
            fi
        elif [ '"$actionName"' = '"stop"' ];
        then
            status='"stopped"'
            if [ "\$pp" = '"stopping"' ] || [ "\$pp" = '"stopped"' ];
            then
                echo "RDS is already in stopped state"
            else
                aws rds stop-db-cluster --region $regionName --db-cluster-identifier $rdsClusterName
            fi
        fi
        for i in {1..90}
        do
            flag=1
            pp="\$(aws rds describe-db-clusters --region $regionName --db-cluster-identifier $rdsClusterName | jq '.DBClusters[].Status')"
            if [ "\$pp" = "\$status" ];
            then
                echo "RDS is \$status"
                echo "RDS updated successfully"
                flag=0
                break;
            fi
            echo "Count: \$i , Max Count: 90"
            echo "DesiredState = \$pp"
            echo "Sleeping for 90 sec more..."
            sleep 90s
        done
        if [ \$flag -eq 1 ];
        then
            echo "Step 1 cluster $actionName time out..."
            exit 1
        fi
    """
}

def ec2_start_stop(def ec2Name, def regionName, def actionName) {
    sh """#!/bin/bash
        declare -a instance_id
        instance_id=\$(aws ec2 describe-instances --region ${regionName} --filters "Name=tag:Name,Values=${ec2Name}" --query 'Reservations[].Instances[].InstanceId' --output text)
        echo \$instance_id                                                                               
        if [ -z "\$instance_id" ]
        then
            echo "Not Instance found"
        else
            aws ec2 "${actionName}"-instances --region ${regionName} --instance-ids \$instance_id
            if [ "${actionName}" == "stop" ]
            then
                aws ec2 wait instance-stopped --region ${regionName} --instance-ids \$instance_id
            else
                aws ec2 wait instance-status-ok --region ${regionName} --instance-ids \$instance_id
            fi
        fi
    """
}

boolean isProjectAsgRunningAlready(regionName, projectName) {
    def query = "aws autoscaling describe-auto-scaling-groups --region ${regionName} --auto-scaling-group-name dev-${projectName} --query 'AutoScalingGroups[*].DesiredCapacity' --output text | awk '{print(\$1)}'"
    def count = sh(returnStdout: true, script: query).trim()
    if ((count as int) > 0) {
        print("Running ASG instances: " + count)
        return true
    }
    return false
}

pipeline {
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr: '7', artifactNumToKeepStr: '7'))
        disableConcurrentBuilds()
    }
    triggers {
        parameterizedCron('''
            30 16 * * 1,2,3,4,5,6,7 %Action=stop;Environment=non-prod
            30 03 * * 1,2,3,4,5 %Action=start;Environment=non-prod
        ''')
    }
    parameters {
        choice(name: 'Action', choices: ['stop', 'start'], description: 'Choose Action')
        choice(name: 'Environment', choices: ['non-prod'], description: 'Choose Environment')
    }
    environment {
        REGION = "us-east-1"
        DEFAULT_ENVIRONMENT = "non-prod"
        PROJECT = "aspen"
    }
    stages {
        stage("Setting Build Info") {
            steps {
                wrap([$class: 'BuildUser']) {
                    script {
                        def userName = (env.BUILD_USER == "null" || env.BUILD_USER == null) ? "Jenkins" : env.BUILD_USER
                        currentBuild.displayName = "#${params.Environmdevent}-#${currentBuild.number}"
                        currentBuild.description = "Action: ${params.Action} \n Build By: ${userName}"
                    }
                }
            }
        }
        stage("Parallel Common Service") {
            when {
                expression {
                    if ("${params.Action}" == "stop") {
                        return !isProjectAsgRunningAlready("${env.REGION}", "${env.PROJECT}")
                    } else {
                        return true
                    }
                }
            }
            parallel {



                stage("RDS-Database") {
                    steps {
                        script {
                            rds_start_stop("${env.DEFAULT_ENVIRONMENT}-${env.PROJECT}-mysql-dl65um", "${env.REGION}", "${params.Action}")
                        }
                    }
                }
            }
        }
    }
}