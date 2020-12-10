#!/bin/bash

select name in k3s k8s ;
do
  case "$name" in
        k3s)
            export KUBERNETES_KEYS=/var/lib/rancher/k3s
            break
          ;;
        k8s)
            export KUBERNETES_KEYS=/etc/kubernetes
            break
          ;;
  esac
done

if [ -z "$KUBERNETES_KEYS" ]; then
    echo 'No build selected.'
    exit
fi

export ENCRYPTED_ISO=/data/tpm.iso
export MAPPER_DEV_NAME=tpm_keys
export PASSWORD=password
export TEMP_KEY=/home/root/tpm_lukskey
export UNLOCK_SCRIPT=/home/root/decryptkeydevice_keyscript.sh
export UMOUNT_SCRIPT=/home/root/umount.sh
export KUBERNETES_KEY_MOUNT_SERVICE=kubernetes_keys

# Create iso file system
fallocate -l 1024M $ENCRYPTED_ISO &&
echo -n "$PASSWORD" | cryptsetup luksFormat $ENCRYPTED_ISO - &&
echo -n "$PASSWORD" | cryptsetup luksOpen $ENCRYPTED_ISO $MAPPER_DEV_NAME - &&
mkfs.ext4 /dev/mapper/$MAPPER_DEV_NAME

# TPM generate key and save
tpm2_createprimary -Q --hierarchy=o --key-context=prim.ctx
dd if=/dev/urandom bs=1 count=32 status=none | tpm2_create --hash-algorithm=sha256 --public=seal.pub --private=seal.priv --sealing-input=- --parent-context=prim.ctx
tpm2_load -Q --parent-context=prim.ctx --public=seal.pub --private=seal.priv --name=seal.name --key-context=seal.ctx
HANDLER=$(tpm2_evictcontrol --hierarchy=o --object-context=seal.ctx | awk -F":" '/persistent-handle/{print $2}' | tr -d ' ')

tpm2_unseal -Q --object-context=$HANDLER > $TEMP_KEY
echo -n "$PASSWORD" | cryptsetup luksAddKey $ENCRYPTED_ISO $TEMP_KEY
rm $TEMP_KEY
cryptsetup remove $MAPPER_DEV_NAME

# Create unlock script
cat << EOF | tee $UNLOCK_SCRIPT
#!/bin/bash
set -e
tpm2_unseal -Q --object-context=$HANDLER | cryptsetup --key-file=- luksOpen $ENCRYPTED_ISO $MAPPER_DEV_NAME

mkdir -p $KUBERNETES_KEYS
mount /dev/mapper/$MAPPER_DEV_NAME $KUBERNETES_KEYS
EOF
chmod +x $UNLOCK_SCRIPT

cat << EOF | tee $UMOUNT_SCRIPT
#!/bin/bash
set -e

umount $KUBERNETES_KEYS
cryptsetup remove $MAPPER_DEV_NAME
EOF
chmod +x $UMOUNT_SCRIPT

# Create systemd service
cat << EOF | tee /etc/systemd/system/kubernetes_keys.service
[Unit]
Description=Kubernetes keys mount
Before=docker.service kubelet.service

[Service]
ExecStart=$UNLOCK_SCRIPT
ExecStop=$UMOUNT_SCRIPT
Type=simple
Restart=on-failure
RestartSec=20
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target docker.service kubelet.service

EOF

systemctl daemon-reload
systemctl start $KUBERNETES_KEY_MOUNT_SERVICE
systemctl enable $KUBERNETES_KEY_MOUNT_SERVICE

echo 'Please reboot your system for changes to take effect'

