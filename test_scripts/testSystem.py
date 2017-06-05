#!/usr/bin/python2.7
import sys
sys.dont_write_bytecode = True
from dynamic_table import *
from generatePackets import *
import socket
from socket import AF_INET, SOCK_DGRAM

def main():
   dataGen = []
   # read file and convert to FAST packet format
   if (len(sys.argv) == 2 and os.path.isfile(sys.argv[1])):
      dataGen = readFASTFile(sys.argv[1])
   else:
      print "\nusage:\n\tgeneratePackets.py <your fast file>\n"
      sys.exit(1)

   tableHeaders = [" bid price "," bid quan ", " bid orderID ",
                   " ask price ", " ask quan " , " ask orderID " ]

   # create Table object and pass control to it
   try:
      tbl = Table(tableHeaders,dataGen)
      tbl.tk.mainloop() 
   except KeyboardInterrupt as e:
      sys.exit()
   

if __name__ == "__main__":
    main()
