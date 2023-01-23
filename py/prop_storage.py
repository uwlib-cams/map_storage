class Prop:

    def __init__(self, id):

        self.id = id
        self.prop_iri = ""
        self.prop_label = ""
        self.prop_domain = ""
        self.implementationset = ""

    def setProp_iri(self, prop_iri):
        self.prop_iri = prop_iri
    
    def setProp_label(self, prop_label):
        self.prop_label = prop_label

    def setProp_domain(self, prop_domain):
        self.prop_domain = prop_domain
    
    def setImplementation_set(self, implementation_set):
        self.implementationset = implementation_set

    def printProp(self):
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