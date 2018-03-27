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
@click.argument('filebase')
@click.argument('outfile')
def make_helm_values(infile,filebase,outfile):
    data = yaml.load(open(infile))

    for k,v in data['files'].items():
        filetoget = os.path.join(filebase,v)
        click.secho('getting file {}'.format(filetoget))
        data['files'][k] = base64.b64encode(open(filetoget,'rb').read())


    yaml.dump(data,open(outfile,'w'), default_flow_style = False)
