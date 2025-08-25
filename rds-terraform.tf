#create rds DB using TF
resource "aws_db_instance" "pagila" {
    engine = "postgres"
    engine_version = "17.4"
    instance_class = "db.t4g.micro"
    allocated_storage = 20
    storage_type = "gp2"
    identifier = "pagila"
    username = "postgres"
    password = "Kangfupanda12"
    publicly_accessible = true
    skip_final_snapshot = true

    tags = {
        Name = "MyPagiladb"
    }
}
