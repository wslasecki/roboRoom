#!/bin/python

# Echo client program
import socket
import time

HOST = 'localhost'    # The remote host
PORT = 8000              # The same port as used by the server
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

s.connect((HOST, PORT))


s.send('0,22.45,18.61,207.4\n')
s.send('7,1.45,8.31,45.4\n')

#s.send('"A1 name",17.5,17.5,6.2\n')
#s.send('"B1 name",32.45,27.1,73.5\n')
#s.send('"C1 name",1.45,8.31,45.4\n')
#time.sleep(3)
#s.send('them,22.45,28.61,37.4\n')
#s.send('"B2 name",32.45,27.1,73.5\n')
#s.send('"C2 name",1.45,8.31,45.4\n')
#time.sleep(3)
#s.send('"A3 name",22.45,38.61,37.4\n')
#s.send('"B3 name",32.45,27.1,73.5\n')

print("Done")
