![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)
![Maintained](https://img.shields.io/badge/Maintained-Yes-brightgreen.svg)
![Shell Script](https://img.shields.io/badge/Bash-FreshCraft-blue.svg)
![Status: Stable](https://img.shields.io/badge/Status-Stable-brightgreen.svg)
![Debian](https://img.shields.io/badge/Tested-Debian%2FUbuntu-lightgrey.svg)
![Kali Linux](https://img.shields.io/badge/Tested-Kali%20Linux-557C94?logo=kalilinux&logoColor=white)
![Parrot OS](https://img.shields.io/badge/Tested-Parrot%20OS-1BD96A?logo=parrot-security&logoColor=white)
![Raspberry Pi](https://img.shields.io/badge/Tested-Raspberry%20Pi-green.svg)

# 📦 freshbackup.sh — Simple & Secure Linux Backup Tool

**FreshBackup** is a stylish, menu-driven Bash script that helps you back up directories easily and securely. Whether you want full copies, compressed archives, or encrypted backups, FreshBackup has you covered. You can even restore encrypted backups directly from the script.

---

## ✨ Features

- ✅ Full directory backup using `cp`
- 📦 Compressed backups as `.tar.gz`
- 🔐 Encrypted backups as `.tar.gz.enc` using `openssl`
- 🧪 Dry run mode to preview actions without making changes
- 🔄 Automatic cleanup: keeps the latest **7** backups
- ♻️ Backup rotation
- 🗂️ Restore encrypted backups via interactive menu
- 🎨 Beautiful color-coded terminal output + ASCII banner
- 📅 Crontab-friendly for scheduled automatic backups

---

## 📁 Script Variables

| Path                                      | Description                    |
|-------------------------------------------|--------------------------------|
| `SYNC_SOURCE_DIR`            | Source folder for syncing       |
| `SYNC_BACKUP_DIR`              | Destination (e.g. USB drive)   |
| `SOURCE_DIR` | Source to get backups  |
| `BACKUP_DIR` | Where backups go |
| `EXTRACT_DIR` | Where decrypted backups go |
| `PASSPHRASE_FILE`                   | File containing encryption passphrase |

---

## 🚀 Usage

Make the script executable:

```bash
chmod +x freshbackup.sh
```
Run the Script:
```bash
   ./freshbackup.sh
```

You'll be prompted with a menu:
```bash
   1) Dry Run
   2) Full Backup (cp)
   3) Compressed Backup (tar.gz)
   4) Encrypted Backup (tar.gz.enc)
   5) Restore Encrypted Backup
   6) Exit
```
## 🔐 Setup for Encryption

To use encrypted backups or restore, create a passphrase file:
```bash
   echo "your_strong_password" > ~/.backup_passphrase
   chmod 600 ~/.backup_passphrase
```
## ♻️ Backup Rotation

By default, the script keeps the 7 most recent backups. Older ones are automatically deleted. You can change this in the script:

```bash
   MAX_BACKUPS=7
```

## 🕒 Automate with Cron

Schedule a backup to run daily at 2 AM:
```bash
   crontab -e
```

Add this line:
```bash
   0 2 * * * /path/to/freshbackup.sh > /dev/null 2>&1
```

## ✅  Restoring Encrypted Backups

### To restore an encrypted backup:

#### 🔹 Choose option 5 from the main menu.
#### 🔸 Select the backup file you want to restore.
#### 🔹 The script will decrypt it using the passphrase in ~/.backup_passphrase.
#### 🔸 Files will be extracted to: /media/douglas/64F8-97E2/Backup_Extracted/.

## ⚠️  Notes

#### 🔻 Make sure the backup drive is mounted before running the script.
#### 🔸 The Backup_Extracted folder is created automatically if it doesn't exist.
#### 🔺 If you get permission errors during extraction, they are likely harmless. Ownership won't be changed unless run as root.

## 👨‍💻  Author 

| Name:             | Description                                       |
| :---------------- | :------------------------------------------------ |
| Script:           | freshbackup .sh                                   |
| Author:           | Douglas Habian                                    |
| Version:          | 1.1                                               |
| Repo:             | https://github.com/DouglasFreshHabian/FreshCraft  |



## 💬 Feedback & Contributions

Got ideas, bug reports, or improvements?
Feel free to open an issue or submit a pull request!

### If you have not done so already, please head over to the channel and hit that subscribe button to show some support. Thank you!!!

## 👍 [Stay Fresh](https://www.youtube.com/@DouglasHabian-tq5ck) 


<!-- Reach out to me if you are interested in collaboration or want to contract with me for any of the following:
	Building Github Pages
	Creating Youtube Videos
	Editing Youtube Videos
	Youtube Thumbnail Creation
	Anything Pertaining to Linux! -->

<!-- 
 _____              _       _____                        _          
|  ___| __ ___  ___| |__   |  ___|__  _ __ ___ _ __  ___(_) ___ ___ 
| |_ | '__/ _ \/ __| '_ \  | |_ / _ \| '__/ _ \ '_ \/ __| |/ __/ __|
|  _|| | |  __/\__ \ | | | |  _| (_) | | |  __/ | | \__ \ | (__\__ \
|_|  |_|  \___||___/_| |_| |_|  \___/|_|  \___|_| |_|___/_|\___|___/
        dfresh@tutanota.com Fresh Forensics, LLC 2025 -->
