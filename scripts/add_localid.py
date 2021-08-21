import os
from sys import argv
import xml.etree.ElementTree as ET

"""Set variables for input and output files"""
script, map_storage_filepath = argv # filepath from command line
map_storage_output = map_storage_filepath.rstrip('.xml') # remove end of filepath
map_storage_output = map_storage_output + "_localid.xml" # add new end to filepath for output

"""Open Element Tree"""
tree = ET.parse(map_storage_filepath)
root = tree.getroot()
ns = {'mapstor': 'https://uwlib-cams.github.io/map_storage/'} # establish namespace

"""Add local id to implementation sets"""
for prop in root.findall('.//*[@localid_prop]', ns): # loop through all properties
	prop_num = prop.attrib['localid_prop']
	prop_num = prop_num.split('/')[-1] # get property number from local id
	id_num = 1
	for implementation_set in prop.findall('.//mapstor:implementationSet', ns): # loop through all implementation sets within each property
		localid = f'is_{prop_num}_{id_num:03}'
		implementation_set.set('localid_implementationSet', localid) # set local id as value for attribute localid_implementationSet
		id_num += 1
tree.write(map_storage_output) # write results to output file

"""Remove name Element Tree adds to default prefix"""
# element tree replaces default prefix with ns0: # remove all instances of this
original = open(map_storage_output, "rt")
find_and_replace = original.read()
find_and_replace = find_and_replace.replace("ns0:", "")
find_and_replace = find_and_replace.replace(":ns0", "")
original.close()
new = open(map_storage_output, "wt")
new.write(find_and_replace)
new.close()

os.rename(map_storage_output, map_storage_filepath)
