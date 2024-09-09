#!/usr/bin/env sh

# Default values
RESTIC_VERSION=$(restic version | awk '{print $2}')
HOSTNAME="tryrocket.cloud"
HC_URL=""

# Function to print usage
usage() {
  echo "Usage: $0 -u <healthcheck-uuid> -v <davis-version> [-h <hostname>] [-r <restic-version>]"
  echo "  -u  Healthcheck UUID (required)"
  echo "  -v  Davis version"
  echo "  -h  Hostname for restic backup (default: tryrocket.cloud)"
  echo "  -r  Restic version (default: detected restic version)"
  exit 1
}

# Parse command-line arguments
while getopts "u:v:h:r:" opt; do
  case $opt in
    u)
      HC_UUID=$OPTARG
      ;;
    v)
      DAVIS_VERSION=$OPTARG
      ;;
    h)
      HOSTNAME=$OPTARG
      ;;
    r)
      RESTIC_VERSION=$OPTARG
      ;;
    *)
      usage
      ;;
  esac
done

# Check for required arguments
if [[ -z "$HC_UUID" || -z "$DAVIS_VERSION" || -z "$RESTIC_VERSION" ]]; then
  usage
fi

HC_URL="https://hc-ping.com/$HC_UUID"

echo DAVIS_VERSION=$DAVIS_VERSION
echo RESTIC_VERSION=$RESTIC_VERSION

# Start health check
curl -fsS -m 10 --retry 5 $HC_URL/start

# Perform restic backup
restic backup --host "$HOSTNAME" --tag restic:"$RESTIC_VERSION" --tag davis:"$DAVIS_VERSION" /data
curl -fsS -m 10 --retry 5 $HC_URL/$?

# Perform restic check
restic check --read-data-subset 1/7
curl -fsS -m 10 --retry 5 $HC_URL/$?

# Prune old backups
restic forget --keep-daily 30 --keep-monthly 3 --keep-yearly 1 --prune
curl -fsS -m 10 --retry 5 $HC_URL/$?
