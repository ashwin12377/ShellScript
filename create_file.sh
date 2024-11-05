#!/bin/bash
# Ashwin👋

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

# Prompt for the number of files
num_files=$(read_integer "How many files do you want to create 💁: ")

# Prompt for the file extension
read -p "Enter the file extension (e.g., .txt, .sh): " file_extension

# Check if the extension starts with a dot
if [[ $file_extension != .* ]]; then
    file_extension=".$file_extension"
fi

for (( i = 1; i <= num_files; i++ )); do
    while true; do
        read -p "Give the name for the file 👶$i (without extension): " file_name

        if [ -e "$file_name$file_extension" ]; then
            echo "File '$file_name$file_extension' already exists🚫, please enter a different name🔁: "
        else
            touch "$file_name$file_extension"
            echo "Created file $file_name$file_extension 👍"
            break
        fi
    done
done

echo "Ta-daaaah🎉! $num_files files with '$file_extension' extension created successfully✅"

