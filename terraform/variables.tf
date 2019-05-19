variable "lambda_payload_filename" {
  default = "../gradle/wrapper/gradle-wrapper.jar"
}

variable "lambda_function_handler" {
  default = "com.ktor_test.Application"
}

variable "lambda_runtime" {
  default = "java8"
}

variable "api_path" {
  default = "TEST"
}

variable "hello_world_http_method" {
  default = "POST"
}

variable "api_env_stage_name" {
  default = "beta"
}
