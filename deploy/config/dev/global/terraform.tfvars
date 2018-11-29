terragrunt = {
  terraform {
    source = "../../../modules//global"

    extra_arguments "custom_vars" {
      commands = [
        "apply",
        "plan",
        "import",
        "push",
        "refresh"
      ]

      arguments = [
        "-var-file=${get_tfvars_dir()}/../../core.tfvars",
        "-var-file=terraform.tfvars"
      ]
    }
  }
}
