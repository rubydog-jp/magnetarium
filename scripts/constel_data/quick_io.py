import json
import os

dir = os.path.dirname(__file__)


# json = read('input/file.text')
def read(file):
    print('R: ' + file)
    with open(dir + '/' + file) as f:
        data = json.load(f)
    return data


# write('output/file.text', json)
def write(file, data):
    print('W: ' + file)
    with open(dir + '/' + file, 'w') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
