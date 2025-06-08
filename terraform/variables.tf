# Terraform variables for GCP Kubernetes Platform Engineering
# Building production-ready configurations step by step

# Core GCP configuration - start here first
variable "project_id" {
  description = "The GCP project ID"
  type        = string
  # Note: Project ID cannot be changed once set, so get it right
  # From Cloud Support perspective: project isolation is security foundation
}

variable "region" {
  description = "The GCP region for resources"
  type        = string
  default     = "asia-northeast1"  # Tokyo region
  # Choose tokyo for low latency, oregon for cost optimization
  # Consider multi-region deployment for disaster recovery
}

variable "zone" {
  description = "The GCP zone for zonal resources"
  type        = string
  default     = "asia-northeast1-a"
  # For high availability, distribute across multiple zones
  # Single zone is fine for learning purposes
}

# Network configuration - this is where most issues originate
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"  # 65,534 IP addresses
  # RFC1918 compliant private IP range
  # Watch out for overlaps if planning VPC peering later
}

variable "subnet_cidr" {
  description = "CIDR block for the main subnet"
  type        = string
  default     = "10.0.1.0/24"  # 254 IP addresses
  # Node subnet. Adjust based on expected node count
  # /24 = max 254 nodes (minus a few reserved by GCP)
}

variable "pods_cidr" {
  description = "CIDR block for Kubernetes pods"
  type        = string
  default     = "10.1.0.0/16"  # Secondary range for pods
  # GKE uses alias IPs, so separate CIDR required
  # Use /14 or larger if expecting many pods
  # Common support issue: pod IP exhaustion preventing pod startup
}

variable "services_cidr" {
  description = "CIDR block for Kubernetes services"
  type        = string
  default     = "10.2.0.0/16"  # Secondary range for services
  # For ClusterIP services. Usually doesn't need to be huge
  # But /16 gives us plenty of room to grow
}

# GKE configuration - balancing performance and cost
variable "gke_node_count" {
  description = "Number of nodes in the GKE cluster"
  type        = number
  default     = 3  # Minimum viable cluster. Production needs at least 3
  # Odd numbers recommended for high availability
  # Considering etcd quorum: 3, 5, 7 are common choices
}

variable "gke_machine_type" {
  description = "Machine type for GKE nodes"
  type        = string
  default     = "e2-standard-4"  # 4vCPU, 16GB RAM
  # e2 = cost-efficient, n2 = performance-focused
  # e2-standard-4 sufficient for microservices-demo
  # Switch to e2-highmem-4 if OOMKilled errors occur frequently
}

variable "gke_disk_size" {
  description = "Disk size for GKE nodes (GB)"
  type        = number
  default     = 100  # Boot disk size per node
  # Account for container images and /tmp usage
  # Recommend 200GB+ for log-heavy applications
}

variable "gke_disk_type" {
  description = "Disk type for GKE nodes"
  type        = string
  default     = "pd-standard"  # Cost-focused choice
  # pd-ssd for high IOPS, pd-standard for low cost
  # pd-standard fine for learning purposes
}

# Feature flags - enable gradually as you build up
variable "enable_istio" {
  description = "Enable Istio service mesh"
  type        = bool
  default     = true
  # Service mesh is complex but essential for observability
  # Consider starting with false, then enable after basic setup works
}

variable "enable_workload_identity" {
  description = "Enable Workload Identity"
  type        = bool
  default     = true
  # Essential for secure access to GCP services
  # Much safer than using node service accounts
  # Setup is a bit complex though
}

variable "enable_network_policy" {
  description = "Enable network policy"
  type        = bool
  default     = true
  # Firewall-like functionality for pod-to-pod communication
  # Essential for security, but start with false to verify basic connectivity
}

variable "enable_monitoring" {
  description = "Enable monitoring"
  type        = bool
  default     = true
  # Integration with Cloud Monitoring
  # Absolutely necessary for troubleshooting
}

variable "enable_logging" {
  description = "Enable logging"
  type        = bool
  default     = true
  # Integration with Cloud Logging
  # Also absolutely necessary - can't debug without logs
}