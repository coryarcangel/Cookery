#!/bin/bash
install_program() {
    # Define the name of your bash program
    program_name="$1"

    # Determine the user's operating system
    os_type=$(uname -s)

    # Define the installation directory based on the operating system
    if [ "$os_type" == "Darwin" ]; then
        install_dir="/usr/local/bin"  # macOS
    elif [ "$os_type" == "Linux" ]; then
        install_dir="/usr/local/bin"  # Linux
    elif [ "$os_type" == "CYGWIN"* || "$os_type" == "MINGW"* ]; then
        install_dir="/usr/bin"        # Windows (Cygwin or MinGW)
    else
        echo "Unsupported operating system: $os_type"
        exit 1
    fi

    # Copy the bash program to the installation directory
    cp "$program_name" "$install_dir/"

    # Check if the copy operation was successful
    if [ $? -eq 0 ]; then
        echo "Installation completed successfully! Restart your terminal to use the '$program_name' command."
    else
        echo "Installation failed. Please check permissions or try running the script with elevated privileges."
        exit 1
    fi
}

# Example usage
install_program "cook"
install_program "cookv"