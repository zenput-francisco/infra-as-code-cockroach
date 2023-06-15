terraform {
  required_providers {
    cockroach = {
      source = "cockroachdb/cockroach"
      version = "0.5.0"
    }
  }
}

provider "cockroach" {
  apikey = "CCDB1_Fe3GNsl99D3WdZ0O41PGM7_INhvNkCDoDx3SlS5UHejjodEySTaghOxNJAumnaI"
}

resource "cockroach_cluster" "serverless_cluster" {
  cloud_provider = "AWS"
  name = "serverless-test-db"
  regions = [ {
    name = "us-east-1"
  } ]
  serverless = {
    spend_limit = 0
  }
}

resource "cockroach_database" "shortener_db" {
  cluster_id = cockroach_cluster.serverless_cluster.id
  name = "shortener"
}

# User will be create but password must be set from the web console
resource "cockroach_sql_user" "shortener_user" {
  cluster_id = cockroach_cluster.serverless_cluster.id
  name = "shortuser"
}
