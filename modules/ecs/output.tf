# data "external" "get_image_uri" {
#   program = [coalesce("${path.module}/scripts/get_image_uri.sh")]
# }

# output "fastapi_image_uri" {
#   value = data.external.get_image_uri.result["URI"]
# }