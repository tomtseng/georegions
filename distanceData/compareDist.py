import os
import sys

def compare(numLines=33143,
            accurateFile=os.path.dirname(os.path.realpath(__file__))+"/accurateDist.txt",
            approxFile=os.path.dirname(os.path.realpath(__file__))+"/approxDist.txt"):
  numLines = int(numLines)
  actual = {}
  approx = {}

  with open(accurateFile, 'r') as f:
    for i in range(numLines):
      vals = f.readline().split()
      actual[vals[0]] = float(vals[1])
  with open(approxFile, 'r') as f:
    for line in f.readlines():
      vals = line.split()
      approx[vals[0]] = float(vals[1])

  sumAbsError = 0.0
  count = 0

  for k in actual:
    if k not in approx:
      sys.stderr.write("No such zipcode: %s\n" % str(k))
    elif actual[k] != 0:
        sumAbsError += abs((approx[k] - actual[k])/actual[k])
        count += 1

  print "Mean absolute percentage error of %f%%" % (sumAbsError * 100 / count)

compare(*sys.argv[1:])
