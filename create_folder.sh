#!/bin/bash
#Ashwin👋

#read -p "How may no.of folder you want to create: " num_folders


read_integer() {
        while true; do
                read -p "$1" input
                if [[ $input =~ ^[0-9]+$ ]]; then
                        echo $input 
                break
                else
                        echo "Invalid input. Please enter a valid number❌" 
                fi
        done
}

num_folders=$(read_integer "How many folders do you want to create 💁: ")

for (( i = 1; i<= num_folders; i++));
do
        while true; do

        read -p "Give the name for the folder 👶$i:" folder_name

        if [ -d "$folder_name" ]; then
                echo "Folder '$folder_name' already exists🚫, please enter different name🔁: "
        else
                mkdir "$folder_name"
                echo "Created folder $folder_name 👍"
                break
        fi
        done
done

echo "Ta-daaaah🎉! $num_folders Folder created successfully✅"

