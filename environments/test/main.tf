# Määritellään Google-provider test-projektille
provider "google" {
  project = "gen-lang-client-0952591329" # Vaihda tähän MKTEST-projektisi oikea ID
  region  = "europe-north1"
}

# Kutsutaan samaa moduulia kuin dev-ympäristössä
module "test_gke" {
  source         = "../../modules/gke_cluster"
  # Projektikohtaiset asetukset
  project_id     = "gen-lang-client-0952591329"
  cluster_name   = "mktest-cluster"
  region         = "europe-north1"
  
  # Testiympäristössä on hyvä olla enemmän tehoa ja vikasietoisuutta

  # Skaalautuu tarpeen mukaan 1 ja 5 noden välillä
  min_node_count = 1
  max_node_count = 5
  # Enemmän RAM-muistia (8GB) kuin devissä
  machine_type   = "e2-standard-2"
}

# Output, jotta saat klusterin tiedot helposti ajon jälkeen
output "kubernetes_cluster_name" {
  value = module.test_gke.cluster_name
}

