terragrunt = {
  terraform {
    source = "../../../modules//prereqs"

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
