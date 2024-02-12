read -r -p "Enter the environment (non-prod/prod) you want to run: " env
set -e

rm -rf .terraform
if [ "${env}" == "non-prod" ] || [ "${env}" == "prod" ]; then
	terraform init
	terraform workspace list
	terraform workspace select "${env}"
	terraform init
	terraform fmt --recursive
	terraform apply
else
	echo "Please enter correct environment"
fi
