#!/bin/sh

# Script to update blank template
# Changeable variables
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

path_to_projects_dir='/home/arturjah/Music'
path_to_backups_dir='/home/arturjah/Music/BACKUPS'
raw_template_name='RAW-TEMPLATE'
clean_template_name='CLEAN-TEMPLATE'

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

date=$(date '+%d.%m.%Y-%H%M')
path_to_raw_template="${path_to_projects_dir}/${raw_template_name}"
path_to_clean_template="${path_to_projects_dir}/${clean_template_name}"

backup_template() (
    local name="$(basename -- "$1")"
    cd "$(dirname -- "$1")" &&
        zip -rmT "${path_to_backups_dir}/${date}.zip" "${name}"
)

if [ -d "${path_to_raw_template}" ]; then

    if [ -d "${path_to_clean_template}" ]; then
        if [ ! -d "${path_to_backups_dir}" ]; then
            echo "--- CREATE DIRECTORY FOR BACKUPS ---"
            mkdir ${path_to_backups_dir}
        fi
        read -p 'WHAT NEW? ' commit
        echo "${date}: ${commit}" >>${path_to_backups_dir}/changes.txt

        echo "--- BACKUP EXISTING CLEAN TEMPLATE IN ${path_to_backups_dir} ---"
        backup_template ${path_to_clean_template}
    fi

    echo "--- CREATE CLEAN TEMPLATE FROM RAW ---"
    cp -r ${path_to_raw_template} ${path_to_clean_template}
    mv "${path_to_clean_template}/${raw_template_name}.cpr" "${path_to_clean_template}/${clean_template_name}.cpr"
    rm -rf ${path_to_clean_template}/Audio/*

    echo "--- START CUBASE ---"
    open "${path_to_clean_template}/${raw_template_name}.cpr" -a cubase
else
    echo "--- THERE IS NO DIRECTORY WITH RAW TEMPLATE ---"
fi
