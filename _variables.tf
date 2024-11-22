variable "layer_name" {
  type        = string
  description = "Name of the Lambda layer"
}

variable "package_names" {
  type        = list(string)
  description = "Name of the python packages to install"
}

variable "pip_repo_config" {
  description = "Optional: List of dictionary with extra index URL and trusted host for pip install"
  type = list(object({
    extra_index_url = string
    trusted_host    = string
  }))
  default = []
  validation {
    condition     = length(var.pip_repo_config) == 0 || length(var.pip_repo_config) == 1
    error_message = "You can only provide one entry in 'pip_repo_config' if specifying it"
  }
}

variable "compatible_runtimes" {
  type        = list(string)
  description = "List of compatible runtimes for the Lambda layer"
}

variable "force_rebuild" {
  type        = bool
  description = "Boolean to force rebuild of the Lambda layer"
  default     = false
}
