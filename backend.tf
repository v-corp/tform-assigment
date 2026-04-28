terraform {
  backend "s3" {
    bucket= "cronus-tf-state-301541681617"
    key= "assignment-cset230/terraform.tfstate"
    region= "us-east-1"
    dynamodb_table= "cronus-tf-locks"
    encrypt= true
  }
} 
