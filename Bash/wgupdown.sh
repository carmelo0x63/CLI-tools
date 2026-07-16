#!/bin/bash
# Script to bring up/down Wireguard VPN on Linux PC using nmcli
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history, date format ISO 8601:
#  2026-07-16: Initial release

# Settings
WG_DIR="/etc/wireguard"
WG_CONF="$WG_DIR/wg0.conf"
REQUIRED_DIR_PERM="700"
REQUIRED_FILE_PERM="600"
OWNER="root"

show_help() {
    echo "Usage: $0 {-up|-down|-help|-version}"
    echo "  -up      - Bring up the Wireguard VPN"
    echo "  -down    - Bring down the Wireguard VPN"
    echo "  -help    - Show this help message"
    echo "  -version - Show script version"
}

check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "This script must be run as root or with sudo."
        exit 1
    fi
}

check_and_fix_dir() {
    if [ ! -d "$WG_DIR" ]; then
        echo "Directory $WG_DIR does not exist."
        read -p "Create it with owner $OWNER and permissions $REQUIRED_DIR_PERM? (y/n): " ans
        if [[ "$ans" =~ ^[Yy]$ ]]; then
            mkdir -p "$WG_DIR"
            chown $OWNER:$OWNER "$WG_DIR"
            chmod $REQUIRED_DIR_PERM "$WG_DIR"
            echo "Directory created and permissions set."
        else
            echo "Cannot proceed without $WG_DIR directory."
            exit 1
        fi
    else
        # Check ownership
        dir_owner=$(stat -c '%U' "$WG_DIR")
        dir_perm=$(stat -c '%a' "$WG_DIR")
        if [ "$dir_owner" != "$OWNER" ] || [ "$dir_perm" != "$REQUIRED_DIR_PERM" ]; then
            echo "Directory $WG_DIR ownership or permissions are incorrect."
            echo "Current owner: $dir_owner, permissions: $dir_perm"
            read -p "Fix ownership to $OWNER and permissions to $REQUIRED_DIR_PERM? (y/n): " ans
            if [[ "$ans" =~ ^[Yy]$ ]]; then
                chown $OWNER:$OWNER "$WG_DIR"
                chmod $REQUIRED_DIR_PERM "$WG_DIR"
                echo "Directory ownership and permissions fixed."
            else
                echo "Cannot proceed with incorrect directory ownership or permissions."
                exit 1
            fi
        fi
    fi
}

check_and_fix_file() {
    if [ ! -f "$WG_CONF" ]; then
        echo "File $WG_CONF does not exist."
        read -p "Create an empty $WG_CONF file with owner $OWNER and permissions $REQUIRED_FILE_PERM? (y/n): " ans
        if [[ "$ans" =~ ^[Yy]$ ]]; then
            touch "$WG_CONF"
            chown $OWNER:$OWNER "$WG_CONF"
            chmod $REQUIRED_FILE_PERM "$WG_CONF"
            echo "File created and permissions set. Please edit $WG_CONF with your Wireguard configuration."
            exit 0
        else
            echo "Cannot proceed without $WG_CONF file."
            exit 1
        fi
    else
        file_owner=$(stat -c '%U' "$WG_CONF")
        file_perm=$(stat -c '%a' "$WG_CONF")
        if [ "$file_owner" != "$OWNER" ] || [ "$file_perm" != "$REQUIRED_FILE_PERM" ]; then
            echo "File $WG_CONF ownership or permissions are incorrect."
            echo "Current owner: $file_owner, permissions: $file_perm"
            read -p "Fix ownership to $OWNER and permissions to $REQUIRED_FILE_PERM? (y/n): " ans
            if [[ "$ans" =~ ^[Yy]$ ]]; then
                chown $OWNER:$OWNER "$WG_CONF"
                chmod $REQUIRED_FILE_PERM "$WG_CONF"
                echo "File ownership and permissions fixed."
            else
                echo "Cannot proceed with incorrect file ownership or permissions."
                exit 1
            fi
        fi
    fi
}

version() {
    echo "Wireguard VPN control script version 1.0"
}

main() {
    check_root

    if [ $# -eq 0 ]; then
        show_help
        exit 0
    fi

    case "$1" in
        -help)
            show_help
            ;;
        -version)
            version
            ;;
        -up|-down)
            check_and_fix_dir
            check_and_fix_file

            if [ "$1" = "-up" ]; then
                echo "Bringing up Wireguard VPN..."
                nmcli con import type wireguard file "$WG_CONF"
                nmcli con up id wg0
            else
                echo "Bringing down Wireguard VPN..."
                nmcli con down id wg0
                nmcli con del id wg0
            fi
            ;;
        *)
            echo "Invalid argument: $1"
            show_help
            exit 1
            ;;
    esac
}

main "$@"

