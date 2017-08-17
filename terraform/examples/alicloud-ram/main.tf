data "alicloud_ram_account_alias" "alias" {
  output_file = "alias.txt"
}

data "alicloud_ram_groups" "group" {
  output_file = "groups.txt"
  type = "user"
  user_name = "user1"
  group_name_regex = "^group[0-9]*"
}

data "alicloud_ram_users" "user" {
  output_file = "users.txt"
  type = "policy"
  policy_name = "AliyunACSDefaultAccess"
  policy_type = "Custom"
  user_name_regex = "^user"
}

data "alicloud_ram_policies" "policy" {
  output_file = "policies.txt"
  type = "user"
  user_name = "user1"
  policy_type = "System"
}

data "alicloud_ram_roles" "role" {
  output_file = "roles.txt"
  role_name_regex = ".*test.*"
  policy_name = "AliyunACSDefaultAccess"
  policy_type = "Custom"
}

resource "alicloud_ram_user" "user" {
  user_name = "${var.user_name}"
  display_name = "${var.display_name}"
  mobile = "${var.mobile}"
  email = "${var.email}"
  comments = "yoyoyo"
  force = true
}

resource "alicloud_ram_login_profile" "profile" {
  user_name = "${alicloud_ram_user.user.user_name}"
  password = "${var.password}"
}

resource "alicloud_ram_access_key" "ak" {
  user_name = "${alicloud_ram_user.user.user_name}"
  status = "Active"
  secret_file = "/Users/yu/accesskey.txt"
}

resource "alicloud_ram_group" "group" {
  group_name = "${var.group_name}"
  comments = "this is a group comments."
  force = true
}

resource "alicloud_ram_group_membership" "membership" {
  group_name = "${alicloud_ram_group.group.group_name}"
  user_names = [
    "${alicloud_ram_user.user.user_name}"]
}

resource "alicloud_ram_role" "role" {
  role_name = "${var.role_name}"
  services = ["apigateway", "ecs"]
//  account_ids = ["${your_account_id}", "${other_account_id}"]
  description = "this is a role test."
  force = true
}

resource "alicloud_ram_policy" "policy" {
  policy_name = "${var.policy_name}"
  policy_document = "{\"Statement\": [{\"Action\": [\"ram:ListGroups\", \"ram:CreateGroup\"], \"Effect\": \"Allow\", \"Resource\": [\"acs:ram:*:1307087942598154:group/*\"]}], \"Version\": \"1\"}"
  description = "this is a policy test"
  force = true
}

resource "alicloud_ram_user_policy_attachment" "attach" {
  policy_name = "${alicloud_ram_policy.policy.policy_name}"
  user_name = "${alicloud_ram_user.user.user_name}"
  policy_type = "${alicloud_ram_policy.policy.policy_type}"
}

resource "alicloud_ram_group_policy_attachment" "attach" {
  policy_name = "${alicloud_ram_policy.policy.policy_name}"
  group_name = "${alicloud_ram_group.group.group_name}"
  policy_type = "${alicloud_ram_policy.policy.policy_type}"
}

resource "alicloud_ram_role_policy_attachment" "attach" {
  policy_name = "${alicloud_ram_policy.policy.policy_name}"
  role_name = "${alicloud_ram_role.role.role_name}"
  policy_type = "${alicloud_ram_policy.policy.policy_type}"
}

resource "alicloud_ram_alias" "alias" {
  account_alias = "hallo"
}