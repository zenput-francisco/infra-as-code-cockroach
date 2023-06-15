terraform {
  required_providers {
    cockroach = {
      source = "cockroachdb/cockroach"
      version = "0.5.0"
    }
  }
}

provider "cockroach" {
}

resource "cockroach_cluster" "serverless_db" {
  cloud_provider = "AWS"
  name = "serverless-test-db"
  regions = [ {
    name = "us-east-1"
  } ]
  serverless = {
    spend_limit = 0
  }
}
