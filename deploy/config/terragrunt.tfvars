terragrunt = {
  remote_state {
    backend = "s3"
    config {
      bucket         = "mnpg-content-data-terraform-state"
      key            = "${path_relative_to_include()}/terraform.tfstate"
      region         = "eu-west-1"
      encrypt        = true
      dynamodb_table = "mnpg-content-data-terraform-state-lock"
      s3_bucket_tags {
        "mnpg:environment" = "NA"
        "mnpg:name"        = "mnpg-content-data"
        "mnpg:owner"       = "callum.hibbert@moonpig.com"
        "mnpg:team"        = "Ops"
        "mnpg:workstream"  = "NA"
      }

      dynamodb_table_tags {
        "mnpg:environment" = "NA"
        "mnpg:name"        = "mnpg-content-data"
        "mnpg:owner"       = "callum.hibbert@moonpig.com"
        "mnpg:team"        = "Ops"
        "mnpg:workstream"  = "NA"
      }
    }
  }
}