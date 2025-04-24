#!/bin/bash

# Regular Colors
RED='\033[0;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
PURPLE='\033[1;35m'
WHITE='\033[1;37m'
RESET='\033[0m'

# Array of color names
allcolors=("RED" "GREEN" "YELLOW" "BLUE" "CYAN" "PURPLE" "WHITE")

# Function to print banner with a random color
ascii_banner() {
    # Pick a random color from the allcolors array
    random_color="${allcolors[$((RANDOM % ${#allcolors[@]}))]}"

    # Convert the color name to the actual escape code
    case $random_color in
        "RED") color_code=$RED ;;
        "GREEN") color_code=$GREEN ;;
        "YELLOW") color_code=$YELLOW ;;
        "BLUE") color_code=$BLUE ;;
        "CYAN") color_code=$CYAN ;;
        "PURPLE") color_code=$PURPLE ;;
        "WHITE") color_code=$WHITE ;;
    esac

#--------) Display ASCII banner (--------#

   # Print the banner in the chosen color
    echo -e "${color_code}"
    cat << "EOF"

              ,---------------------------,
              |  /---------------------\  |
              | |                       | |
              | |    Fresh Forensics    | |
              | |                       | |
              | |     freshsync.sh      | |
              | |                       | |
              |  \_____________________/  |
              |___________________________|
            ,---\_____     []     _______/------,
          /         /______________\           /|
        /___________________________________ /  | ___
        |                                   |   |    )
        |  _ _ _                 [-------]  |   |   (
        |  o o o                 [-------]  |  /    _)_
        |__________________________________ |/     /  /
    /-------------------------------------/|      ( )/
  /-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/ /
/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/ /
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


EOF
    echo -e "${RESET}"  # Reset color
}

ascii_banner

# Configuration
SOURCE_DIR="/path/to/directory"   # Change this to your source directory
BACKUP_DIR="/path/to/directory"      # Change this to your backup directory

# Function to create a backup (sync new/changed files)
create_backup() {
    if [ -d "$SOURCE_DIR" ]; then
        echo -e "${GREEN}Syncing files from ${CYAN}$SOURCE_DIR${GREEN} to ${CYAN}$BACKUP_DIR${RESET}..."
        
        # Use rsync to copy only new/modified files, preserving attributes
	echo -e "${WHITE}"
        rsync -avh --update --progress "$SOURCE_DIR"/ "$BACKUP_DIR"/
	echo -e "${RESET}"        
        echo -e "${BLUE}Sync completed successfully${RESET}!"
    else
        echo -e "${RED}Source directory ${YELLOW}$SOURCE_DIR${RED} does not exist. Backup aborted.${RESET}"
        exit 1
    fi
}

# Main script execution
create_backup

# Optional: Add a cron job for daily backup
echo -e "${WHITE}To schedule daily backups, use the following command${RESET}:"
echo -e "${GREEN}0 2 * * * /path/to/your/backup_script.sh${RESET}  ${BLUE}# This will run the backup every day at${RESET} ${RED}2 AM${RESET}"
