import clingo
import argparse


# Function to process answers
def on_model(model):
    # Extract the atoms (facts) from the model and append to the global list
    results.append("\n".join([str(atom) + "." for atom in model.symbols(atoms=True)]))


# Parse command-line arguments
parser = argparse.ArgumentParser(
    description="Run a Clingo program and save the results to a text file."
)
parser.add_argument("asp_file", help="Path to the ASP file")
parser.add_argument(
    "-o",
    "--output",
    default="output.txt",
    help="Path to the output file (default: output.txt)",
)
args = parser.parse_args()

# List to hold the results
results = []

# Initialize Clingo control
ctl = clingo.Control()

# Load the ASP program
ctl.load(args.asp_file)

# Ground and solve the problem
ctl.ground([("base", [])])
ctl.solve(on_model=on_model)

# Write the facts to the output file
with open(args.output, "w") as f:
    for line in results:
        f.write(line + "\n")

print(f"Results saved to {args.output}")
