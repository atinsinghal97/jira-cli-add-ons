#!/bin/bash
set -e

DIRNAME="$(dirname "$0")"
TEMPLATE_FILE="${DIRNAME}/templates/add-to-epic-template.json"

source "${DIRNAME}/supporting-functions/validate-session.sh"
source "${DIRNAME}/supporting-functions/validate-file.sh"
source "${DIRNAME}/supporting-functions/usage.sh"
source "${DIRNAME}/supporting-functions/init.sh"

validate_file -f "${FILE}" -d "${USE_DEFAULT}" -t "${TEMPLATE_FILE}"

EPIC_ID=$(jq -r '.commonDetails.epicId' ${FILE})

for row in $(jq -r '.tickets[] | @base64' ${FILE}); do
  TICKET_ID=$(echo ${row} | base64 --decode)
  jira epic add ${EPIC_ID} ${TICKET_ID}
done

echo "Done!"
