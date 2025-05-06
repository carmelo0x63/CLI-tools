#!/usr/bin/env python3

import curses
import json
import os
import sys

HOSTS = 'sshhosts.json'

def get_host_list():
    """
    Fetches the host list from an external file, then
    returns a dictionary of SSH hosts.
    """
    with open(HOSTS, 'r') as f:
        config_dict = json.load(f)

    dict_len = len(config_dict)
    config_dict.update({'server' + str(dict_len): {'name': 'Exit', 'idx': dict_len}})

    return config_dict


def draw_menu(stdscr, hosts_dict, current_row):
    """
    Draws the menu with the current selection highlighted.
    """
    stdscr.clear()
    h, w = stdscr.getmaxyx()
#    XOFFSET = w // 2
    XOFFSET = 30
    
    # Draw title
    title = "SSH Host Selection"
#    title_x = w // 2 - len(title) // 2
    title_x = XOFFSET - len(title) // 2
    stdscr.addstr(1, title_x, title)
    
    # Draw instructions
    instructions = "UP/DOWN arrows to navigate, ENTER to select"
#    inst_x = w // 2 - len(instructions) // 2
    inst_x = XOFFSET - len(instructions) // 2
    stdscr.addstr(3, inst_x, instructions)

    # Draw options
    for server in hosts_dict.keys():
        idx = hosts_dict[server]['idx']
#        x = w // 2 - len(hosts_dict[server]['name']) // 2
        x = XOFFSET - len(hosts_dict[server]['name']) // 2
        y = 5 + idx
        
        if idx == current_row:
            stdscr.attron(curses.A_REVERSE)
            stdscr.addstr(y, x, hosts_dict[server]['name'])
            stdscr.attroff(curses.A_REVERSE)
        else:
            stdscr.addstr(y, x, hosts_dict[server]['name'])
    
    stdscr.refresh()


def main(stdscr):
    """
    Main function handling the menu interaction.
    """
    # Setup curses
    curses.curs_set(0)  # Hide cursor
    stdscr.clear()
    
    # Get hosts
    hosts_dict = get_host_list()
    current_row = 0
    
    # Main loop
    while True:
        draw_menu(stdscr, hosts_dict, current_row)
        
        # Get user input
        key = stdscr.getch()
        
        if key == curses.KEY_UP and current_row > 0:
            current_row -= 1
        elif key == curses.KEY_DOWN and current_row < len(hosts_dict) - 1:
            current_row += 1
        elif key == curses.KEY_ENTER or key in [10, 13]:  # Enter key
            # Exit if last option selected
            if current_row == len(hosts_dict) - 1:
                break
            
            # Otherwise connect to selected host
            selected_host = hosts_dict['server' + str(current_row)]['name']
            selected_user = hosts_dict['server' + str(current_row)]['user']
            selected_key = hosts_dict['server' + str(current_row)]['key']

            # Clean up curses
            curses.endwin()
            
            # Execute SSH command
            os.system(f"ssh -i ~/.ssh/{selected_key} {selected_user}@{selected_host}")

            # Restart curses after SSH session ends
            stdscr = curses.initscr()
            curses.curs_set(0)


if __name__ == "__main__":
    try:
        curses.wrapper(main)
    except KeyboardInterrupt:
        sys.exit(0)

