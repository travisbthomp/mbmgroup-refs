from setuptools import setup, find_packages

setup(
    name='connectome_atrophy',
    version='0.1',
    description='A toolbox for mapping brain image analysis to a connectome',
    license='Apache License',
    maintainer='Pavan Chaggar, Travis Thompson, Alain Goriely',
    maintainer_email='pavanjit.chaggar@maths.ox.ac.uk; travis.thompson@maths.ox.ac.uk; goriely@maths.ox.ac.uk',
    include_package_data=True,
    packages = find_packages(include=('Main', 'Main.*')),
    install_requires=[
        'nibabel',
        'numpy',
        'pandas'
    ],
)