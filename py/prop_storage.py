# This is a class created to store data related to properties 
# retrieved from xml files before updating
# last updated: 2/27/2023

class Prop:

    def __init__(self, id):

        self.id = id
        self.prop_string = ""
        self.prop_iri = ""
        self.implementation_set = ""
        self.is_deprecated = ""

    #formatted for etree
    def set_prop_string(self, prop_string):
        self.prop_string = prop_string
        
    def set_prop_iri(self, prop_iri):
        self.prop_iri = prop_iri
    
    def set_implementation_set(self, implementation_set):
        self.implementation_set = implementation_set

    def set_is_deprecated(self, is_deprecated):
        self.is_deprecated = is_deprecated

    def get_prop_string(self):
        prop_string = self.prop_string
        add_string = '<prop xmlns="https://uwlib-cams.github.io/map_storage/xsd/" xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/" localid_prop="' + self.id + '">'
        prop_string = prop_string.replace('<prop>', add_string)
        return prop_string

    #formatted for etree
    def get_implementation_set(self):
        implementation_string = self.implementation_set
        add_string = '<sinopia xmlns="https://uwlib-cams.github.io/map_storage/xsd/" xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/">'
        implementation_string = implementation_string.replace('<sinopia>', add_string)
        return implementation_string
    
    #only for printing
    def get_prop_iri(self):
        iri_string = self.prop_iri
        iri_string = iri_string.split('"')[1].split('"')[0]
        return iri_string