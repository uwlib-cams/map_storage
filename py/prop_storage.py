# This is a class created to store data related to properties 
# retrieved from xml files before updating
# last updated: 2/10/2023

class Prop:

    def __init__(self, id):

        self.id = id
        self.prop_string = ""
        self.prop_iri = ""
        self.prop_label = ""
        self.prop_domain = ""
        self.implementation_set = ""

    def set_prop_string(self, prop_string):
        add_string = '<prop xmlns="https://uwlib-cams.github.io/map_storage/xsd/" xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/" localid_prop="' + self.id + '">'
        prop_string = prop_string.replace('<prop>', add_string)
        self.prop_string = prop_string
        
    def set_prop_iri(self, prop_iri):
        self.prop_iri = prop_iri
    
    def set_prop_label(self, prop_label):
        self.prop_label = prop_label

    def set_prop_domain(self, prop_domain):
        self.prop_domain = prop_domain
    
    def set_implementation_set(self, implementation_set):
        self.implementation_set = implementation_set

    def print_prop(self):
        prop_string = '<prop localid_prop="'+ self.id+'">\n'+'\t'+self.prop_iri + '\t'+self.prop_label +'\t'+self.prop_domain
        if self.implementation_set != "":
            prop_string = prop_string + '\t'+self.implementation_set
        prop_string = prop_string + '</prop>'
        print(prop_string)

    def get_prop_string(self):
        return self.prop_string

    def get_implementation_set(self):
        return self.implementation_set