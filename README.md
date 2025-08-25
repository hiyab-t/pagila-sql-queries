# Pagila SQL Project

# Project Background

This project is a hands-on SQL practice with the Pagila DVD rental PostreSQL sample database. It is part of my Data Analytics training in the Datanomics Bootcamp, designed to stregthen both basic and advanced SQL querying skills for analytics and reporting.

The goal of this project is to analyze historical rental and payment data, simulating real-world database operations, and performing DML, DDL and DQL tasks. In addition, for my own learning, Terraform is used to provision a PostgreSQL database in AWS RDS for a practical experience with Infrastructure as Code (IaC) and cloud integrated databased deployment.

# Infrastructure Setup (Terraform + AWS RDS)

This project uses Terraform to provision the postgres database. All infrastructure is defined in `rds-terraform.tf` and `provider.tf`, which provision AWS RDS PostgreSQL instance all within the Amazon Free Fier quota.

**Prerequisities**

- Install Terraform locally

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

The exercises cover data manipulation (DML), data definition language (DDL), data querying (DQL) and analytics.

**1. Data Manipulation (DML)**

- Simulated ongoing business operations by adding new rentals and payments, and updating rental returns.

Example queries:

    - Check whether a movie is in inventory and available for rent.

    - Insert new rental and payment records for a customer.

    - Update rental records when movies are returned.

    - Verify inserted and updated records to maintain data integrity.

2. Data Definition Language (DDL)

- Defined database objects for enhanced analytics.

Example: Created view to see top 5 genres by revenue

2. Data Querying and Analysis (DQL)

- Analyzed historical rental and payment data to generate actionable business insights.

Techniques used:

    - Aggregates with GROUP BY: Total rentals, revenue per genre, revenue per store, etc.

    - Window functions: Ranking movies by revenue or rental count, identifying top             customers, etc.

Example queries:

    - Identify the most and least popular genres and total revenue.

    - Retrieve the top 10 most popular movies by rental count using RANK() OVER (ORDER BY     COUNT(r.rental_id) DESC).

    - Generate summary views, i.e., top 5 genres by average revenue, using windowed             ranking functions.

