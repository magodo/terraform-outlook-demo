A demo terraform module for [terraform-provider-outlook](https://github.com/magodo/terraform-provider-outlook).

Example:

```hcl
terraform {
  required_providers {
    outlook = {
      source = "magodo/outlook"
    }
  }
}

# Create a mail folder
resource "outlook_mail_folder" "example" {
  name = "Foo"
}

# Create a message rule to move message meet certain condition into the folder created above
resource "outlook_message_rule" "example" {
  name     = "move message from foo@bar.com to Foo"
  sequence = 1
  enabled  = true
  condition {
    from_addresses = ["foo@bar.com"]
  }
  action {
    move_to_folder = outlook_mail_folder.example.id
  }
}

module "demo" {
  source  = "magodo/demo/outlook"
  starting_sequence = 2
}
```
