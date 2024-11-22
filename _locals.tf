locals {
  python_package_zip = "output/${var.layer_name}.zip"
  python_packages    = join(" ", var.package_names)
}