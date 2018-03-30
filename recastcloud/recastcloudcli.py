import yaml
import base64
import sys
import os
import click


@click.group()
def cloudcli():
    pass

@cloudcli.command()
@click.argument('infile')
@click.option('-b','--filebase', default = os.getcwd() )
@click.option('-o','--outfile', default=None)
def make_helm_values(infile,filebase,outfile):
    data = yaml.load(open(infile))

    for k,v in data.get('files',{}).items():
        filetoget = os.path.join(filebase,v)
        data['files'][k] = base64.b64encode(open(filetoget,'rb').read()).decode('utf-8')


    if outfile:
        yaml.dump(data,open(outfile,'w'), default_flow_style = False)
    else:
        print(yaml.dump(data))
