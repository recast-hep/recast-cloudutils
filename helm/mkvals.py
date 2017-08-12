import yaml
import base64
import sys
import os

infile = sys.argv[1]
filebase = sys.argv[2]
outfile = sys.argv[3]

print 'massaging {} {} {}'.format(infile,filebase,outfile)
data = yaml.load(open(infile))

for k,v in data['files'].items():
    filetoget = os.path.join(filebase,v)
    print 'getting file {}'.format(filetoget)
    data['files'][k] = base64.b64encode(open(filetoget).read())


yaml.dump(data,open(outfile,'w'), default_flow_style = False)
