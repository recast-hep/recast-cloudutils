from setuptools import setup, find_packages

setup(
  name = 'recast-cloudutils',
  version = '0.1.0',
  description = 'cloud deployment tools for RECAST',
  long_description =  'cloud deployment tools for RECAST',
  url = 'http://github.com/recast-hep/recast-cloudutils',
  author = 'Lukas Heinrich',
  author_email = 'lukas.heinrich@cern.ch',
  packages=find_packages(),
  install_requires = [
    'Click',
    'pyyaml'
  ],
  entry_points = {
    'console_scripts': [
      'recast-cloud = recastcloud.recastcloudcli:cloudcli',
    ]
  },
  include_package_data = True,
  zip_safe=False
)
