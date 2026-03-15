# 1. VPC-verkko
resource "google_compute_network" "vpc_network" {
  name                    = "${var.cluster_name}-vpc"
  project                 = var.project_id
  auto_create_subnetworks = false
}

# 2. Aliverkko (GKE vaatii VPC-native tilassa omat alueet podeille ja serviceille)
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.cluster_name}-subnet"
  project       = var.project_id
  region        = var.region
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = "10.0.0.0/20" # Pääverkko nodeille

  # Podien IP-alue
  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = "192.168.0.0/18"
  }

  # Serviceiden IP-alue
  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "192.168.64.0/24"
  }
}

# 3. GKE Klusteri
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region
  project  = var.project_id

  network    = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.subnet.name

  remove_default_node_pool = true
  initial_node_count       = 1

  # VPC-Native konfiguraatio käyttäen yllä luotuja alueita
  ip_allocation_policy {
    cluster_secondary_range_name  = "pod-ranges"
    services_secondary_range_name = "services-range"
  }
}

# 4. Node Pool (kuten aiemmin)
resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  project    = var.project_id
  
  # Kun autoscaling on päällä, alkuperäinen node_count määritetään tässä:
  initial_node_count = var.min_node_count

  # Aktivoi automaattinen skaalaus
  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  node_config {
    machine_type = var.machine_type
    disk_size_gb = 30  # Pienennetään levykoko 30 gigatavuun (riittää harjoitteluun)
    disk_type    = "pd-standard" # Käytetään standard-levyä SSD:n sijaan, jos SSD-kiintiö on tiukka
    
    # Workload Identity ja muut suositellut scopet
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    
    labels = {
      env = var.project_id
    }
  }

  # Estetään Terraformia resetoimasta nodejen määrää joka ajolla, 
  # koska GKE hallitsee määrää lennosta.
  lifecycle {
    ignore_changes = [node_count]
  }
}

