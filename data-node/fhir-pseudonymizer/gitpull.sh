#!/bin/sh
#cp -v dimp_dup_base.yaml dimp_dup_base.yaml~
cp -v --backup=numbered dimp_dup_base.yaml dimp_dup_base.yaml~
git restore dimp_dup_base.yaml
git pull
mv -v dimp_dup_base.yaml dimp_dup_base.yaml.git
KEY=$(grep -E 'cryptoHashKey: [0-9a-f]{32,}' $(
 grep -E 'cryptoHashKey: [0-9a-f]{32,}' dimp_dup_base.yaml* | sed -Ee 's#:.*##g' | xargs ls -1rt | tail -n1 
 ) | sed -Ee 's#.*cryptoHashKey: ##g' -e 's/ ?#.*//g')
echo "KEY=$KEY"
cat dimp_dup_base.yaml.git | sed -Ee "s/cryptoHashKey: #/cryptoHashKey: $KEY #/g" > dimp_dup_base.yaml
grep -E 'cryptoHashKey: [0-9a-f]{32,}' dimp_dup_base.yaml* 

