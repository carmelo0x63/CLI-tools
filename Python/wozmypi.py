#!/usr/bin/env python3
# Displays Raspberry Pi's revision and other board data
# Source info: https://elinux.org/RPi_HardwareHistory
# author: Carmelo C
# email: carmelo.califano@gmail.com
# history:
#  2.3 Extracting "Model" from /proc/cpuinfo
#  2.2 Updated: list of Pi flavours
#  2.1 Added: try/except to handle running on non-Linux platforms
#  2.0 added: CPU count, frequency
#  1.2 replaced split with rstrip, moved to Python 3
#  1.1 added argparse module and functionalities
#  1.0 initial version

# Import some modules
from __future__ import print_function  # print() as a function not as a statement
import argparse                        # Parser for command-line options, arguments and sub-commands
import subprocess                      # spawn new processes, connect to their input/output/error pipes, and obtain their return codes
import sys                             # system-specific parameters and functions

# Global settings
__version__ = '2.3'
__build__ = '20220115'

PiFlavours = [
  {'revision':'Beta','date':'Q1 2012','model':'B (Beta)','pcb':'?','mem':'256 MB','notes':'Beta Board'},
  {'revision':'0002','date':'Q1 2012','model':'B','pcb':'1.0','mem':'256 MB','notes':''},
  {'revision':'0003','date':'Q3 2012','model':'B (ECN0001)','pcb':'1.0','mem':'256 MB','notes':'Fuses mod and D14 removed'},
  {'revision':'0004','date':'Q3 2012','model':'B','pcb':'2.0','mem':'256 MB','notes':'(Mfg by Sony)'},
  {'revision':'0005','date':'Q4 2012','model':'B','pcb':'2.0','mem':'256 MB','notes':'(Mfg by Qisda)'},
  {'revision':'0006','date':'Q4 2012','model':'B','pcb':'2.0','mem':'256 MB','notes':'(Mfg by Egoman)'},
  {'revision':'0007','date':'Q1 2013','model':'A','pcb':'2.0','mem':'256 MB','notes':'(Mfg by Egoman)'},
  {'revision':'0008','date':'Q1 2013','model':'A','pcb':'2.0','mem':'256 MB','notes':'(Mfg by Sony)'},
  {'revision':'0009','date':'Q1 2013','model':'A','pcb':'2.0','mem':'256 MB','notes':'(Mfg by Qisda)'},
  {'revision':'000d','date':'Q4 2012','model':'B','pcb':'2.0','mem':'512 MB','notes':'(Mfg by Egoman)'},
  {'revision':'000e','date':'Q4 2012','model':'B','pcb':'2.0','mem':'512 MB','notes':'(Mfg by Sony)'},
  {'revision':'000f','date':'Q4 2012','model':'B','pcb':'2.0','mem':'512 MB','notes':'(Mfg by Qisda)'},
  {'revision':'0010','date':'Q3 2014','model':'B+','pcb':'1.0','mem':'512 MB','notes':'(Mfg by Sony)'},
  {'revision':'0011','date':'Q2 2014','model':'Compute Module 1','pcb':'1.0','mem':'512 MB','notes':'(Mfg by Sony)'},
  {'revision':'0012','date':'Q4 2014','model':'A+','pcb':'1.1','mem':'256 MB','notes':'(Mfg by Sony)'},
  {'revision':'0013','date':'Q1 2015','model':'B+','pcb':'1.2','mem':'512 MB','notes':'(Mfg by Embest)'},
  {'revision':'0014','date':'Q2 2014','model':'Compute Module 1','pcb':'1.0','mem':'512 MB','notes':'(Mfg by Embest)'},
  {'revision':'0015','date':'?','model':'A+','pcb':'1.1','mem':'256 MB / 512 MB','notes':'(Mfg by Embest)'},
  {'revision':'a01040','date':'Unknown','model':'2 model B','pcb':'1.0','mem':'1 GB','notes':'(Mfg by Sony)'},
  {'revision':'a01041','date':'Q1 2015','model':'2 model B','pcb':'1.1','mem':'1 GB','notes':'(Mfg by Sony)'},
  {'revision':'a21041','date':'Q1 2015','model':'2 model B','pcb':'1.1','mem':'1 GB','notes':'(Mfg by Embest)'},
  {'revision':'a22042','date':'Q3 2016','model':'2 model B (with BCM2837)','pcb':'1.2','mem':'1 GB','notes':'(Mfg by Embest)'},
  {'revision':'900021','date':'Q3 2016','model':'A+','pcb':'1.1','mem':'512 MB','notes':'(Mfg by Sony)'},
  {'revision':'900032','date':'Q2 2016?','model':'B+','pcb':'1.2','mem':'512 MB','notes':'(Mfg by Sony)'},
  {'revision':'900092','date':'Q4 2015','model':'Zero','pcb':'1.2','mem':'512 MB','notes':'(Mfg by Sony)'},
  {'revision':'900093','date':'Q2 2016','model':'Zero','pcb':'1.3','mem':'512 MB','notes':'(Mfg by Sony)'},
  {'revision':'920093','date':'Q4 2016?','model':'Zero','pcb':'1.3','mem':'512 MB','notes':'(Mfg by Embest)'},
  {'revision':'9000c1','date':'Q1 2017','model':'Zero W','pcb':'1.1','mem':'512 MB','notes':'(Mfg by Sony)'},
  {'revision':'a02082','date':'Q1 2016','model':'3 model B','pcb':'1.2','mem':'1 GB','notes':'(Mfg by Sony)'},
  {'revision':'a020a0','date':'Q1 2017','model':'Compute Module 3 (and CM3 Lite)','pcb':'1.0','mem':'1 GB','notes':'(Mfg by Sony)'},
  {'revision':'a22082','date':'Q1 2016','model':'3 model B','pcb':'1.2','mem':'1 GB','notes':'(Mfg by Embest)'},
  {'revision':'a32082','date':'Q4 2016','model':'3 model B','pcb':'1.2','mem':'1 GB','notes':'(Mfg by Sony Japan)'},
  {'revision':'a020d3','date':'Q1 2018','model':'3 model B+','pcb':'1.3','mem':'1 GB','notes':'(Mfg by Sony)'},
  {'revision':'9020e0','date':'Q4 2018','model':'3 model A+','pcb':'1.0','mem':'512 MB','notes':'(Mfg by Sony)'},
  {'revision':'a02100','date':'Q1 2019','model':'Compute Module 3+','pcb':'1.0','mem':'1 GB','notes':'(Mfg by Sony)'},
  {'revision':'a03111','date':'Q2 2019','model':'4 model B','pcb':'1.1','mem':'1 GB','notes':'(Mfg by Sony)'},
  {'revision':'b03111','date':'Q2 2019','model':'4 model B','pcb':'1.1','mem':'2 GB','notes':'(Mfg by Sony)'},
  {'revision':'b03112','date':'Q2 2019','model':'4 model B','pcb':'1.2','mem':'2 GB','notes':'(Mfg by Sony)'},
  {'revision':'b03114','date':'Q2 2020','model':'4 model B','pcb':'1.4','mem':'2 GB','notes':'(Mfg by Sony)'},
  {'revision':'c03111','date':'Q2 2019','model':'4 model B','pcb':'1.1','mem':'4 GB','notes':'(Mfg by Sony)'},
  {'revision':'c03112','date':'Q2 2019','model':'4 model B','pcb':'1.2','mem':'4 GB','notes':'(Mfg by Sony)'},
  {'revision':'c03114','date':'Q2 2020','model':'4 model B','pcb':'1.4','mem':'4 GB','notes':'(Mfg by Sony)'},
  {'revision':'d03114','date':'Q2 2020','model':'4 model B','pcb':'1.4','mem':'8 GB','notes':'(Mfg by Sony)'},
  {'revision':'902120','date':'Q4 2021','model':'Zero 2 W','pcb':'1.0','mem':'512 MB','notes':'(Mfg by Sony)'}
]

def checkFlav():
    # Parses /proc/cpuinfo to get "Revision" number
    try:
        myFlav = subprocess.check_output(["awk","/^Revision/ {sub(\"^1000\", \"\", $3); print $3}","/proc/cpuinfo"]).decode().rstrip()
        myModel = subprocess.check_output(["awk","/^Model/ {print $3\" \"$4}","/proc/cpuinfo"]).decode().rstrip()
    except:
        print('[-] An exception occurred')
        sys.exit(20)

    # Searches in PiFlavours (list of dictionaries) for the corresponding record
    for piflav in PiFlavours:
        if piflav['revision'] == myFlav:
            return {**piflav, **{'SBC': myModel}}

def checkSpecs():
    # Parses CPU count, MHz
    lscpuz = subprocess.check_output(['lscpu', '-p=cpu']).decode().split('\n')
    lsmhz = subprocess.check_output(['lscpu', '-p=maxmhz']).decode().split('\n')

    piCpus = ['CPU' + x for x in lscpuz if not x.startswith('#') and x != '']
    piMhzs = [str(int(float(x))) + 'MHz' for x in lsmhz if not x.startswith('#') and x != '']

    return dict(zip(piCpus, piMhzs))

def main():
    parser = argparse.ArgumentParser(description='Search and find Raspberry Pi\'s revision number, release date, model, PCB revision, RAM size..., version ' + __version__ + ', build ' + __build__ + '.')
    parser.add_argument('-s', '--short', action='store_true', help='display output in short format: revision, date, model, PCB')
    parser.add_argument('-l', '--long', action='store_true', help='extended info: CPU count, CPU frequency')
    parser.add_argument('-v', '--version', action='version', version='%(prog)s {version}'.format(version=__version__))

    args = parser.parse_args() # parse command line

    # In case of no arguments shows information from the main list
    if len(sys.argv) == 1:
        parser.print_help()
        sys.exit(1)

    if args.short:
        d1 = checkFlav()
        if d1 is None:
            print('[-] Search returned ' + str(d1))
            sys.exit(10)
        print(d1)
        sys.exit(0)

    if args.long:
        d1 = checkFlav()
        if d1 is None:
            print('[-] Search returned ' + str(d1))
            sys.exit(10)
        d2 = checkSpecs()
        print({**d1, **d2})
        sys.exit(0)

if __name__ == '__main__':
    main()

