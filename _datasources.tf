data "archive_file" "python_site_packages" {
  type        = "zip"
  source_dir  = "${abspath(path.module)}/output"
  output_path = local.python_package_zip
  depends_on  = [null_resource.pip_install_package]
}