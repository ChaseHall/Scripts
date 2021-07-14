#!/bin/bash

# Note to self: If you are calling this from ddns.sh, this file should be in your home directory.
# These variables are used here: https://github.com/chxseh/scripts
auth_email="$1"         # The email used to login 'https://dash.cloudflare.com'
auth_key="$2"           # Top right corner, "My profile" > "Global API Key"
zone_identifier="$3"    # Can be found in the "Overview" tab of your domain
record_name="$4"        # Which record you want to be synced
are_we_proxying="$5"    # Are we proxying this record through Cloudflare? (Orange vs Gray Cloud) -- should be true, or false.
# Forked from: https://raw.githubusercontent.com/lifehome/systemd-cfddns/master/src/cfupdater-v4


ip=$(curl -4 https://icanhazip.com/)

# SCRIPT START
echo "[Cloudflare DDNS] Check Initiated"

# Seek for the record
record=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records?name=$record_name" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json")

# Can't do anything without the record
if [[ $record == *"\"count\":0"* ]]; then
  >&2 echo -e "[Cloudflare DDNS] Record does not exist, perhaps create one first?"
  exit 1
fi

# Set existing IP address from the fetched record
old_ip=$(echo "$record" | grep -Po '(?<="content":")[^"]*' | head -1)

# Compare if they're the same
if [[ $ip == $old_ip ]]; then
  echo "[Cloudflare DDNS] IP has not changed."
  exit 0
fi

# Set the record identifier from result
record_identifier=$(echo "$record" | grep -Po '(?<="id":")[^"]*' | head -1)

# The execution of update
update=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records/$record_identifier" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json" --data "{\"id\":\"$zone_identifier\",\"type\":\"A\",\"proxied\":$are_we_proxying,\"name\":\"$record_name\",\"content\":\"$ip\",\"ttl\":120}")

# The moment of truth
case "$update" in
*"\"success\":false"*)
  >&2 echo -e "[Cloudflare DDNS] Update failed for $record_identifier. DUMPING RESULTS:\n$update"
  exit 1;;
*)
  echo "[Cloudflare DDNS] IPv4 context '$ip' has been synced to Cloudflare.";;
esac