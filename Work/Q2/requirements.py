import subprocess
import sys
import argparse

# Function to install matplotlib if not already installed
def install_matplotlib():
    try:
        import matplotlib.pyplot as plt
    except ImportError:
        print("Matplotlib is not installed. Installing...")
        subprocess.check_call([sys.executable, "-m", "pip", "install", "matplotlib"])
        import matplotlib.pyplot as plt

install_matplotlib()
import matplotlib.pyplot as plt

# Function to parse the command-line arguments
def parse_arguments():
    parser = argparse.ArgumentParser(description="Generate plant data plots.")
    parser.add_argument("--plant", type=str, required=True, help="Name of the plant")
    parser.add_argument("--height", type=float, nargs='+', required=True, help="List of plant heights (in cm)")
    parser.add_argument("--leaf_count", type=int, nargs='+', required=True, help="List of leaf counts")
    parser.add_argument("--dry_weight", type=float, nargs='+', required=True, help="List of dry weights (in grams)")
    
    return parser.parse_args()

# Function to generate plots
def generate_plots(plant, height_data, leaf_count_data, dry_weight_data):
    plt.figure(figsize=(10, 6))
    plt.scatter(height_data, leaf_count_data, color='blue')
    plt.title(f'Height vs Leaf Count for {plant}')
    plt.xlabel('Height (cm)')
    plt.ylabel('Leaf Count')
    plt.grid(True)
    plt.savefig(f"{plant}_scatter.png")
    plt.close()

    # Histogram - Distribution of Dry Weight
    plt.figure(figsize=(10, 6))
    plt.hist(dry_weight_data, bins=5, color='green', edgecolor='black')
    plt.title(f'Histogram of Dry Weight for {plant}')
    plt.xlabel('Dry Weight (grams)')
    plt.ylabel('Frequency')
    plt.grid(True)
    plt.savefig(f"{plant}_histogram.png")
    plt.close()

    # Line Plot - Height Over Time
    weeks = [f'Week {i+1}' for i in range(len(height_data))]  # Time labels for each week
    plt.figure(figsize=(10, 6))
    plt.plot(weeks, height_data, marker='o', color='red')
    plt.title(f'{plant} Height Over Time')
    plt.xlabel('Week')
    plt.ylabel('Height (cm)')
    plt.grid(True)
    plt.savefig(f"{plant}_line_plot.png")
    plt.close()

    # Confirm plot generation
    print(f"\nPlots for {plant} have been generated:")
    print(f"1. Scatter plot: {plant}_scatter.png")
    print(f"2. Histogram: {plant}_histogram.png")
    print(f"3. Line plot: {plant}_line_plot.png")

def main():
    # Parse the command-line arguments
    args = parse_arguments()

    # Display the plant data
    print(f"\nPlant: {args.plant}")
    print(f"Height data: {args.height} cm")
    print(f"Leaf count data: {args.leaf_count}")
    print(f"Dry weight data: {args.dry_weight} grams")

    # Generate the plots
    generate_plots(args.plant, args.height, args.leaf_count, args.dry_weight)

if __name__ == "__main__":
    main()
