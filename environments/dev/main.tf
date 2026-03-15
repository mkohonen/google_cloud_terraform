provider "google" {
  project = "mkdev-490109"
  region  = "europe-north1"
}

# Kutsutaan samaa moduulia kuin test-ympäristössä
module "dev_gke" {
  source         = "../../modules/gke_cluster"
  # Projektikohtaiset asetukset
  project_id     = "mkdev-490109" # Vaihda oikea Project ID
  cluster_name   = "mkdev-cluster"
  region         = "europe-north1" # Hamina
  
  # devympäristössä on perus tehoa ja vikasietoisuutta

  # Skaalautuu tarpeen mukaan 1 ja 2 noden välillä
  min_node_count = 1
  max_node_count = 2
  machine_type   = "e2-medium"
}

# Output, jotta saat klusterin tiedot helposti ajon jälkeen
output "kubernetes_cluster_name" {
  value = module.dev_gke.cluster_name
}