terraform {
  required_version = ">= 0.13"
  required_providers {
    outlook = {
      source = "magodo/outlook"
    }
  }
}

data "outlook_mail_folder" "inbox" {
  well_known_name = "inbox"
}
resource "outlook_mail_folder" "github" {
  name             = "github"
  parent_folder_id = data.outlook_mail_folder.inbox.id
}

resource "outlook_mail_folder" "azure" {
  name             = "azure"
  parent_folder_id = data.outlook_mail_folder.inbox.id
}

resource "outlook_message_rule" "github" {
  name     = "move message from notifications@github.com to github"
  sequence = var.starting_sequence
  condition {
    from_addresses = ["notifications@github.com"]
  }
  action {
    move_to_folder = outlook_mail_folder.github.id
  }
}

resource "outlook_message_rule" "azure" {
  name     = "move message from azure-noreply@microsoft.com to azure"
  sequence = outlook_message_rule.github.sequence + 1
  condition {
    from_addresses = ["azure-noreply@microsoft.com"]
  }
  action {
    move_to_folder = outlook_mail_folder.azure.id
  }
}

# NOTE: Always update this value when message rules are modified.
output "ending_sequence" {
  description = "The sequence number of the last message rules introduced by this module."
  value = outlook_message_rule.azure.sequence
}
