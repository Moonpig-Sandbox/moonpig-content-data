terragrunt = {
  terraform {
    source = "../../../modules/regional//db"
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
        "-var-file=${get_tfvars_dir()}/../../environment-types/${get_env("TF_VAR_environment_type", "dev")}.tfvars",
        "-var-file=terraform.tfvars"
      ]
    }
  }
  include = {
    path = "${find_in_parent_folders("terragrunt.tfvars")}"
  }
}
