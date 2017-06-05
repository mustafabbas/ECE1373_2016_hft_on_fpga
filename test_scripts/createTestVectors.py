#!/usr/bin/python2.7
import random
import sys

# createTestVectors - generates random orders according to 
# a normal distribution for price and an exponential dist
# for quantity

mu    = 27.5  # average price 
sigma = 3    # std deviation of price     
lmbda = 1    # quantity distribution "steepness"
lmbda = 50  # average quantity
startingSize = 33
testSize = startingSize + 10000

q=[]
existingOrders = []

for i in range(1,testSize):
   orderID = i
   transType = "BID" if (random.uniform(0,100)>49) else "ASK"

   # half of orders add an order to table, after the first 100
   if( (random.uniform(0,2) > 1 or i < startingSize) and len(existingOrders) < 2*startingSize ):
      # quantity is an exponential distribution (high values are rarer than small trades)
      quantity = int (round (100 * (random.expovariate(1))))
      quantity = quantity if quantity < 255 else 255 # quantity cannot exceed 255
      price    = random.gauss(mu,sigma)
      print "{0} {1:.2f} {2} {3}".format(orderID,price,quantity,transType)
      
      existingOrders.append((orderID,price,quantity,transType))
   
   # ... other half of orders are removes
   else:
      #print "len : " + str(len(existingOrders))
      if len(existingOrders) > 0 : 
         itemToRemove = random.choice(existingOrders)
         existingOrders.remove(itemToRemove)

         #print "removing -> " +  str(itemToRemove)
         orderID, _, quantity, transType = itemToRemove
         transType = "RMBID" if transType is "BID" else "RMASK"
         print "{0} {1:.2f} {2} {3}".format(orderID,101.1,quantity,transType)
   
