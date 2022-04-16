# Default Tags for the Resources.
output "default_tags" {
  value = {
    "Owner" = "Group1"
    "App"   = "Web"
 }
}


# Prefix to Identify Resouces.
output "prefix" {
  value     = "Group1-Project"
}
