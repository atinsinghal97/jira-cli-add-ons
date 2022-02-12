#!/bin/bash
set -e

DIRNAME="$(dirname "$0")"
TEMPLATE_FILE="${DIRNAME}/templates/add-distinct-labels-template.json"

source "${DIRNAME}/validate-file.sh"
source "${DIRNAME}/usage.sh"
source "${DIRNAME}/init.sh"

validate_file -f "${FILE}" -d "${USE_DEFAULT}" -t "${TEMPLATE_FILE}"

for row in $(jq -r '.tickets[] | @base64' ${FILE}); do
  TICKET_ID=$(echo ${row} | base64 --decode | jq -r '.ticket_id')
  LABEL=$(echo ${row} | base64 --decode | jq -r '.label')
  jira labels add ${TICKET_ID} ${LABEL}
done

echo "Done!"
