module "state" {
  source = "modules/state"

  name = "${var.name}"
  project = "${var.project}"
  contact = "${var.contact}"
  region = "${var.region}"
  availability_zones = "${var.availability_zones}"
  stack = "${var.stack}"
  public_zone = "${var.public_zone}"
  public_zone_id = "${var.public_zone_id}"
  state_bucket = "${var.state_bucket}"
  stack_name_prefix = "${var.stack_name_prefix}"
  allowed_account_ids = "${var.allowed_account_ids}"
  environment = "${var.environment}"
  bucket_prefix = "${var.bucket_prefix}"
}

module "network" {
  source = "modules/network"

  network = "${var.network}"
  name = "${var.name}"
  project = "${var.project}"
  contact = "${var.contact}"
  region = "${var.region}"
  peer_vpc_id = "${var.peer_vpc_id}"
  availability_zones = "${var.availability_zones}"
  stack = "${var.stack}"
  state_bucket = "${var.state_bucket}"
  stack_name_prefix = "${var.stack_name_prefix}"
  allowed_account_ids = "${var.allowed_account_ids}"
  vpc_peer_stack = "${var.vpc_peer_stack}"
  environment = "${var.environment}"
  private_zone = "${var.private_zone}"
  state_cluster_name = "${var.state_cluster_name}"
  vpc_net = "${var.vpc_net}"
  route_table_public_ids = "${var.route_table_public_ids}"
  route_table_private_ids = "${var.route_table_private_ids}"
  private_zone_id = "${var.private_zone_id}"
}

module "bastion" {
  source = "modules/bastion"

  public_zone = "${module.state.public_zone}"
  environment = "${var.environment}"
  stack_name_prefix = "${var.stack_name_prefix}"
  name = "${var.name}"
  vpc_id = "${module.network.vpc_id}"
  project = "${var.project}"
  contact = "${var.contact}"
  bastion_ami = "${var.bastion_ami}"
  bastion_instance_type = "${var.bastion_instance_type}"
  public_subnet_ids = "${module.network.public_subnet_ids}"
  key_name = "${var.key_name}"
  bastion_root_size = "${var.bastion_root_size}"
  admin_ips = "${var.admin_ips}"
  public_zone_id = "${module.state.public_zone_id}"
  private_zone_id = "${module.network.private_zone_id[0]}"
}

module "vault" {
  source = "modules/vault"

  name = "${var.name}"
  stack = "${var.stack}"
  project = "${var.project}"
  contact = "${var.contact}"
  key_name = "${var.key_name}"
  region = "${var.region}"
  vault_ami = "${var.vault_ami}"
  state_bucket = "${var.state_bucket}"
  stack_name_prefix = "${var.stack_name_prefix}"
  allowed_account_ids = "${var.allowed_account_ids}"
  environment = "${var.environment}"
  consul_version = "${var.consul_version}"
  vault_version = "${var.vault_version}"
  vault_root_size = "${var.vault_root_size}"
  vault_data_size = "${var.vault_data_size}"
  vault_instance_count = "${var.vault_instance_count}"
  vault_instance_type = "${var.vault_instance_type}"
  state_cluster_name = "${var.state_cluster_name}"
  private_zone = "${module.network.private_zone[0]}"
  private_zone_id = "${module.network.private_zone_id[0]}"
  secrets_bucket = "${module.state.secrets_bucket[0]}"
  secrets_kms_arn = "${module.state.secrets_kms_arn[0]}"
  backups_bucket = "${module.state.backups_bucket[0]}"  
  private_subnet_ids = ["${module.network.private_subnet_ids}"]
  private_subnets = ["${module.network.private_subnets}"]
  availability_zones = ["${module.network.availability_zones}"]
  bastion_security_group_id = "${module.bastion.bastion_security_group_id}"
  vpc_id = "${module.network.vpc_id}" 
  bastion_instance_id = "${module.bastion.bastion_instance_id}"
  vault_cluster_name = "${var.vault_cluster_name}"
}

module "kubernetes" {
  source = "modules/kubernetes"

  name = "${var.name}"
  project = "${var.project}"
  contact = "${var.contact}"
  key_name = "${var.key_name}"
  region = "${var.region}"
  stack = "${var.stack}"
  state_bucket = "${var.state_bucket}"
  stack_name_prefix = "${var.stack_name_prefix}"
  allowed_account_ids = "${var.allowed_account_ids}"
  environment = "${var.environment}"
  state_cluster_name = "${var.state_cluster_name}"
  vault_cluster_name = "${var.vault_cluster_name}"
  tools_cluster_name = "${var.tools_cluster_name}"
  secrets_bucket = "${module.state.secrets_bucket[0]}"
  private_subnet_ids = ["${module.network.private_subnet_ids}"]
  public_subnet_ids = ["${module.network.public_subnet_ids}"]
  kubernetes_master_ami = "${var.kubernetes_master_ami}"
  kubernetes_worker_ami = "${var.kubernetes_worker_ami}"
  kubernetes_etcd_ami = "${var.kubernetes_etcd_ami}"
  internal_fqdns = ["${module.vault.instance_fqdns}"]
  vault_kms_key_id = "${module.vault.vault_kms_key_id}"
  vault_unseal_key_name = "${module.vault.vault_unseal_key_name}"
  # template variables
  availability_zones = ["${module.network.availability_zones}"]
  vpc_id = "${module.network.vpc_id}"
  private_zone_id = "${module.network.private_zone_id[0]}"
  private_zone = "${module.network.private_zone[0]}"
  vault_ca = "${module.vault.vault_ca}"
  vault_url = "${module.vault.vault_url}"
  public_zone = "${module.state.public_zone}"
  public_zone_id = "${module.state.public_zone_id}"
  vault_security_group_id = "${module.vault.vault_security_group_id}"
  bastion_security_group_id = "${module.bastion.bastion_security_group_id}"
}
