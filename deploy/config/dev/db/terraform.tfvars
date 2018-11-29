terragrunt = {
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
