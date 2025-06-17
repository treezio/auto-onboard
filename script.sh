#!/bin/bash
USERNAME=$(echo "$EMAIL" | cut -d@ -f1)
ALIAS=$(echo "$USERNAME" | cut -d. -f1)

FILE="notifications/notifications.yaml"
# Add user with correct structure
yq eval -i \
  ".users.\"$USERNAME\".aliases = [\"$ALIAS\"] |
   .users.\"$USERNAME\".emails = [\"$EMAIL\"] |
   .users.\"$USERNAME\".services.email.to = \"$EMAIL\" |
   .users.\"$USERNAME\".services.slack.to = \"@$USERNAME\"" \
   "$FILE"

yq eval-all '
  . as $doc
  | $doc.users
  | with_entries(sort_by(.key)) as $sorted
  | $doc.users = $sorted
  | $doc' -i "$FILE"