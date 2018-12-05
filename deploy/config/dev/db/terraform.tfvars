terragrunt = {
  remote_state {
    backend = "s3"
    config {
      bucket         = "mnpg-content-data-terraform-state"
      key            = "dev/db/terraform.tfstate"
      region         = "eu-west-1"
      encrypt        = true
      dynamodb_table = "mnpg-content-data-terraform-state-lock"
    }
  }
  terraform {
    source = "../../../modules//db"
    extra_arguments "custom_vars" {
      commands = [
        "apply",
        "plan",
        "import",
        "push",
        "refresh",
        "destroy"
      ]
      arguments = [
        "-var-file=${get_tfvars_dir()}/../../core.tfvars",
        "-var-file=${get_tfvars_dir()}/../dev.tfvars",
        "-var-file=terraform.tfvars"
      ]
    }
  }
}

ContentStackUpdatesTableReadCapacityUnitsMin = 5
ContentStackUpdatesTableReadCapacityUnitsMax = 5
ContentStackUpdatesTableWriteCapacityUnitsMin = 20
ContentStackUpdatesTableWriteCapacityUnitsMax = 20
ContentStackUpdatesTableAutoScalePolicyTargetValue = 50.0
