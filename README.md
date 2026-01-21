# 🏢 SQL Data Warehouse Project

## Enterprise SQL Server Data Warehouse with Layered ETL & Analytics

Welcome to the **SQL Data Warehouse Project** repository.  
This project demonstrates the **design and implementation of an enterprise-grade SQL Server data warehouse**, covering the full lifecycle from raw data ingestion to analytics-ready dimensional models.

The solution follows **industry best practices** in data engineering, ETL design, and dimensional modeling, and is intended as a **portfolio project showcasing real-world data warehouse architecture**.

---

## 🏗️ Data Architecture

The project is designed using a **Medallion Architecture (Bronze–Silver–Gold)** approach:

![Data Architecture](docs/data_architecture.png)

### Architecture Layers

- **Bronze Layer (Raw)**  
  Ingests raw data from source systems (ERP & CRM) in CSV format into SQL Server with minimal transformation.

- **Silver Layer (Cleansed)**  
  Applies data cleansing, standardization, and business rules to prepare high-quality, consistent data.

- **Gold Layer (Analytics)**  
  Delivers business-ready datasets modeled using **star schema** (fact & dimension tables) optimized for reporting and analytics.

---

## 📖 Project Overview

This project covers the following key areas:

1. **Data Architecture Design**
   - Modern SQL Server data warehouse using layered architecture
   - Clear separation of ingestion, transformation, and analytics layers

2. **ETL Pipelines**
   - End-to-end SQL-based ETL workflows
   - Data quality handling and transformations

3. **Data Modeling**
   - Fact and dimension table design
   - Star schema optimized for analytical workloads

4. **Analytics & Reporting**
   - SQL-driven business insights
   - KPIs and trend analysis for decision support

🎯 This repository demonstrates hands-on expertise in:

- SQL Development
- Data Warehousing
- Data Engineering
- ETL Design
- Dimensional Modeling
- Business Analytics

---

## 🛠️ Tools & Technologies

- **SQL Server** – Data warehouse platform
- **SQL Server Management Studio (SSMS)** – Development & administration
- **Draw.io** – Architecture, data flow, and data model diagrams
- **Git & GitHub** – Version control and project management

---

## 🚀 Project Objectives

### Data Engineering

**Objective**  
Design and build a scalable SQL Server data warehouse to consolidate sales data from multiple source systems for analytics and reporting.

**Key Requirements**

- Multiple source systems (ERP & CRM)
- Data cleansing and quality handling
- Unified analytical data model
- Latest snapshot reporting (no historization)
- Clear documentation for technical and business users

---

### Analytics & Reporting

**Objective**  
Enable business insights through SQL-based analytics, including:

- Customer behavior analysis
- Product performance evaluation
- Sales trend analysis

These insights support **data-driven decision-making** across business stakeholders.

---

## 📂 Repository Structure

```
sql-data-warehouse-project/
│
├── datasets/                           # Raw datasets used for the project (ERP and CRM data)
│
├── docs/                               # Project documentation and architecture details
│   ├── etl.drawio                      # Draw.io file shows all different techniques and methods of ETL
│   ├── data_architecture.drawio        # Draw.io file shows the project's architecture
│   ├── data_catalog.md                 # Catalog of datasets, including field descriptions and metadata
│   ├── data_flow.drawio                # Draw.io file for the data flow diagram
│   ├── data_models.drawio              # Draw.io file for data models (star schema)
│   ├── naming_conventions.md           # Consistent naming guidelines for tables, columns, and files
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── bronze/                         # Scripts for extracting and loading raw data
│   ├── silver/                         # Scripts for cleaning and transforming data
│   ├── gold/                           # Scripts for creating analytical models
│
├── tests/                              # Test scripts and quality files
│
├── README.md                           # Project overview and instructions
├── LICENSE                             # License information for the repository
├── .gitignore                          # Files and directories to be ignored by Git
└── requirements.txt                    # Dependencies and requirements for the project

```

---

## 🧠 Key Takeaways

- Demonstrates **end-to-end data warehouse design**
- Uses **real-world enterprise patterns**
- Focuses on **clarity, scalability, and analytics performance**
- Designed as a **production-style portfolio project**

---

## 🙏 Attribution & Credits

This project is **inspired by and based on the SQL Data Warehouse project concept** taught by  
**Baraa Khatib Salkini** through **Data With Baraa Academy**.

- Original learning material and datasets were provided as part of a structured educational program
- This repository represents my **independent implementation**, re-designed, re-written, and documented end-to-end as a **personal portfolio project**
- All architecture design, SQL scripts, documentation, and repository structure in this project are **created and maintained by me**

🔗 Credit & Reference:

- **Instructor:** Baraa Khatib Salkini
- **Platform:** Data With Baraa Academy
- **Purpose:** Educational inspiration and real-world data engineering practice

Proper credit is given with respect and gratitude to the original source.

---

## 👤 About the Author

**Mohammed Afzal Shariff**  
BI & Analytics Associate Manager | Data Engineering | SQL | Power BI | Databricks  
📍 Bengaluru, India

Mohammed Afzal Shariff is a Business Intelligence and Analytics professional with 17+ years of experience designing and delivering enterprise-scale reporting, data warehousing, and analytics solutions.

He specializes in SQL-based data platforms, dimensional modeling, ETL pipeline design, and modern analytics architectures, with a strong focus on building reliable, scalable, and business-ready data solutions that enable informed decision-making.

This project was rebuilt from scratch as part of advanced data engineering practice, inspired by industry-grade training from Data With Baraa Academy.

---

## 🛡️ License

This project is licensed under the **MIT License**.  
Feel free to use, modify, and adapt with proper attribution.
