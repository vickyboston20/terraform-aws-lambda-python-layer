resource "null_resource" "pip_install_package" {
  triggers = {
    timestamp = var.force_rebuild ? timestamp() : "static"
    hash      = local.python_packages
  }
  provisioner "local-exec" {
    command = "${abspath(path.module)}/scripts/install_python_packages.sh '${local.python_packages}' ${length(var.pip_repo_config) > 0 ? var.pip_repo_config[0].extra_index_url : ""} ${length(var.pip_repo_config) > 0 ? var.pip_repo_config[0].trusted_host : ""}"
  }
}

resource "aws_lambda_layer_version" "lambda_layer" {
  layer_name          = var.layer_name
  filename            = local.python_package_zip
  compatible_runtimes = var.compatible_runtimes
  source_code_hash    = data.archive_file.python_site_packages.output_base64sha256

  lifecycle {
    replace_triggered_by = [null_resource.pip_install_package]
    ignore_changes       = [source_code_hash]
  }
}
