#!/bin/sh

# Script to create a new project from a blank template
# Changeable variables
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

path_to_projects_dir='/home/arturjah/Music'
template_name='CLEAN-TEMPLATE'

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

date=$(date '+%d.%m.%Y')
path_to_clean_template="${path_to_projects_dir}/${template_name}"

create_new_project() {
    project_name="${1}"
    path_to_new_project="${path_to_projects_dir}/${project_name}"

    echo "--- CREATE NEW PROJECT ${project_name} ---"
    cp -r ${path_to_clean_template} ${path_to_new_project}
    mv "${path_to_new_project}/${template_name}.cpr" "${path_to_new_project}/${project_name}.cpr"
}

if [ -d "${path_to_clean_template}" ]; then

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

    echo "--- NEW PROJECT ${project_name} HAS BEEN CREATED ---"
    echo "--- START CUBASE ---"
    open "${path_to_new_project}/${project_name}.cpr" -a cubase
else
    echo "--- THERE IS NO DIRECTORY WITH TEMPLATE ---"
fi
