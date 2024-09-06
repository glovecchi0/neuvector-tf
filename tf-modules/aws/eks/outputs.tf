output "cluster_name" {
  value = aws_eks_cluster.primary.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.primary.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.primary.certificate_authority.0.data
}
