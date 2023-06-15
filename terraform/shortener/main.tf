terraform {
    required_providers {
        scaleway = {
        source = "scaleway/scaleway"
        version = "2.21.0"
        }
    }
}

provider "scaleway" {
    access_key = "SCW636YT5NATEDJ49V65"
    secret_key = "a2f7555d-0f35-43e8-958f-41280000dff9"
}


variable "db_user" {
    type = string
    sensitive = false
}

variable "db_name"{
    type= string
    sensitive = false
}

variable "db_pwd" {
    type = string
    sensitive = true
}

variable "db_host" {
    type = string
    sensitive = false
}

variable "db_port" {
    type = number
    sensitive = false
}

resource "scaleway_container_namespace" "apps" {
    name = "apps-namespace"
    description = "Main apps namespace"  
}

resource "scaleway_container" "shortener_app" {
    name = "url-shortener-app"
    description = "Shlink serverless container deployment"
    namespace_id = scaleway_container_namespace.apps.id
    registry_image = "shlinkio/shlink:stable"
    port = 8080
    protocol = "http1"
    min_scale = 0
    max_scale = 2
    deploy = true
    privacy = "public"
    # Using the defaults for limits and timeouts
    cpu_limit = 140
    memory_limit = 256
    timeout = 300
    max_concurrency = 50
    secret_environment_variables = {
        "DB_PASSWORD" = var.db_pwd
    }
    environment_variables = {
        "IS_HTTPS_ENABLED" = true
        "DB_DRIVER" = "postgres"
        "DB_NAME" = var.db_name
        "DB_USER" = var.db_user
        "DB_HOST" = var.db_host
        "DB_PORT" = var.db_port
    }

}
