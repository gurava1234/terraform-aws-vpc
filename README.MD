### AWS VPC MODULE

this module creates following resources.we are using HA, we are getting first 2 AZ automatically
* VPC
* Internet gateway with VPC association
* 2 public subnets in 1a and 1b
* 2 private subnets in 1a and 1b
* 2 database subnets in 1a and 1b
* Elastic IP
* NAT gateway in 1a publiuc subnet
* public roiute table
* private roiute table
* database roiute table
* subnets and route tables associaction
* vpc peering if user requests
* adding the peering route in default vpc, if user dont provide acceptor vpc explicitly.
* adding the peering routes in public,private and database route tables.

### Inputs
* project_name (required) - your project name
* environment (required) - which environment you are working in 
* vpc_cidr (optional) - default value is 10.0.0.0/16, user can override
* enable_dns_hostnames (optional) - default value is true
* common_tags (optional) - better to provide
* vpc_tags (optional)
* igw_tags (optional)
* public_subnets_cidr (required) - user must provide 2 valid public subnet CIDR
* public_subnets_tags (optional)
* private_subnets_cidr (required) - user must provide 2 valid private subnet CIDR
* private_subnets_tags (optional)
* database_subnets_cidr (required) - user must provide 2 valid database subnet CIDR
* database_subnets_tags (optional)
* nat_gateway_tags (optional)
* public_route_table_tags (optional)
* private_route_table_tags (optional)
* database_route_table_tags (optional)
* is_peering_required (optional) - default value
is false
* acceptor_vpc_id (optional) - default value is default vpc id
* vpc_peering_tags (optional) - default value is empty type is map


### outputs
* vpc_id - vpc ID created
* public_subnet_ids - 2 public subnet ID created
* private_subnet_ids - 2 private subnet ID created
* database_subnet_ids - 2 database subnet ID created






