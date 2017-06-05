import sys
import datetime
import binascii
import os.path
import struct
import math
import copy

print_hex=0
typeToInt = {"BID" : 3, "ASK" : 2, "RMBID" : 5 , "RMASK" : 4}
inttoType = {3 : "BID",  2 : "ASK" , 5 : "RMBID" , 4:  "RMASK" }

# packetData :: String 
def decodeFASTPacket(packetData):

   packetChars = iter(list(packetData))
   # remove pmap and template id bytes  
   for i in range(0,2): packetChars.next()

   # read exp
   exp_unsigned = getNextField(packetChars,"exp") 
   # dirty hack
   exp =  -(128 - exp_unsigned) if(exp_unsigned >= 63) else exp_unsigned

   #print "exp (7b unsigned) : {}".format(exp)
   
   # read in mantissa
   man = getNextField(packetChars,"man") 
   #print "man: " + str(man)
   
   price = man * pow(10,exp)
   #print "price : {}".format(price)

   # msg size 
   quantity = getNextField(packetChars,"quan")
   #print "quantity : " + str(quantity)

   # order_id
   orderId  = getNextField(packetChars,"orderID")
   #print "order id : " + str(orderId)
   
   # order_id
   transType_enum  = getNextField(packetChars,"trans type")
   try : 
      transType  = next(key for key,value in typeToInt.items() if value == transType_enum)
   except Exception as e: 
      transType = transType_enum
   #print "type : " + str(transType)

   return (price,quantity,orderId,transType)


def getNextField(byteIter,string=""):
   chars=[]
   ch = byteIter.next()
   chars.append(ch)
   while not checkStopBit(ch) :
      ch = byteIter.next()
      chars.append(ch)

   chars.reverse() # reverse all fields bc big endian
  
   #print "{}\n=====".format(string)
   #for c in chars:
   #   print "{0:b}".format(c,'b')

   return removeStopBit(chars)

# ch :: Char => Char -> Bool
def checkStopBit(ch):
   return (ch & 0x80)

# chars :: [Char] => [Char] -> Int 
def removeStopBit(chars):
   accum=0
   for i,ch in enumerate(chars):
      ch = ch & 0x7F # mask out the top bit
      accum |= ch << 7*i # place value in correct bit position in accum
   return accum

# packs a string and integer into a FAST packet complete with stop bits
def encodeFASTPacket(orderID,price,quantity,transType):
   # NOTE: these enums may not be correct; need to confirm.

   #ba = bitarray.bitarray() 
   ba = bytearray([])
   
   # create empty presence map and template ID bytes
   presence_map_bf = addStopBits(bitfield(0))
   template_id_bf  = addStopBits(bitfield(0))
   
   ba = ba + bitfieldToByteArray(presence_map_bf)
   ba = ba + bitfieldToByteArray(template_id_bf)

   # append stock val
   (exponent,mantissa) = ToFastFP(float(price))
   #print "exponent : " + str(exponent)
   #print "mantissa : " + str(mantissa)
   exp_bf = addStopBits(bitfield(exponent))
   man_bf = bitfield(mantissa)
   
   # append an extra zero to mantissa to avoid interpretation as a signed number
   man_bf =  man_bf + [False]
   man_bf = addStopBits(man_bf)

   ba = ba + bitfieldToByteArray(exp_bf)
   mantissaBytes = endianSwitch( bitfieldToByteArray(man_bf) )
   if len(mantissaBytes) > 3:
      print "mantissa is too long!"
   ba = ba + mantissaBytes
   
   # get size
   size_bf = addStopBits(bitfield(int(quantity)))
   ba = ba + endianSwitch( bitfieldToByteArray(size_bf) )
   #print " quantity : " 
   #print_bitfield(size_bf)

   # create unique order_id (orderID is padded to 32 bits always)
   order_id_bf = addStopBits( padBitfield( bitfield( int(orderID)),32))
   ba = ba + endianSwitch( bitfieldToByteArray(order_id_bf) )

   # get type enum
   type_bf = addStopBits(bitfield(typeToInt[transType]))
   ba = ba + bitfieldToByteArray(type_bf)

   return ba

def endianSwitch (bytearr):
   rev = copy.deepcopy(bytearr)
   rev.reverse()

   # fix stop bits
   rev[0]  &= 0x7F # force old last byte sb -> 0
   rev[-1] |= 0x80 # force new last byte sb -> 1 

   return rev # XXX NOT DOING ANYTHING

def bitfieldToByteArray(bf):
   bytearr = bytearray([])
   # create bytearr with elements in the correct places 
   for i in range(0,((len(bf)+7)/8)): 
      bytearr.append(0)

   for pos,bit in enumerate(bf):
      bit = int(bit)
      byteIndex = pos/8
      bitIndex  = pos%8
      bytearr[byteIndex] += bit  << bitIndex

   return bytearr 

# converts a FP number to a base10 mantissa and exponent 
def ToFastFP(price):
   assert(price >= 1) # only supporting prices with negative exp

   exp=0;
   trailing_digits , _ = math.modf(price); 
   while(trailing_digits and exp > -3): # only allow up to 4 sig digs
      exp = exp - 1 
      trailing_digits , _ = math.modf(price*math.pow(10,-exp)); 
   
   mantissa = int(round(price*math.pow(10,-exp)))
   return (exp,mantissa)

# prints a bitfield array from msb to lsb
def print_bitfield(bf):
   for ind,bit in enumerate(reversed(bf)):
      if((len(bf)-ind)%4==0): sys.stdout.write(" ")
      if(bit):
         sys.stdout.write('1')
      else:
         sys.stdout.write('0')
   #print ''

# converts int to list of bool vals repr bits (i.e. [True, False, True, False] == 1010)
def bitfield(n):
   n = n if (n>=0) else  (127 + n + 1) 
   bits = [bool(int(digit)) for digit in bin(n)[2:]]
   bits.reverse()
   return bits

def padBitfield(bf,n):
   diff = n - len(bf) 
   if diff > 0 :
      for i in range(0,diff):
         bf.append(False);
   return bf
      

# adds stop bits to bitfield - packs 
def addStopBits(bitfield):
   bf=[]
   # pad to byte boundary minus stop bits
   numBytes  = (len(bitfield) + 6)/7 # every seven bits needs another byte
   paddedLen = 7*numBytes
   finalLen  = 8*((paddedLen+7)/8)
   bitfield += [False] * (paddedLen - len(bitfield))
  
   i=0
   for bit in bitfield:
      bf.append(bit)
      i+=1
      if(i%8==7):
         stop_bit = True if (i+1 == finalLen) else False
         bf.append(stop_bit)
         i+=1
   return bf

def readFASTFile(filename):
   kExpectedTokensPerLine = 4

   with open(filename, 'r') as fh:
      try:
         for lineno,line in enumerate(fh):
            tok = line.split()

            if len(tok)!=kExpectedTokensPerLine:
               raise ValueError('Line [{}] in file \'{}\' is ill-formed; terminating ...'.format(lineno,filename))

            orderID,price,quantity,transType = (tok[0],tok[1],tok[2],tok[3])

            packetizedData = encodeFASTPacket(orderID,price,quantity,transType)

            # always test encoded value to see if it is sane
            #price_dec,quantity_dec,orderID_dec,transType_dec = decodeFASTPacket(copy.deepcopy(packetizedData))
            #if (price_dec < 0.99*float(price)) or (0.99*price_dec > float(price)) or (quantity_dec!=int(quantity)) or (transType != transType_dec) or (int(orderID)!=orderID_dec):
            #   print "\nENC/DEC values do not agree in SW!\n"
            #   print """\noriginal\n-------------
            #            \nprice {} \nquantity {}\n orderID {}\n type {} \n""".format(price,quantity,orderID,transType)
            #   print """\ndecode\n-------------
            #            \nprice {} \nquantity {}
            #            \n orderID {}\n type {} \n""".format(price_dec,quantity_dec,orderID_dec,transType_dec)
            #print 'packet sent \n==============='
            #for i,byte in enumerate(packetizedData):
            #   if i%8==0 : print ''
            #   print "byte[{}]:".format(i) + format(byte,'b').rjust(8,'0')

            yield(packetizedData,(int(orderID),float(price),int(quantity),transType))

      except (ValueError) as e:
         print("\n" + repr(e) + "\n")
         exit()

