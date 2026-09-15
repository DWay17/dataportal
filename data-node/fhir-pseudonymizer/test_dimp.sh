#!/bin/sh
#grep -Ei 'hash.?key' *.env .env dimp_dup_*.yaml > 
key_in_conf=$(grep -Ei 'hash.?key' *.env .env dimp_dup_*.yaml | grep -v ':#' | sed -Ee 's#"##g' -e 's#^(.+):#"\1": #g' -e 's#": #": "#g' -e 's#$#",#g')
echo "key_in_conf=$key_in_conf"
echo "{$key_in_conf" > test_dimp-tmp.json
key_in_inspect=$(sudo docker inspect dataportal-fhir-pseudonymizer-1 | grep -Ei 'hash.?key' | sed -Ee 's#=#":"#g')
echo "key_in_inspect=$key_in_inspect"
echo "$key_in_inspect" >> test_dimp-tmp.json
echo " \"response\": " >> test_dimp-tmp.json
curl --request POST \
  --url 'http://localhost:8083/fhir/$de-identify' \
  --header 'content-type: application/json' \
  --data @test_dimp-in.json \
  | jq . >> test_dimp-tmp.json
echo "}" >> test_dimp-tmp.json
cat test_dimp-tmp.json | jq . > test_dimp-out.json
chown -c trichter:trichter test_dimp-tmp.json test_dimp-out.json



