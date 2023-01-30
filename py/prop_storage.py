# This is a class created to store data related to properties 
# retrieved from xml files for updates 

class Prop:

    def __init__(self, id):

        self.id = id
        self.prop_iri = ""
        self.prop_label = ""
        self.prop_domain = ""
        self.implementationset = ""

    def set_prop_iri(self, prop_iri):
        self.prop_iri = prop_iri
    
    def set_prop_label(self, prop_label):
        self.prop_label = prop_label

    def set_prop_domain(self, prop_domain):
        self.prop_domain = prop_domain
    
    def set_implementation_set(self, implementation_set):
        self.implementationset = implementation_set

    def print_prop(self):
        print(
            '<prop localid_prop="'+self.id+'">\n'+
            '\t'+self.prop_iri+
            '\t'+self.prop_label+
            '\t'+self.prop_domain
        )
        if self.implementationset != "":
            print(
                '\t'+self.implementationset
            )
        print(
            '</prop>'
        )