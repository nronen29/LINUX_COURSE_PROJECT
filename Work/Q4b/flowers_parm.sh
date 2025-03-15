#!/bin/bash

# Function to log messages to steps.log
log_step() {
    echo "$1" >> /home/neta/LINUX_COURSE_PROJECT/Work/Q4b/steps.log
}

# Function to log errors to errors.log
log_error() {
    echo "$1" >> /home/neta/LINUX_COURSE_PROJECT/Work/Q4b/errors.log
}

# Default values
csv_path=""
selected_lines=""

# Parse arguments
for arg in "$@"; do
    case $arg in
        --path=*|--p=*)
            csv_path="${arg#*=}"
            ;;
        --lines=*)
            selected_lines="${arg#*=}"
            ;;
        *)
            echo "Invalid argument: $arg"
            exit 1
            ;;
    esac
done

# If no CSV path is provided, search for one in the current directory
if [[ -z "$csv_path" ]]; then
    csv_path=$(find . -name "*.csv" | head -n 1)
fi

# Check if a CSV file was found
if [[ -z "$csv_path" ]]; then
    log_error "No CSV file found."
    echo "Error: No CSV file found."
    exit 1
fi

log_step "Using CSV file: $csv_path"

# Check if Q4_venv exists, if not create it
if [[ ! -d "./Q4_venv" ]]; then
    log_step "No Q4_venv found, creating virtual environment."
    python3 -m venv Q4_venv
else
    log_step "Q4_venv found."
fi

# Activate the virtual environment
source ./Q4_venv/bin/activate
log_step "Virtual environment activated."

# Check if requirements.txt exists
requirements_file="/home/neta/LINUX_COURSE_PROJECT/Work/Q2/requirements.txt"

if [[ ! -f "$requirements_file" ]]; then
    log_error "No requirements.txt found."
    echo "Error: No requirements.txt found."
    exit 1
fi

# Install required dependencies from requirements.txt
log_step "Installing dependencies from requirements.txt."
pip install -r "$requirements_file"

# Check if Python script exists
python_script="/home/neta/LINUX_COURSE_PROJECT/Work/Q2/requirements.py"

if [[ ! -f "$python_script" ]]; then
    log_error "Python script not found."
    echo "Error: Python script not found."
    exit 1
fi

log_step "Running Python script: $python_script"

# Create directory for diagrams if not exists
diagrams_dir="/home/neta/LINUX_COURSE_PROJECT/Work/Q4b/Diagrams"
mkdir -p "$diagrams_dir"

# Process the CSV file
line_number=0
while IFS=, read -r plant height leaf_count dry_weight; do
    ((line_number++))

    # If --lines argument is provided, only process specified lines
    if [[ -n "$selected_lines" ]]; then
        if ! echo "$selected_lines" | grep -q "\b$line_number\b"; then
            continue
        fi
    fi

    # Create folder for each plant
    plant_folder="$diagrams_dir/$plant"
    mkdir -p "$plant_folder"

    # Run the Python script for each line, saving plots in the respective folder
    python "$python_script" --plant "$plant" \
                            --height $height \
                            --leaf_count $leaf_count \
                            --dry_weight $dry_weight \
                            >> "$steps.log" 2>> "$errors.log"

    # Move the generated plots to the respective folder
    mv "${plant}_scatter.png" "$plant_folder/" 2>/dev/null
    mv "${plant}_histogram.png" "$plant_folder/" 2>/dev/null
    mv "${plant}_line_plot.png" "$plant_folder/" 2>/dev/null

    log_step "Generated plots for $plant."
done < "$csv_path"

log_step "All plots generated successfully."

# Deactivate virtual environment
deactivate
log_step "Virtual environment deactivated."

echo "Script completed successfully."
