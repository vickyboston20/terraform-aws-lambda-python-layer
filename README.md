# Terraform AWS Lambda Python Layer Module

This Terraform module creates an AWS Lambda layer for specified Python packages. It supports both public and private Python package repositories, such as PyPI or Artifactory, allowing you to manage dependencies flexibly for your Lambda functions.

## Example Usage

The following module definition can be used to create a lambda layer.

### 1. Basic Usage (Public PyPI)

Use the module without specifying `pip_repo_config` if all packages are available in public PyPI.

```hcl
module "public_lambda_layer" {
  source        = "git::https://github.com/vickyboston20/terraform-aws-python-lambda-layer.git?ref=1.0.0"
  layer_name    = "public-lambda-layer"
  package_names = [
    "boto3",
    "pyotp==2.9.0"
  ]
  compatible_runtimes = [
    "python3.10",
    "python3.11",
    "python3.12"
  ]
}
```

### 2. Advance Usage (Private Artifactory)

Set `pip_repo_config` to define additonal repository settings for private packages.

```hcl
module "private_lambda_layer" {
  source        = "git::https://github.com/vickyboston20/terraform-aws-python-lambda-layer.git?ref=1.0.0"
  layer_name    = "private-lambda-layer"
  package_names = [
    "private_sample_lib==1.0.13"
  ]
  pip_repo_config = [
    {
      extra_index_url = "https://example.com/artifactory/api/pypi/pypi-repos/simple"
      trusted_host    = "example.com"
    }
  ]
  compatible_runtimes = [
    "python3.10",
    "python3.11",
    "python3.12"
  ]
}
```

### 3. Force Rebuild the Lambda Layer

To rebuild the Lambda layer on demand, set the `force_rebuild` variable to `true`. This triggers the regeneration of the Lambda Layer, even if there are no changes in the packages

```hcl
module "lambda_layer_with_force_rebuild" {
  source        = "git::https://github.com/vickyboston20/terraform-aws-python-lambda-layer.git?ref=1.0.0"
  layer_name    = "force-rebuild-lambda-layer"
  package_names = [
    "boto3",
    "pyotp==2.9.0"
  ]
  compatible_runtimes = [
    "python3.10",
    "python3.11",
    "python3.12"
  ]
  force_rebuild = true
}
```

## Input Variables

| Variable Name         | Type                                                                | Default      | Description                                                                                      |
| --------------------- | ------------------------------------------------------------------- | ------------ | ------------------------------------------------------------------------------------------------ |
| `layer_name`          | `string`                                                            | **required** | Specifies the name for the Lambda layer.                                                         |
| `package_names`       | `list(string)`                                                      | **required** | List of Python packages to include in the Lambda layer.                                          |
| `pip_repo_config`     | `list(object({ extra_index_url = string, trusted_host = string }))` | `[]`         | Optional configuration for private package repository. Must contain only one entry if specified. |
| `compatible_runtimes` | `list(string)`                                                      | `[]`         | List of compatible Python runtimes (e.g., `python3.11`, `python3.12`).                           |
| `force_rebuild`       | `bool`                                                              | `false`      | If set to `true`, forces the Lambda layer to rebuild even if no changes are detected.            |

## Output

| Name             | Description                          |
| ---------------- | ------------------------------------ |
| lambda_layer_arn | The ARN of the created Lambda layer. |

## Using lambda_layer_arn in a Lambda function

The module outputs `lambda_layer_arn`, which you use to attach this layer to your lambda function.

```hcl
resource "aws_lambda_function" "sample_lambda_function" {
  function_name = "sample-function"
  runtime       = "python3.12"
  handler       = "index.handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "path/to/lambda/function.zip"
  layers        = [module.private_lambda_layer.lambda_layer_arn]
}
```
