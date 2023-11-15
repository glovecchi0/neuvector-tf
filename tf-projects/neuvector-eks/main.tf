module "aws-elastic-kubernetes-service" {
  source                = "../../tf-modules/aws/eks"
  prefix                = var.prefix
  aws_region            = var.aws_region
  allowed_ip_cidr_range = var.allowed_ip_cidr_range
  #  vpc_ip_cidr_range    = var.vpc_ip_cidr_range
  #  subnet_ip_cidr_range = var.subnet_ip_cidr_range
  #  vpc                  = var.vpc
  #  subnet               = var.subnet
  #  instance_count       = var.instance_count
}

resource "null_resource" "first-setup" {
  depends_on = [module.aws-elastic-kubernetes-service]
  provisioner "local-exec" {
    command = "sh ./first-setup.sh"
  }
}

resource "helm_release" "neuvector-core" {
  depends_on       = [resource.null_resource.first-setup]
  name             = "neuvector"
  repository       = "https://neuvector.github.io/neuvector-helm/"
  chart            = "core"
  create_namespace = true
  namespace        = "cattle-neuvector-system"

  values = [
    "${file("${path.cwd}/custom-helm-values.yaml")}"
  ]

  set {
    name  = "controller.secret.data.userinitcfg\\.yaml.users[0].Password"
    value = var.neuvector_password
  }
}

data "kubernetes_service" "neuvector-service-webui" {
  metadata {
    name      = "neuvector-service-webui"
    namespace = resource.helm_release.neuvector-core.namespace
  }
}
