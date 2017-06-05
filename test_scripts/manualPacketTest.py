#!/usr/bin/python
import socket
from socket import AF_INET, SOCK_DGRAM
import sys
from subprocess import call
import datetime

def main():
    hostIPAddr = '1.1.1.1'
    port        = 641

    # XXX forces eth3 interface to be 1.1.1.2
    call(["sudo ifconfig eth3 1.1.1.2"],shell=True)

    s = socket.socket(AF_INET, SOCK_DGRAM)
    s.settimeout(0.1);
    while True:
        hexString = raw_input('Input hex sequence: ')
        hexVal = int(hexString,16)
        message = str(hexVal).encode()

        print "input parsed as {}".format(message)
        s.sendto(message.encode('utf-8'), (hostIPAddr, port))
        try:
            modifiedMessage, serverAddress = s.recvfrom(2048)
            packet_sent_succesfully = True
        except socket.timeout:
            print "Timed out"

        # print bytes in recv message
        for ch in modifiedMessage:
            print hex(ord(ch))

if __name__ == '__main__':
    main()



