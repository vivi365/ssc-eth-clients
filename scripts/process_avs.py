import json
  
def read(file: str):
    with open(file, 'r') as f:
        try:
            data = json.load(f)
            return data
        except Exception as e:
            print(f"Error while reading json: {e}")
            return      
         
def write(data, file_name):
    json_data = json.dumps(data, indent=1)
    with open(file_name, 'w') as out:
        out.write(json_data)

def filter_avs(data, ids):
    filtered_data = []
    for item in data:
        if item.get('avId') not in ids:
            if item.get('children'):
                item['children'] = filter_avs(item['children'], ids)
            filtered_data.append(item)
    return filtered_data


def add_properties(data, properties: list):
    # list of strings pls.
    for av in data:
        for prop in properties:
            av[prop] = []
    return data
  

def count_avs(data):
    count = 0
    for item in data:
        if 'children' in item:
            count += count_avs(item['children'])
        count += 1
    return count
    
    
def main():
    # AV filters
    user_compromise_ids =  ['AV-600', 'AV-601', 'AV-602', 'AV-603', 'AV-604', 'AV-605', 'AV-606', 'AV-607', 'AV-608']
    social_engineering_ids = ['AV-800', 'AV-801']
    name_confusion_children = ['AV-201', 'AV-202', 'AV-203', 'AV-204', 'AV-205', 'AV-206', 'AV-207', 'AV-208', 'AV-209']
    go_inapplicable = ['AV-509']
    root = ['AV-000']
    
    all_filters = user_compromise_ids + social_engineering_ids + name_confusion_children + go_inapplicable

    # attackvectors.json
    # todo path "resolution"
    original_avs = read('data/attackvectors/original/attackvectors.json')
    avs_filtered = filter_avs(original_avs, all_filters + root)
    #data_prop = add_properties(avs_filtered, ['targets', 'properties'])
    write(avs_filtered, 'data/attackvectors/filtered/attackvectors.json')
            
    # taxonomy.json
    original_taxonomy = read('data/attackvectors/original/taxonomy.json') # note: square brackets added to original file for ease of filter
    taxonomy_filtered = filter_avs(original_taxonomy, all_filters)
    write(taxonomy_filtered, 'data/attackvectors/filtered/taxonomy.json')
    
if __name__ == "__main__":
    main()
    