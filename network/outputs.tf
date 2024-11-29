# --- network/output.tf ---


output "vpc_id" {
  value = aws_vpc.k8_vpc.id
}

output "public_subnets" {
  value = aws_subnet.k8_public.*.id
}
output "private_subnets" {
  value = aws_subnet.k8_private.*.id
}
