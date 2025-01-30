#!/bin/zsh

# Prompt user to select a service
echo "Select a service:"
echo "1. auth"
echo "2. task"
echo "3. integration"
# shellcheck disable=SC2162
read -p "Enter the number for the service: " SERVICE_NUM

# Map numbers to services
declare -A SERVICES=(
  [1]="auth"
  [2]="task"
  [3]="integration"
)

# Validate the selected service
SERVICE=${SERVICES[$SERVICE_NUM]}
if [ -z "$SERVICE" ]; then
  echo "Invalid selection for service: $SERVICE_NUM"
  exit 1
fi

# Prompt user to select an action
echo "Select an action:"
echo "1. migrate"
echo "2. repair"
# shellcheck disable=SC2162
read -p "Enter the number for the action: " ACTION_NUM

# Map numbers to actions
declare -A ACTIONS=(
  [1]="migrate"
  [2]="repair"
)

# Validate the selected action
ACTION=${ACTIONS[$ACTION_NUM]}
if [ -z "$ACTION" ]; then
  echo "Invalid selection for action: $ACTION_NUM"
  echo "Please enter 1 for migrate or 2 for repair."
  exit 1
fi

# Prompt user to select an environment
echo "Select an env:"
echo "1. local"
echo "2. prod"
# shellcheck disable=SC2162
read -p "Enter the number for the env: " ENV_NUM

# Map numbers to actions
declare -A ENVS=(
  [1]="local"
  [2]="prod"
)

# Validate the selected environment
ENV=${ENVS[$ENV_NUM]}
if [ -z "$ENV" ]; then
  echo "Invalid selection for env: $ENV_NUM"
  echo "Please enter 1 for local or 2 for prod."
  exit 1
fi

# Execute the Flyway command
echo "Executing $ACTION for $SERVICE in $ENV environment ..."
mvn flyway:"$ACTION" -Dflyway.configFiles=config/"$ENV"/flyway_"$SERVICE".conf

# Check the result of the Flyway command
# shellcheck disable=SC2181
if [ $? -eq 0 ]; then
  echo "$ACTION for $SERVICE in $ENV environment was successful."
else
  echo "Failed to $ACTION for $SERVICE in $ENV environment."
  exit 1
fi