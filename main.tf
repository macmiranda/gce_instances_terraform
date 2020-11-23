/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

provider "google" {

  version = "~> 3.0"
}

module "instance_template" {
  source               = "github.com/terraform-google-modules/terraform-google-vm//modules/instance_template?ref=v5.1.0"
  region               = var.region
  project_id           = var.project_id
  subnetwork           = var.subnetwork
  service_account      = var.service_account
  source_image_family  = "debian-10"
  source_image_project = "debian-cloud"
  disk_size_gb         = "10"
  metadata             = {
    startup-script = file("${path.module}/startup-script.txt")
  }
  tags                 = [ "http-server" , "https-server" ]
}

module "compute_instance" {
  source            = "github.com/terraform-google-modules/terraform-google-vm//modules/compute_instance?ref=v5.1.0"
  region            = var.region
  subnetwork        = var.subnetwork
  num_instances     = var.num_instances
  hostname          = "instance-simple"
  instance_template = module.instance_template.self_link
  access_config = [{
    nat_ip       = var.nat_ip
    network_tier = var.network_tier
  }, ]
}
