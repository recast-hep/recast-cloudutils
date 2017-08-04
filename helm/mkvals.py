import yaml

data = yaml.load(open('./myvals.yml'))

for k,v in data['files'].items():
	data['files'][k] = open(v).read()


yaml.dump(data,open('myfiles_filled.yml','w'), default_flow_style = False)
