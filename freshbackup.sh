#!/bin/bash

#---------------- COLORS ----------------#
REDB='\033[1;31m'
GREENB='\033[1;32m'
YELLOWB='\033[1;33m'
BLUEB='\033[1;34m'
CYANB='\033[1;36m'
PURPLEB='\033[1;35m'
WHITEB='\033[1;37m'
RESET='\033[0m'

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
WHITE='\033[0;37m'

#---------------- ASCII BANNER ----------------#
ascii_banner() {
    allcolors=("RED" "GREEN" "YELLOW" "BLUE" "CYAN" "PURPLE" "WHITE")
    random_color="${allcolors[$((RANDOM % ${#allcolors[@]}))]}"
    case $random_color in
        "RED") color_code=$RED ;;
        "GREEN") color_code=$GREEN ;;
        "YELLOW") color_code=$YELLOW ;;
        "BLUE") color_code=$BLUE ;;
        "CYAN") color_code=$CYAN ;;
        "PURPLE") color_code=$PURPLE ;;
        "WHITE") color_code=$WHITE ;;
    esac

    echo -e "${color_code}"
    cat << "EOF"
             ,----------------,              ,---------,
        ,-----------------------,          ,"        ,"|
      ,"                      ,"|        ,"        ,"  |
     +-----------------------+  |      ,"        ,"    |
     |  .-----------------.  |  |     +---------+      |
     |  |                 |  |  |     | -==----'|      |
     |  |  No such file   |  |  |     |         |      |
     |  |  or directory.. |  |  |/----|`---=    |      |
     |  |  $freshbackup   |  |  |   ,/|==== ooo |      ;
     |  |                 |  |  |  // |(((( [33]|    ,"
     |  `-----------------'  |," .;'| |((((     |  ,"
     +-----------------------+  ;;  | |         |,"     
        /_)______________(_/  //'   | +---------+
   ___________________________/___  `,
  /  oooooooooooooooo  .o.  oooo /,   \,"-----------
 / ==ooooooooooooooo==.o.  ooo= //   ,`\--{)B     ,"
/_==__==========__==_ooo__ooo=_/'   /___________,"
`-----------------------------'
EOF
    echo -e "${RESET}"
}

#---------------- CONFIG ----------------#
SYNC_SOURCE_DIR="/path/to/directory"
SYNC_BACKUP_DIR="/path/to/directory"
SOURCE_DIR="path/to/directory"
BACKUP_DIR="path/to/directory"
EXTRACT_DIR="$BACKUP_DIR/path/to/directory"
PASSPHRASE_FILE="$HOME/.backup_passphrase"
DATE=$(date +"%Y%m%d_%H%M%S")
DEST_NAME="backup_$DATE"
MAX_BACKUPS=7
MODE=""
DRY_RUN=false

#---------------- MENU ----------------#
show_menu() {
    echo -e "${CYAN}📋 Choose a backup option:${RESET}"
    echo -e "${WHITE}"
    select opt in "Dry Run" "Full Backup (cp)" "Compressed Backup (tar.gz)" "Encrypted Backup (tar.gz.enc)" "Restore Encrypted Backup" "Sync Files" "Exit"; do
        case $REPLY in
            1) DRY_RUN=true; MODE="dryrun"; break ;;
            2) MODE="full"; break ;;
            3) MODE="compressed"; break ;;
            4) MODE="encrypted"; break ;;
            5) MODE="restore"; break ;;
            6) MODE="sync_file"; break ;;
            7) echo -e "${YELLOW}👋 Exiting...${RESET}"; exit 0 ;;
            *) echo -e "${RED}❌ Invalid option${RESET}" ;;
        esac
    done
}

#---------------- BACKUP FUNCTION ----------------#
perform_backup() {
    if ! mountpoint -q "$BACKUP_DIR"; then
        echo -e "${RED}🔌 Backup drive not mounted: $BACKUP_DIR${RESET}"
        exit 1
    fi

    if [ ! -d "$SOURCE_DIR" ]; then
        echo -e "${RED}📁 Source directory not found: $SOURCE_DIR${RESET}"
        exit 1
    fi

    case $MODE in
        "dryrun")
            echo -e "${YELLOWB}🧪 Dry run selected${RESET}. ${YELLOW}These are the actions that would be performed:${RESET}"
            echo -e "📁 ${GREEN}Would copy${RESET}: ${BLUEB}$SOURCE_DIR ${WHITE}to ${BLUE}$BACKUP_DIR/$DEST_NAME${RESET}"
            echo -e "🗑️  ${CYANB}Would delete backups beyond ${RED}$MAX_BACKUPS ${CYAN}most recent${RESET}"
            ;;

        "full")
            echo -e "${GREENB}📦 Performing full backup using cp...${RESET}"
            cp -r "$SOURCE_DIR" "$BACKUP_DIR/$DEST_NAME"
            echo -e "${BLUEB}✅ Backup saved to ${BLUE}$BACKUP_DIR/$DEST_NAME${RESET}"
            ;;

        "compressed")
            echo -e "${GREEN}📦 Creating compressed archive...${RESET}"
            tar -czf "$BACKUP_DIR/$DEST_NAME.tar.gz" -C "$SOURCE_DIR" .
            echo -e "${BLUE}✅ Compressed backup saved to $BACKUP_DIR/$DEST_NAME.tar.gz${RESET}"
            ;;

        "encrypted")
            echo -e "${GREEN}🔒 Creating encrypted backup...${RESET}"
            if [ ! -f "$PASSPHRASE_FILE" ]; then
                echo -e "${RED}❌ Passphrase file not found: $PASSPHRASE_FILE${RESET}"
                echo -e "${YELLOW}📝 Create it with:${RESET} echo 'yourpassword' > ~/.backup_passphrase && chmod 600 ~/.backup_passphrase"
                exit 1
            fi
            PASSPHRASE=$(<"$PASSPHRASE_FILE")
            tar -czf - -C "$SOURCE_DIR" . | openssl enc -aes-256-cbc -salt -pbkdf2 -pass pass:"$PASSPHRASE" -out "$BACKUP_DIR/$DEST_NAME.tar.gz.enc"
            echo -e "${BLUE}✅ Encrypted backup saved to $BACKUP_DIR/$DEST_NAME.tar.gz.enc${RESET}"
            ;;

        "restore")
            echo -e "${CYAN}🔍 Choose the encrypted backup file to restore:${RESET}"
            select file in "$BACKUP_DIR"/*.tar.gz.enc; do
                if [[ -f "$file" ]]; then
                    BACKUP_FILE="$file"
                    break
                else
                    echo -e "${RED}❌ Invalid selection! Try again.${RESET}"
                fi
            done

            if [ ! -f "$PASSPHRASE_FILE" ]; then
                echo -e "${RED}❌ Passphrase file not found: $PASSPHRASE_FILE${RESET}"
                echo -e "${YELLOW}📝 Create it with:${RESET} echo 'yourpassword' > ~/.backup_passphrase && chmod 600 ~/.backup_passphrase"
                exit 1
            fi

            PASSPHRASE=$(<"$PASSPHRASE_FILE")
            decrypted_file="${BACKUP_FILE%.enc}"

            echo -e "${GREENB}🔓 Decrypting ${GREEN}$BACKUP_FILE...${RESET}"
            openssl enc -d -aes-256-cbc -salt -pbkdf2 -in "$BACKUP_FILE" -out "$decrypted_file" -pass pass:"$PASSPHRASE"

            if [[ $? -ne 0 ]]; then
                echo -e "${RED}❌ Decryption failed. Check your passphrase.${RESET}"
                exit 1
            fi

            mkdir -p "$EXTRACT_DIR"
            if [[ "$decrypted_file" =~ \.tar\.gz$ ]]; then
                tar --no-same-owner -xzf "$decrypted_file" -C "$EXTRACT_DIR"
                if [[ $? -eq 0 ]]; then
                    echo -e "${BLUEB}✅ Backup extracted to ${BLUE}$EXTRACT_DIR${RESET}"
                else
                    echo -e "${YELLOW}⚠️ Extracted, but with some warnings (likely ownership).${RESET}"
                fi
            else
                echo -e "${RED}❌ Not a valid .tar.gz: $decrypted_file${RESET}"
                exit 1
            fi
            rm "$decrypted_file"
            ;;

        "sync_file")
            sync_file  ### ADDED call here instead of earlier
            ;;

        *)
            echo -e "${RED}❌ No valid backup mode selected${RESET}"
            exit 1
            ;;
    esac
}

#---------------- SYNC FUNCTION ----------------#
sync_file() {
    if [ -d "$SOURCE_DIR" ]; then
        echo -e "${GREENB}🔄 Syncing files from ${CYANB}$SOURCE_DIR${GREEN} to ${CYAN}$BACKUP_DIR${RESET}..."
        echo -e "${WHITE}"
        rsync -avh --update --progress "$SOURCE_DIR"/ "$BACKUP_DIR"/
        echo -e "${RESET}"
        echo -e "${BLUEB}✅ Sync completed successfully!${RESET}"
    else
        echo -e "${RED}❌ Source directory ${YELLOWB}$SOURCE_DIR${RED} does not exist. Backup aborted.${RESET}"
        exit 1
    fi
}

#---------------- CLEANUP OLD BACKUPS ----------------#
cleanup_backups() {
    if $DRY_RUN || [[ "$MODE" == "restore" ]]; then
        echo -e "${YELLOWB}🧪 Dry run${RESET}: ${YELLOW}Skipping cleanup of old backups.${RESET}"
        return
    fi

    cd "$BACKUP_DIR" || return
    backups=( $(ls -1dt backup_* backup_*.tar.gz backup_*.tar.gz.enc 2>/dev/null) )
    if (( ${#backups[@]} > MAX_BACKUPS )); then
        for old_backup in "${backups[@]:$MAX_BACKUPS}"; do
            echo -e "${YELLOW}🗑️ Removing old backup: $old_backup${RESET}"
            rm -rf "$old_backup"
        done
    fi
}

#---------------- EXECUTION ----------------#
ascii_banner
show_menu
perform_backup
cleanup_backups

#---------------- CRON SUGGESTION ----------------#
echo -e "${WHITE}📅 To schedule automatic backups, add this line to your crontab:${RESET}"
echo -e "${PURPLE}0 2 * * * /path/to/this_script.sh > /dev/null 2>&1${RESET}"

#---------------- EXIT SLOGAN ----------------#
echo -e "${WHITE}✅ Done. Stay fresh. 😎${RESET}"
