from prop_storage import Prop
import xml.etree.ElementTree as ET 
import re
import sys

p70k = []

def RemoveNameSpace(xmlString): 
    re_ns = ' xmlns="[^ ]*'
    re_uwns = ' xmlns[^>]*'
    re_xml = "<\?xml version='1\.0' encoding='utf8'\?>\n"

    xmlString = re.sub(re_ns, '', xmlString)
    xmlString = re.sub(re_uwns, '', xmlString)
    xmlString = re.sub(re_xml, '', xmlString)
    return xmlString

tree = ET.parse('./prop_set_rdat_p70k.xml')
ET.register_namespace('', "https://uwlib-cams.github.io/map_storage/xsd/")
ET.register_namespace('dcam', "http://purl.org/dc/dcam/")
ET.register_namespace('owl', "http://www.w3.org/2002/07/owl#")
ET.register_namespace('prov', "http://www.w3.org/ns/prov#")
ET.register_namespace('rdf', "http://www.w3.org/1999/02/22-rdf-syntax-ns#")
ET.register_namespace('rdfs', "http://www.w3.org/2000/01/rdf-schema#")
ET.register_namespace('reg', "http://metadataregistry.org/uri/profile/regap/")
ET.register_namespace('uwsinopia', "https://uwlib-cams.github.io/sinopia_maps/xsd/")
ET.register_namespace('xs', "http://www.w3.org/2001/XMLSchema")
ET.register_namespace('xsi', "http://www.w3.org/2001/XMLSchema-instance")

root = tree.getroot()

for prop in root.iter('{https://uwlib-cams.github.io/map_storage/xsd/}prop'):
    newProp = Prop(prop.attrib['localid_prop'])
    for child in prop.iter():
        if child.tag == "{https://uwlib-cams.github.io/map_storage/xsd/}prop_iri":
            newProp.setProp_iri(RemoveNameSpace(ET.tostring(child, encoding='utf8').decode('utf8')))
        if child.tag == "{https://uwlib-cams.github.io/map_storage/xsd/}prop_label":
            newProp.setProp_label(RemoveNameSpace(ET.tostring(child, encoding='utf8').decode('utf8')))
        if child.tag == "{https://uwlib-cams.github.io/map_storage/xsd/}prop_domain":
            newProp.setProp_domain(RemoveNameSpace(ET.tostring(child, encoding='utf8').decode('utf8')))
        if child.tag == "{https://uwlib-cams.github.io/map_storage/xsd/}sinopia":
            newProp.setImplementation_set(RemoveNameSpace(ET.tostring(child, encoding='utf8').decode('utf8')))
    p70k.append(newProp)

print(len(p70k))

p70k[0].printProp()
