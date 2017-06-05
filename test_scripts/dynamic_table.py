from Tkinter import *
from generatePackets import *
import random
import time
import socket
from socket import AF_INET, SOCK_DGRAM
from subprocess import call

intToType = {3 : "BID",  2 : "ASK" , 5 : "RMBID" , 4:  "RMASK" }

def bytearrayToNumber(ba):
    total = 0
    multiplier = 1
    for count in xrange(len(ba)-1, -1, -1):
        byte = ba[count]
        total += multiplier * byte
        multiplier *= 256
    return total

class Table(object):

   # maximum table size
   kTblSize = 25 
   kCols =None

   skt = None

   tk=None
   headers=None
   dataGen=None
   tblFields=[]
   f1=None
   f2=None

   bids=[]
   asks=[]

   def __init__(self,headers,dataGen):
      self.headers = headers   
      self.dataGen = dataGen

      self.skt = self.initSocket()

      self.kCols = len(headers)

      self.tk = Tk()

      self.tk.wm_title("HFT Order Book Monitor")
 
      self.f1 = Frame(self.tk)
      self.f1.grid(row=0,column=0,rowspan=2+len(headers))
      self.f2 = Frame(self.tk)
      self.f2.grid(row=0,column=1,rowspan=2+len(headers))

      b_step = Button(self.f1, text="Step", fg="grey", command=self.step)
      b_step.pack( side = TOP )

      b_batch = Button(self.f1, text="Tx All Input", fg="grey", command=self.stepAll)
      b_batch.pack( side = TOP )

      # create all header label widgets
      for i,hdr in enumerate(headers):
         self.f2.grid_columnconfigure(i,weight=1)
         bgColor = "#441" if  i < 3 else "#144"
         Label(self.f2, text=hdr, bg=bgColor, fg="#eee",
         font = ("Helvetica", 16, "bold"),anchor='n').grid(row=2,column=i,sticky="NEW")

      # create all column data text widgets
      for row in range(0,self.kTblSize):
         for col in range(0,self.kCols):
            var = StringVar()
            var.set("--")
            Label(
               self.f2, textvariable=var, bg="#f4f4f4", fg="#111",
               font = ("Helvetica", 16, "bold"),anchor='n').grid(row=row+3,column=col,sticky="NEW")
            self.tblFields.append(var)

   def ind(self,row,col):
      """ convert row,col to ind in tblFields"""
      return self.kCols*row+col
   
   def test(self):
      self.draw(self.update())

   def draw(self,data):
      for colno,col in enumerate(data): 
         # all cols are trimmed to maximum tbl size
         col = col[:self.kTblSize]

         # set text widget for each item in col
         length = len(col)
         for rowno in range(0,self.kTblSize):
            elem = col[rowno] if rowno < length else "--"
            self.tblFields[self.ind(rowno,colno)].set(elem)
      
         
   def step(self,drawFlag=True):
      # get next value from dataGen; if dne, return
      order = next(self.dataGen,None)
      if order is None: 
         print "[WARN] All Data in test file sent"
         return False

      packetData , (orderID,price,quantity,transType) = order
      
      # send packet to hardware and await response
      #print('Sending Data : id={} price={} quantity={} transType={}'
      #         .format(orderID, price, quantity, transType))

      recvMsg = self.sendPacket(self.skt,packetData)

      if(transType=="RMASK" or transType=="RMBID"):
         print ("\033[34m[TX] orderID " + str(orderID) + "\033[39m"
               + "\t price:--- quan:--- type:{}\n".format(transType))
      else:
         print ("\033[34m[TX] orderID " + str(orderID) + "\033[39m"
               + "\t price:{} quan:{} type:{}\n".format(price,quantity,transType))

      try:
         if(len(recvMsg) < 12):
            raise ValueError('no packet was recevied')
         # extract timestamp
         timestampBytes = recvMsg[0:7]     
         timestampBytes.reverse()
         timestamp = bytearrayToNumber(timestampBytes)
         recvMsg = recvMsg[8:] # remove timestamp bytes from msg before decoding
   
         period_ns = 6.4
         print('\033[33m[RX]:\033[39m \ttimestamp: {} cycles ({} ns)\n'
                     .format(timestamp, timestamp*period_ns))
      except:
         #print "\t... no valid packet received"
         #print("Unexpected error:", sys.exc_info()[0])
         pass
      
      # enc/dec test
      #fudgeFactor = 0.99
      #if(float(price) < fudgeFactor*price_dec or fudgeFactor*float(price) > price_dec):
      #   print "\tprice mismatch"; 
      #   print "\t" + str(price); 
      #   print "\t" + str(price_dec);
      #if(orderID_dec != int(orderID)):
      #   print "\torderID mismatch"; 
      #   print "\t" + str(orderID); 
      #   print "\t" + str(orderID_dec);
      #if(int(quantity) != quantity_dec):
      #   print "\tquantity mismatch"; 
      #   print "\t" + str(quantity); 
      #   print "\t" + str(quantity_dec);

      # BRETT : print debuyg stuff here

      #print "send\n===="
      #for i,byte in enumerate(packetData):
      #   if i%8==0 : print ''
      #   print "{0:b}".format(byte).rjust(8,'0')
      #print "recv\n==== {}".format(len(recvMsg))
      #for i,byte in enumerate(recvMsg):
      #   if i%8==0 : print ''
      #   print "{0:b}".format(byte).rjust(8,'0')

      # append new order into either bid/ask side
      if(transType == 'BID'):
         self.bids.append((price,quantity,orderID))
      elif (transType == 'ASK'):
         self.asks.append((price,quantity,orderID))
      # filter out all orders that match incoming ID
      elif(transType == 'RMBID'):
         self.bids = [bid for bid in self.bids if bid[2]!=orderID]
      elif (transType == 'RMASK'):
         self.asks = [ask for ask in self.asks if ask[2]!=orderID]
      elif (True):
         print "could not understand orderID {}".format(orderID)
         return True

      # sort lists and display
      if drawFlag:
         self.draw_fin_data()
      
      return True
  

   def draw_fin_data(self):
       self.bids.sort(reverse=True)
       self.asks.sort()
       # decompose tuples into sep lists
       bid_prices=[]; bid_quan=[]; bid_orderID=[];
       ask_prices=[]; ask_quan=[]; ask_orderID=[];
       if len(self.bids) : bid_prices,bid_quan,bid_orderID = zip(*self.bids)
       if len(self.asks) : ask_prices,ask_quan,ask_orderID = zip(*self.asks)
     
       #print "BID PRICES " + bid_prices 
       data = [bid_prices,bid_quan,bid_orderID,ask_prices,ask_quan,ask_orderID]
       self.draw(data)

   def stepAll(self):
      while(self.step(False)): pass
      self.draw_fin_data()

   # sends and receives a bytearray from the FPGA
   # (bytearray a) => a -> a
   def sendPacket(self,s,ba):
      hostIPAddr = '1.1.1.1'
      port        = 641
      recvMsg = bytes([])
      try:
         # send packet
         s.sendto(ba, (hostIPAddr, port))
         # receive
         recvMsg, serverAddress = s.recvfrom(2048)
      except socket.timeout:
         pass
      recvMsg = bytearray(recvMsg)
      return recvMsg
   
   # creates network socket
   def initSocket(self):
      # XXX forces eth3 interface to be 1.1.1.2
      print "[INFO] setting eth3 to ip addr 1.1.1.2"
      call(["sudo ifconfig eth3 1.1.1.2"],shell=True)

      s = socket.socket(AF_INET, SOCK_DGRAM)
      s.settimeout(0.01);
      return s
