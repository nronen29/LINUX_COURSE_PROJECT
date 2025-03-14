#!/bin/bash

# Initialize variables
main_csv=""

# Function to display the menu
display_menu() {
    echo "\n--- CSV Management Menu ---"
    echo "1. Open a new CSV file and make it main CSV"
    echo "2. Choose main CSV"
    echo "3. Print current CSV to terminal"
    echo "4. Add new line to CSV file"
    echo "5. Run Python script to create diagrams"
    echo "6. Update line in CSV file"
    echo "7. Delete a line from CSV file"
    echo "8. Print plant with highest average leaf count"
    echo "9. Exit"
    echo -n "Enter your choice: "
}

# Function to handle user choice
handle_choice() {
    case $1 in
        1)
            echo -n "Enter new CSV filename: "
            read new_csv
            touch "$new_csv"
            main_csv="$new_csv"
            echo "New CSV file '$new_csv' created and set as main CSV."
            ;;
        2)
            echo -n "Enter the CSV filename to choose: "
            read csv_name
            if [[ -f "$csv_name" ]]; then
                main_csv="$csv_name"
                echo "Selected CSV file: $main_csv"
            else
                echo "Error: File does not exist."
            fi
            ;;
        3)
            if [[ -z "$main_csv" ]]; then
                echo "Warning: No main CSV file selected."
            else
                cat "$main_csv"
            fi
            ;;
        4)
            if [[ -z "$main_csv" ]]; then
                echo "Warning: No main CSV file selected."
            else
                echo -n "Enter new line (Format: Plant, Height (space-separated), Leaf Count (space-separated), Dry Weight (space-separated)): "
                read new_line

                # Check if the input format is valid
                if [[ "$new_line" =~ ^([^,]+),([0-9 ]+),([0-9 ]+),([0-9. ]+)$ ]]; then
                    echo "$new_line" >> "$main_csv"
                    echo "New line added."
                else
                    echo "Invalid input format. Please use the format: Plant, Height (space-separated), Leaf Count (space-separated), Dry Weight (space-separated)."
                fi
            fi
            ;;
        5)
                  
            if [[ -z "$main_csv" ]]; then
                echo "Warning: No main CSV file selected."
            else
                echo -n "Enter line number to plot: "
                read line_num

                # Extract the line from the CSV and store it in variables
                plant=$(sed -n "${line_num}p" "$main_csv" | cut -d, -f1 | tr -d '"')  # Remove quotes from plant name
                height=$(sed -n "${line_num}p" "$main_csv" | cut -d, -f2)              # Space-separated height values
                leaf_count=$(sed -n "${line_num}p" "$main_csv" | cut -d, -f3)          # Space-separated leaf counts
                dry_weight=$(sed -n "${line_num}p" "$main_csv" | cut -d, -f4)          # Space-separated dry weights

                # Run the Python script with the extracted data, ensuring spaces are preserved as separate arguments
                python3 /home/neta/LINUX_COURSE_PROJECT/Work/Q2/requirements.py --plant "$plant" --height $height --leaf_count $leaf_count --dry_weight $dry_weight
            fi
            ;;
        6)
            if [[ -z "$main_csv" ]]; then
                echo "Warning: No main CSV file selected."
            else
                echo -n "Enter line number to update: "
                read line_num
                echo -n "Enter new line content: "
                read new_content
                sed -i "${line_num}s/.*/$new_content/" "$main_csv"
                echo "Line updated."
            fi
            ;;
        7)
            if [[ -z "$main_csv" ]]; then
                echo "Warning: No main CSV file selected."
            else
                echo -n "Enter line number or plant name to delete: "
                read identifier
                if [[ "$identifier" =~ ^[0-9]+$ ]]; then
                    sed -i "${identifier}d" "$main_csv"
                else
                    sed -i "/^$identifier,/d" "$main_csv"
                fi
                echo "Line deleted."
            fi
            ;;
        8)
            if [[ -z "$main_csv" ]]; then
                echo "Warning: No main CSV file selected."
            else
                awk -F, '{sum=0; count=0; for (i=2; i<=NF; i++) {sum+=$i; count++} avg=sum/count; print $1, avg}' "$main_csv" | sort -k2 -nr | head -1
            fi
            ;;
        9)
            echo "Exiting program. Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
}

# Main loop
while true; do
    display_menu
    read choice
    handle_choice "$choice"
done
