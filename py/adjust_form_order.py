import lxml.etree as ET
import os

###

def locate_RTs():
	sinopia_maps_repo = os.listdir('..')
	RT_list = []
	for file in sinopia_maps_repo:
		if file[0:9] == "prop_set_" and file[-4:] == ".xml":
			RT_list.append(file)

	return RT_list

def create_RT_dict():
	RT_dict = {}

	tree = ET.parse('../../sinopia_maps/xml/sinopia_maps.xml')

	uwsinopia_sinopia_maps = tree.getroot()

	RT_list = uwsinopia_sinopia_maps.findall('{https://uwlib-cams.github.io/sinopia_maps/xsd/}rts/{https://uwlib-cams.github.io/sinopia_maps/xsd/}rt')

	for uwsinopia_RT in RT_list:
		institution = uwsinopia_RT.find('{https://uwlib-cams.github.io/sinopia_maps/xsd/}institution')
		institution_text = institution.text

		resource = uwsinopia_RT.find('{https://uwlib-cams.github.io/sinopia_maps/xsd/}resource')
		resource_text = resource.text

		format = uwsinopia_RT.find('{https://uwlib-cams.github.io/sinopia_maps/xsd/}format')
		format_text = format.text

		user = uwsinopia_RT.find('{https://uwlib-cams.github.io/sinopia_maps/xsd/}user')
		user_text = user.text

		ID_tuple = (institution_text, resource_text, format_text, user_text)

		RT_dict[ID_tuple] = {}

	return RT_dict

def create_form_order_dict(RT_dict, prop_set):
	tree = ET.parse(f'../{prop_set}')

	uwmapstorage_prop_set = tree.getroot()

	filled_out_props = uwmapstorage_prop_set.findall('{https://uwlib-cams.github.io/map_storage/xsd/}prop[{https://uwlib-cams.github.io/map_storage/xsd/}sinopia]')

	for uwmapstorage_prop in filled_out_props:
		uwsinopia_implementation_set_list = uwmapstorage_prop.findall('{https://uwlib-cams.github.io/map_storage/xsd/}sinopia/{https://uwlib-cams.github.io/sinopia_maps/xsd/}implementation_set')

		for implementation_set in uwsinopia_implementation_set_list:
			institution = implementation_set.find('{https://uwlib-cams.github.io/sinopia_maps/xsd/}institution')
			institution_text = institution.text

			resource = implementation_set.find('{https://uwlib-cams.github.io/sinopia_maps/xsd/}resource')
			resource_text = resource.text

			format = implementation_set.find('{https://uwlib-cams.github.io/sinopia_maps/xsd/}format')
			format_text = format.text

			user = implementation_set.find('{https://uwlib-cams.github.io/sinopia_maps/xsd/}user')
			user_text = user.text

			ID_tuple = (institution_text, resource_text, format_text, user_text)

			localid_implementation_set = implementation_set.attrib['localid_implementation_set']

			form_order = implementation_set.find('{https://uwlib-cams.github.io/sinopia_maps/xsd/}form_order')
			form_order_value = form_order.text

			RT_dict[ID_tuple][form_order_value] = localid_implementation_set

	return RT_dict

def create_new_form_order_values(RT_dict):
	new_RT_dict = {}

	for key in RT_dict:
		new_form_order_dict = {}

		OG_form_order_dict = RT_dict[key]

		sorted_form_order_dict = dict(sorted(OG_form_order_dict.items()))

		new_form_order_value = 0.000

		for old_form_order_value in sorted_form_order_dict.keys():
			localid_implementation_set = sorted_form_order_dict[old_form_order_value]
			if new_form_order_value == 0.000:
				new_form_order_dict[localid_implementation_set] = 0.001
			else:
				new_form_order_dict[localid_implementation_set] = new_form_order_value

			new_form_order_value += 0.005
			new_form_order_value = round(new_form_order_value, 3)

		new_RT_dict[key] = new_form_order_dict

	return new_RT_dict

def replace_form_order(RT_dict):
	prop_set_list = locate_RTs()

	for prop_set in prop_set_list:
		tree = ET.parse(f'../{prop_set}')

		uwmapstorage_prop_set = tree.getroot()

		filled_out_props = uwmapstorage_prop_set.findall('{https://uwlib-cams.github.io/map_storage/xsd/}prop[{https://uwlib-cams.github.io/map_storage/xsd/}sinopia]')

		for uwmapstorage_prop in filled_out_props:
			uwsinopia_implementation_set_list = uwmapstorage_prop.findall('{https://uwlib-cams.github.io/map_storage/xsd/}sinopia/{https://uwlib-cams.github.io/sinopia_maps/xsd/}implementation_set')

			for implementation_set in uwsinopia_implementation_set_list:
				localid_implementation_set = implementation_set.attrib['localid_implementation_set']

				institution = implementation_set.find('{https://uwlib-cams.github.io/sinopia_maps/xsd/}institution')
				institution_text = institution.text

				resource = implementation_set.find('{https://uwlib-cams.github.io/sinopia_maps/xsd/}resource')
				resource_text = resource.text

				format = implementation_set.find('{https://uwlib-cams.github.io/sinopia_maps/xsd/}format')
				format_text = format.text

				user = implementation_set.find('{https://uwlib-cams.github.io/sinopia_maps/xsd/}user')
				user_text = user.text

				ID_tuple = (institution_text, resource_text, format_text, user_text)

				new_form_order_dict = RT_dict[ID_tuple]

				localid_implementation_set = implementation_set.attrib['localid_implementation_set']

				form_order = implementation_set.find('{https://uwlib-cams.github.io/sinopia_maps/xsd/}form_order')

				try:
					form_order.text = str("{0:.3f}".format(new_form_order_dict[localid_implementation_set]))
				except:
					"""nothing"""

		tree.write(f'../{prop_set}')

###

RT_dict = create_RT_dict()

prop_set_list = locate_RTs()

for prop_set in prop_set_list:
	RT_dict = create_form_order_dict(RT_dict, prop_set)

RT_dict = create_new_form_order_values(RT_dict)

replace_form_order(RT_dict)
