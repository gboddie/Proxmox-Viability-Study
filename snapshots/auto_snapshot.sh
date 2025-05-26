#!/bin/bash

# Log file for the snapshot process
LOG_FILE="/home/user1/terraform/snapshots/auto_snapshot.log"

echo "Starting snapshot process at $(date)" >> $LOG_FILE

# Define the list of VMs
VM_IDS=$(ssh root@192.168.1.132 "qm list | awk 'NR>1 {print \$1}'")

# Loop through each VM and create snapshots
for VM_ID in $VM_IDS; do
    # Create an hourly snapshot
    SNAP_NAME_HOURLY="auto-backup-hourly-$(date +%Y%m%d%H%M)"
    ssh root@192.168.1.132 "qm snapshot $VM_ID $SNAP_NAME_HOURLY"
    echo "Created hourly snapshot $SNAP_NAME_HOURLY for VM $VM_ID" >> $LOG_FILE

    # Define the daily snapshot name
    SNAP_NAME_DAILY="auto-backup-daily-$(date +%Y%m%d)"

    # Check if the snapshot already exists
    if ssh root@192.168.1.132 "qm listsnapshot $VM_ID" | grep -q "$SNAP_NAME_DAILY"; then
        echo "Snapshot $SNAP_NAME_DAILY already exists for VM $VM_ID. Skipping creation." >> $LOG_FILE
    else
        # Create the daily snapshot
        ssh root@192.168.1.132 "qm snapshot $VM_ID $SNAP_NAME_DAILY"
        echo "Created daily snapshot $SNAP_NAME_DAILY for VM $VM_ID" >> $LOG_FILE
    fi


    # Clean up hourly snapshots older than 24 hours
    SNAPSHOTS=$(ssh root@192.168.1.132 "qm listsnapshot $VM_ID | awk '{print \$2}' | grep -v '^$'")
    for SNAP in $SNAPSHOTS; do
        if [[ $SNAP == auto-backup-hourly-* ]]; then
            SNAP_DATE=$(echo $SNAP | grep -oP 'auto-backup-hourly-\K[0-9]{12}')
            if [[ ! -z $SNAP_DATE ]]; then
                SNAP_TIMESTAMP=$(date -d "${SNAP_DATE:0:8} ${SNAP_DATE:8:4}" +%s 2>/dev/null)
                if [[ $SNAP_TIMESTAMP -lt $(date --date="24 hours ago" +%s) ]]; then
                    echo "Deleting hourly snapshot $SNAP for VM $VM_ID" >> $LOG_FILE
                    ssh root@192.168.1.132 "qm delsnapshot $VM_ID $SNAP"
                fi
            fi
        fi
    done

    # Clean up daily snapshots older than 7 days
    for SNAP in $SNAPSHOTS; do
        if [[ $SNAP == auto-backup-daily-* ]]; then
            SNAP_DATE_DAILY=$(echo $SNAP | grep -oP 'auto-backup-daily-\K[0-9]{8}')
            if [[ ! -z $SNAP_DATE_DAILY ]]; then
                SNAP_TIMESTAMP_DAILY=$(date -d "$SNAP_DATE_DAILY" +%s 2>/dev/null)
                if [[ $SNAP_TIMESTAMP_DAILY -lt $(date --date="7 days ago" +%s) ]]; then
                    echo "Deleting daily snapshot $SNAP for VM $VM_ID" >> $LOG_FILE
                    ssh root@192.168.1.132 "qm delsnapshot $VM_ID $SNAP"
                fi
            fi
        fi
    done
done

echo "Snapshot process completed at $(date)" >> $LOG_FILE

