#!/usr/bin/python

import sys
import os
from Crypto.Hash import SHA512

print ('Number of arguments:', len(sys.argv), 'arguments.')
print ('Argument List:', str(sys.argv))

if len(sys.argv) != 2 :
  print('Usage:  storefile  filename');
  print('  Computes the SHA512 of the file, and copies the file into the object store');
  halt()
else :
  SourceFileName = str(sys.argv[1]);
  print('so far, good to go [',SourceFileName,']');
 
  f = open(SourceFileName,"rb")
  buffer = f.read()
  f.close()

  print(' file read, ',len(buffer),' bytes long');
  h_obj = SHA512.new(buffer)

  hash = h_obj.hexdigest()
  print(' hash = ',hash);

  prefix   = hash[:2];
  filename = hash[2:];

  newname = prefix + '/' + filename;

  print(' new pathname = ',newname);

  if not os.path.exists(prefix):
    os.makedirs(prefix)

  if os.path.exists(newname) :
    f = open(newname,"rb");
    verifybuffer = f.read()
    f.close

    if buffer != verifybuffer :
      print(' new contents != old contents, SHA512 collision happened!');
      halt();
  else : 
    f = open(newname,"wb");
    f.write(buffer);
    f.close;
    print(' File copied into ',newname);

  

  

