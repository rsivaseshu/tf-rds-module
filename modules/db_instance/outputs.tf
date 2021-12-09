output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = join("", aws_db_instance.this.*.address)
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = join("", aws_db_instance.this.*.arn)
}

output "db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = join("", aws_db_instance.this.*.availability_zone)
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = join("", aws_db_instance.this.*.endpoint)
}

output "db_instance_hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
  value       = join("", aws_db_instance.this.*.hosted_zone_id)
}

output "db_instance_id" {
  description = "The RDS instance ID"
  value       = join("", aws_db_instance.this.*.id)
}

output "db_instance_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = join("", aws_db_instance.this.*.resource_id)
}

output "db_instance_status" {
  description = "The RDS instance status"
  value       = join("", aws_db_instance.this.*.status)
}

output "db_instance_name" {
  description = "The database name"
  value       = join("", aws_db_instance.this.*.name)
}

output "db_instance_username" {
  description = "The master username for the database"
  value       = join("", aws_db_instance.this.*.username)
  sensitive   = true
}

output "db_instance_port" {
  description = "The database port"
  value       = join("", aws_db_instance.this.*.port)
}

output "db_instance_ca_cert_identifier" {
  description = "Specifies the identifier of the CA certificate for the DB instance"
  value       = join("", aws_db_instance.this.*.ca_cert_identifier)
}
