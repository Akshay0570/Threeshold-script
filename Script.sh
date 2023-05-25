#!/bin/bash

url="http://3.135.238.207:8080/api/v2/findings/?tags=&test__tags=BUILD_ID"
headers=("content-type: application/json" "Authorization: Token 04a3f27e413800d03838d1d5ac9c5dcdb91e672b")

response=$(curl -s -H "${headers[0]}" -H "${headers[1]}" -X GET "$url")

test_txt="$response"
count_high=0
count_medium=0

for i in $(seq 0 $(expr $(echo "$test_txt" | jq '.results | length') - 1)); do
    found_by=$(echo "$test_txt" | jq -r ".results[$i].found_by")
    severity=$(echo "$test_txt" | jq -r ".results[$i].severity")

    if [ "$found_by" = "[76]" ]; then
        if [ "$severity" = "High" ]; then
            count_high=$((count_high+1))
        elif [ "$severity" = "Medium" ]; then
            count_medium=$((count_medium+1))
        fi
    else
        echo "There are no high/medium findings, so pipeline continues."
    fi
done

echo "High Count is: $count_high"
echo "Medium Count is: $count_medium"

if [ $count_high -gt 2 ]; then
    echo "More than 2 high severity findings, terminating pipeline."
    exit 1
elif [ $count_medium -gt 5 ]; then
    echo "More than 5 medium severity findings, terminating pipeline."
    exit 1
fi

