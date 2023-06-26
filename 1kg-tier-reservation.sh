openstack reservation lease create \
  --reservation min=1,max=1,resource_type=physical:host,resource_properties='["=", "$uid", "21945871-35b6-4d74-9af7-af4c9cd86b70"]' \
  --start-date "2022-06-17 16:00" \
  --end-date "2022-06-17 18:00" \
  1kgenome-tier-test