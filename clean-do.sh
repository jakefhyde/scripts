#!/usr/bin/zsh

echo "Deleting droplets"

name=$1

while read -r entry; 
do 
    if [[ -z $(echo $entry | xargs) ]]; 
    then
        break
    fi
    droplet_id="$(echo $entry | awk '{print $1}')"
    droplet_name="$(echo $entry | awk '{print $2}')"
    echo "Deleting droplet $droplet_name with id:\t$droplet_id"
    yes | doctl compute droplet delete $droplet_id
    echo
done <<<"$(doctl compute droplet list --format 'ID, Name' | grep $name)"

echo "Deleting ssh-keys"

while read -r entry;
do 
    if [[ -z $(echo $entry | xargs) ]]; 
    then
        break
    fi
    sshkey_id="$(echo $entry | awk '{print $1}')"
    sshkey_name="$(echo $entry | awk '{print $2}')"

    echo "Deleting ssh-key $sshkey_name with id:\t$sshkey_id"
    yes | doctl compute ssh-key delete $sshkey_id
    echo
done <<<"$(doctl compute ssh-key list | grep $name)"

echo "Deleting dns records"

while read entry; 
do 
    if [[ -z $(echo $entry | xargs) ]]; 
    then
        break
    fi
    record_id="$(echo $entry | awk '{print $1}')"
    record_name="$(echo $entry | awk '{print $3}')"
    echo "Deleting dns record $record_name with id:\t$record_id"
    yes | doctl compute domain records delete $DIGITALOCEAN_DOMAIN $record_id
    echo
done <<<"$(doctl compute domain records list $DIGITALOCEAN_DOMAIN | grep $name)"


