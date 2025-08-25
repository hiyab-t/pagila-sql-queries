# Pagila SQL Project

# Project Background

This project is a hands-on SQL practice with the Pagila DVD rental PostreSQL sample database. It is part of my Data Analytics training in the Datanomics Bootcamp, designed to stregthen SQL basic and advanced querying skills for analytics and reporting.

Goals of this project:

- Provision a PostgreSQL database using AWS RDS built and deployed by Terraform.

- Load the Pagila schema and data.

- Practice analytical SQL queries in a cloud-hosted environment.

# Infrastructure Setup (Terraform + AWS RDS)

This project uses Terraform to provision the postgres database. All infrastructure is defined in rds-terraform.tf, which provisions an Amazon RDS PostgreSQL instance all within the free tier quota.

**Prerequisities**

- Install Terraform locally.

- Install and configure AWS CLI

- AWS account with Free Tier available

- Intall PostgreSQL (psql) - This is necessary in order to interact with your RDS PostgreSQL instance (run queries, load Pagila schema/data)

# Deployement Steps

1. Initialize Terraform:
```bash
    terraform init
```

2. Preview the changes:

```bash
    terraform plan
```

3. Apply to create the database
```bash
    terraform apply -auto-approve
```

4. Once complete, Terraform will output the RDS endpoint (you many also check in the AWS console).

# Database Setup (Pagila)

The Pagila dataset consists of a schema (pagila-schema.sql) and data (pagila-data.sql).

1. Dowload the SQL files:

<a href="https://github.com/devrimgunduz/pagila">Pagila Schema and Data</a>

2. Connect to your RDS instance:
```bash
    psql -h <rds-endpoint> -U <db-username> -d <db-name>
```

3. Run the schema script:
```bash
    \i <file-path>/pagila-schema.sql
```

4. Load the sample data:

```bash
    \i <file-path>/pagila-data.sql
```

# (Optional Step) Using pgAdmin for a GUI

You can use pgAdmin for a graphical interface to connect to PostgreSQL and run queries instead of the command line.

**Installation**

- Download pgAdmin from official site: <a href="https://www.pgadmin.org/download/">here</a>

**Connecting to Your RDS DAtabase**

1. Open pgAdmin and create a new server connection

2. Fill in the connection details (you can find details on AWS management consol)

3. Save and connect.

# SQL Practice 

The exercises cover data manipulation (DML)

