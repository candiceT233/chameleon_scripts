source ./CHI-221071-openrc.sh
openstack reservation lease create \
  --reservation min=1,max=1,resource_type=physical:host,resource_properties='["=", "$node_type", "compute_skylake"]' \
  --start-date "2023-06-26 15:40" \
  --end-date "2022-06-17 16:40" \
  --project_domain_id "e081833d8dde4102af564ed96f10035a" \
  --project_name "CHI-221071" \
  --project_domain_name "chameleon" \
  my-example-lease