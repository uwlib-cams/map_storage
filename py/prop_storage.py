# This is a class created to store data related to properties 
# retrieved from xml files before updating
# last updated: 8/29/2023

class Prop:

    def __init__(self, id):

        self.id = id
        self.prop_string = ""
        self.prop_iri = ""
        self.sinopia_element = ""
        self.is_deprecated = ""

    def set_prop_string(self, prop_string):
        self.prop_string = prop_string
        
    def set_prop_iri(self, prop_iri):
        self.prop_iri = prop_iri
    
    def set_sinopia_element(self, sinopia_element):
        self.sinopia_element = sinopia_element

    def set_is_deprecated(self, is_deprecated):
        self.is_deprecated = is_deprecated

    def get_prop_string(self):
        prop_string = self.prop_string
        return prop_string

    def get_sinopia_element(self):
        implementation_string = self.sinopia_element
        return implementation_string
    
    def get_prop_iri(self):
        iri_string = self.prop_iri
        return iri_string