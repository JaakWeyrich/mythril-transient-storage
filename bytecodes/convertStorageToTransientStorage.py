import argparse
import os

def replace_opcodes(bytecode):
    replaced_bytecode = ""
    i = 0
    while i < len(bytecode):
        # Extract two characters at a time
        byte = bytecode[i:i+2]

        if byte == "55":
            replaced_bytecode += "5d"  # Replace sstore with tstore
        elif byte == "54":
            replaced_bytecode += "5c"  # Replace sload with tload
        else:
            replaced_bytecode += byte

        i += 2

    return replaced_bytecode

def main():
    parser = argparse.ArgumentParser(description='Replace sstore and sload opcodes in Ethereum smart contract bytecode.')
    parser.add_argument('-f', '--file', type=str, required=True, help='Path to the file containing the smart contract bytecode.')

    args = parser.parse_args()

    # Read bytecode from file
    with open(args.file, 'r') as bytecode_file:
        bytecode = bytecode_file.read().strip()

    replaced_bytecode = replace_opcodes(bytecode)

    # Determine output file path
    dir_name = os.path.dirname(args.file)
    base_name = os.path.basename(args.file)
    output_file_path = os.path.join(dir_name, f"transient{base_name}")

    # Save modified bytecode to output file
    with open(output_file_path, 'w') as output_file:
        output_file.write(replaced_bytecode)

    print(f"Modified bytecode saved to: {output_file_path}")

if __name__ == "__main__":
    main()
