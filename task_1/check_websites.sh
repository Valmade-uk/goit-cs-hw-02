#!/usr/bin/env bash
set -Eeuo pipefail

SITES=(
  "https://google.com"
  "https://facebook.com"
  "https://twitter.com"
)

LOG_FILE="website_status.log"
: > "$LOG_FILE"

check_site() {
  local url="$1"
  local code
  code="$(curl -L -s -o /dev/null -w "%{http_code}" \
               --max-time 10 --retry 2 --retry-delay 1 \
               -H "User-Agent: site-checker/1.0" \
               -X GET "$url" || echo "000")"

  local status="DOWN"
  [[ "$code" == "200" ]] && status="UP"

  echo "[$(date -Iseconds)] <${url}> is ${status} (HTTP ${code})" | tee -a "$LOG_FILE" >/dev/null
}

for site in "${SITES[@]}"; do
  check_site "$site"
done

echo "Результати записано у файл логів: $LOG_FILE"
