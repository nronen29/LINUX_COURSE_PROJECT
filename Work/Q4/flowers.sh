#!/bin/bash

# Function to log messages to steps.log
log_step() {
    echo "$1" >> /home/neta/LINUX_COURSE_PROJECT/Work/Q4/steps.log
}

# Function to log errors to errors.log
log_error() {
    echo "$1" >> /home/neta/LINUX_COURSE_PROJECT/Work/Q4/errors.log
}

# Check if CSV file path is passed as an argument
if [[ -z "$1" ]]; then
    # No argument passed, look for a CSV file in the current directory
    csv_path=$(find . -name "*.csv" | head -n 1)
else
    # Use the argument passed as the CSV path
    csv_path="$1"
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

# Check if the venv activation was successful
if [[ $? -ne 0 ]]; then
    log_error "Failed to activate virtual environment."
    echo "Error: Failed to activate virtual environment."
    exit 1
fi

log_step "Virtual environment activated."

# Check if requirements.txt exists
if [[ ! -f "/home/neta/LINUX_COURSE_PROJECT/Work/Q2/requirements.txt" ]]; then
    log_error "No requirements.txt found."
    echo "Error: No requirements.txt found."
    exit 1
fi

# Install required dependencies from requirements.txt
log_step "Installing dependencies from requirements.txt."
pip install -r /home/neta/LINUX_COURSE_PROJECT/Work/Q2/requirements.txt

# Check if Python script exists and run it
python_script="/home/neta/LINUX_COURSE_PROJECT/Work/Q2/requirements.py"

if [[ ! -f "$python_script" ]]; then
    log_error "Python script not found."
    echo "Error: Python script not found."
    exit 1
fi

log_step "Running Python script: $python_script"

# Create directory for diagrams if not exists
mkdir -p /home/neta/LINUX_COURSE_PROJECT/Work/Q4/Diagrams

# Run for each line in the CSV
while IFS=, read -r plant height leaf_count dry_weight; do
    # Create folder for each plant in the diagrams directory
    plant_folder="/home/neta/LINUX_COURSE_PROJECT/Work/Q4/Diagrams/$plant"
    mkdir -p "$plant_folder"

    # Run the Python script for each line, saving plots in the respective folder
    python $python_script --plant "$plant" \
                          --height $height \
                          --leaf_count $leaf_count \
                          --dry_weight $dry_weight

    # Move the generated plots to the respective folder
    mv "${plant}_scatter.png" "$plant_folder/"
    mv "${plant}_histogram.png" "$plant_folder/"
    mv "${plant}_line_plot.png" "$plant_folder/"

    log_step "Generated plots for $plant."
done < "$csv_path"

log_step "All plots generated successfully."

# Deactivate virtual environment
deactivate
log_step "Virtual environment deactivated."

echo "Script completed successfully."
