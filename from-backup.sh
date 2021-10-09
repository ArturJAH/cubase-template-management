#!/bin/sh

# Script for creating a new project from a backup
# Changeable variables
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

path_to_projects_dir='/home/arturjah/Music'
path_to_backups_dir='/home/arturjah/Music/BACKUPS'
clean_template_name='CLEAN-TEMPLATE'

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

date=$(date '+%d.%m.%Y')

create_new_project() {
    project_name="${1}"
    path_to_new_project="${path_to_projects_dir}/${project_name}"

    mv ${path_to_projects_dir}/.temp_dir/* ${path_to_new_project}
    mv ${path_to_new_project}/${clean_template_name}.cpr ${path_to_new_project}/${project_name}.cpr
}

if [ -d "${path_to_backups_dir}" ]; then
    if [ -e "${path_to_backups_dir}/changes.txt" ]; then
        cat "${path_to_backups_dir}/changes.txt"
    else
        ls -la ${path_to_backups_dir}
    fi

    while [ -z "$backup" ]; do
        read -p 'BACKUP NAME: ' backup
        if [ -e "${path_to_backups_dir}/${backup}.zip" ]; then
            echo "--- CREATE NEW PROJECT FROM ${backup} ---"
            unzip "${path_to_backups_dir}/${backup}" -d ${path_to_projects_dir}/.temp_dir
        else
            echo "--- THERE IS NO BACKUP ${path_to_backups_dir}/${backup}.zip ---"
            unset backup
        fi
    done

    if [ ! -d "${path_to_projects_dir}/${date}" ]; then
        create_new_project ${date}
    else
        echo "--- THERE IS ALREADY A PROJECT WITH NAME ${date} ---"

        while [ -z "$project_name" ]; do
            read -p 'PROJECT NAME: ' project_name
            if [ ! -d "${path_to_projects_dir}/${project_name}" ]; then
                create_new_project ${project_name}
            else
                while [ -d "${path_to_projects_dir}/${project_name}" ] && [ ! -z "$project_name" ]; do
                    echo "--- THERE IS ALREADY A PROJECT WITH NAME ${project_name} ---"
                    unset project_name
                    break
                done
            fi
        done
    fi
    rm -r ${path_to_projects_dir}/.temp_dir

    echo "--- NEW PROJECT ${project_name} HAS BEEN CREATED FROM BACKUP ${backup} ---"
    echo "--- START CUBASE ---"
    open "${path_to_new_project}/${project_name}.cpr" -a cubase
else
    echo "--- THERE IS NO BACKUPS DIRECTORY ---"
fi
