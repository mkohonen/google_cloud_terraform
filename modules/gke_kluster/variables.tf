variable "project_id" { type = string }
variable "cluster_name" { type = string }
variable "region" { type = string }
variable "min_node_count" {
  description = "Minimimäärä VM-instansseja per vyöhyke"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maksimimäärä VM-instansseja per vyöhyke"
  type        = number
  default     = 5
}

variable "machine_type" { type = string }
