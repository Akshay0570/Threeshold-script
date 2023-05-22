Threeshold script:

import json
import requests
import sys
url = 'http://3.135.238.207:8080/api/v2/findings/?tags=&test__tags=BUILD_ID'
headers = {'content-type': 'application/json',
'Authorization': 'Token 04a3f27e413800d03838d1d5ac9c5dcdb91e672b'}
r = requests.get(url, headers=headers, verify=True) # set verify to False if ssl cert is self-signed
#print (r.json())
#y=json.loads(r.json())
 
test_txt = r.json()
count_high = 0
 
count_medium = 0
for i in range(len(test_txt['results'])):
    if (test_txt['results'][i]['found_by']) == [76]:
 

        if (test_txt['results'][i]['severity'])== 'High':
 
            count_high+=1
 
        elif (test_txt['results'][i]['severity'])== 'Medium':
 
            count_medium+=1
 
    else:
 
        # print('there are no high/medium found so pipeline continue' )
 
        pass
 
print('High Count is: ', count_high)
print('Medium Count is: ', count_medium)
 
if count_high > 2:

    print("more than 2  high severity found so terminated pipeline")
    exit(1)
elif count_medium > 5:
    print("more than 2  medium severity found so terminated pipeline")
    exit(1)

