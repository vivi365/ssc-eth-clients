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


def remove_avs(data, ids, remove_all_except=False):
    filtered_data = []
    for item in data:
        if (item.get('avId') in ids and not remove_all_except) or (item.get('avId') not in ids and remove_all_except):
            if item.get('children'):
                item['children'] = remove_avs(item['children'], ids, remove_all_except)
            filtered_data.append(item)
    return filtered_data

def remove_avss(data, ids):
    filtered_data = []
    for item in data:
        if item.get('avId') not in ids:
            if item.get('children'):
                item['children'] = remove_avs(item['children'], ids)
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


    # read
    original_avs = read('data/attackvectors/original/attackvectors.json')
    original_taxonomy = read('data/attackvectors/original/taxonomy.json') # note: square brackets added to original file for ease of filter

    # filter source avs
    source_ids = [('AV-30' + str(i)) for i in range(10)] + [('AV-60' + str(j)) for j in range(9)] + [('AV-70' + str(k)) for k in range(4)] + ['AV-800', 'AV-801']
    source_avs = remove_avs(original_avs, source_ids, remove_all_except=False)
    source_avs = remove_avs(source_avs, user_compromise_ids + social_engineering_ids + go_inapplicable, remove_all_except=True)
    source_taxonomy = remove_avs(original_taxonomy, source_ids + ['AV-000', 'AV-001'])
    source_taxonomy = remove_avs(source_taxonomy, user_compromise_ids + social_engineering_ids + go_inapplicable, remove_all_except=True)

    write(source_avs, 'data/attackvectors/filtered/source-attackvectors.json')
    write(source_taxonomy, 'data/attackvectors/filtered/source-taxonomy.json')

    # attackvectors.json
    # todo path "resolution"
    original_avs = read('data/attackvectors/original/attackvectors.json')
    avs_filtered = remove_avs(original_avs, all_filters + root)
    #data_prop = add_properties(avs_filtered, ['targets', 'properties'])
    write(avs_filtered, 'data/attackvectors/filtered/attackvectors.json')
            
    # taxonomy.json
    original_taxonomy = read('data/attackvectors/original/taxonomy.json') # note: square brackets added to original file for ease of filter
    taxonomy_filtered = remove_avs(original_taxonomy, all_filters)
    write(taxonomy_filtered, 'data/attackvectors/filtered/taxonomy.json')
    
if __name__ == "__main__":
    main()
    