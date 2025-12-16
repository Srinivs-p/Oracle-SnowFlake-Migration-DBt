# Oracle to Snowflake Migration with Azure Data Factory & dbt

> A complete end-to-end data engineering project demonstrating modern data stack implementation

[![dbt](https://img.shields.io/badge/dbt-1.10.15-orange.svg)](https://www.getdbt.com/)
[![Snowflake](https://img.shields.io/badge/Snowflake-Ready-blue.svg)](https://www.snowflake.com/)
[![Azure](https://img.shields.io/badge/Azure-Data%20Factory-0078D4.svg)](https://azure.microsoft.com/en-us/services/data-factory/)

## 📋 Project Overview

This project showcases a production-ready data migration and transformation pipeline that migrates data from **Oracle Database** to **Snowflake Data Warehouse** using **Azure Data Factory** for ETL and **dbt (data build tool)** for transformations.

### Business Context
Migration of a retail analytics database with **10 tables** containing sales, customer, product, and cost data from legacy Oracle infrastructure to modern cloud data warehouse architecture.

---

## 🏗️ Architecture

```
┌─────────────────┐
│ Oracle Database │ (Source)
│  - 10 Tables    │
│  - DBT_USER     │
└────────┬────────┘
         │
         ▼
┌──────────────────────────────────┐
│ Azure Data Factory (ADF)         │
│  - Dynamic Pipelines             │
│  - ForEach Loops                 │
│  - Parallel Processing           │
│  - Azure Blob Storage (Staging)  │
└────────┬─────────────────────────┘
         │
         ▼
┌──────────────────────────────────┐
│ Snowflake Data Warehouse         │
│                                  │
│  📊 STAGING Schema               │
│    - Raw Oracle data (10 tables) │
│                                  │
│  🔄 dbt Transformations          │
│                                  │
│  📈 INTERMEDIATE_STAGING_DBT     │
│    - 9 Staging Views             │
│                                  │
│  🎯 INTERMEDIATE_MART            │
│    - 2 Dimension Tables          │
│    - 1 Fact Table                │
│    - 1 Reporting Table           │
└──────────────────────────────────┘
```

---

## 🎯 Key Features

### Data Engineering
- ✅ **Automated ETL Pipeline** - Dynamic ADF pipeline handles all 10 tables
- ✅ **Parallel Processing** - Configurable batch processing (5 tables at a time)
- ✅ **Error Handling** - Robust retry logic and logging
- ✅ **Incremental Loads** - Support for both full and incremental refreshes

### Data Transformation
- ✅ **Modular dbt Models** - 13 transformation models across 3 layers
- ✅ **Data Quality** - Built-in validation and testing
- ✅ **Documentation** - Auto-generated lineage and catalog
- ✅ **Version Control** - All SQL transformations in Git

### Analytics Ready
- ✅ **Dimensional Modeling** - Star schema with facts and dimensions
- ✅ **Customer Analytics** - RFM segmentation and lifetime value
- ✅ **Product Performance** - Category hierarchies and profitability
- ✅ **Sales Reporting** - Time-series analysis and trends

---

## 📊 Data Models

### Source Tables (Oracle)
| Table | Description | Records |
|-------|-------------|---------|
| CUSTOMERS | Customer demographics | 55K+ |
| PRODUCTS | Product catalog | 72 |
| SALES | Sales transactions | 918K+ |
| COSTS | Product costs | 82K+ |
| CHANNELS | Sales channels | 5 |
| COUNTRIES | Geographic data | 23 |
| TIMES | Date dimension | 1.8K+ |
| PROMOTIONS | Marketing promotions | 503 |
| SUPPLEMENTARY_DEMOGRAPHICS | Additional customer data | - |

### dbt Transformation Layers

#### 1. Staging Layer (9 models)
Clean and standardize raw data:
- `stg_customers` - Customer dimension with age calculation
- `stg_products` - Product catalog with pricing tiers
- `stg_sales` - Sales validation and quality checks
- `stg_costs` - Cost data with margin calculations
- `stg_channels`, `stg_countries`, `stg_times`, `stg_promotions`, `stg_supplementary_demographics`

#### 2. Mart Layer - Dimensions (2 models)
- `dim_customer` - Complete customer profiles with segmentation
- `dim_product` - Product hierarchy and classification

#### 3. Mart Layer - Facts (1 model)
- `fct_sales` - Sales fact with cost and profitability metrics

#### 4. Mart Layer - Reports (1 model)
- `rpt_sales_by_customer` - Customer analytics with RFM analysis

---

## 🛠️ Technology Stack

| Component | Technology | Purpose |
|-----------|-----------|---------|
| **Source Database** | Oracle Database | Legacy data source |
| **ETL/ELT** | Azure Data Factory | Data orchestration and movement |
| **Staging** | Azure Blob Storage | Temporary data staging |
| **Data Warehouse** | Snowflake | Cloud data warehouse |
| **Transformations** | dbt (data build tool) | SQL-based transformations |
| **Language** | SQL, Python, PowerShell | Development |
| **Version Control** | Git | Code management |

---

## 📁 Project Structure

```
Oracle-SnowFlake-DBt/
│
├── README.md                          # This file
├── .gitignore                         # Git ignore rules
├── readMe.txt                         # Original project plan
│
├── tables/
│   ├── SourceTables.sql              # Oracle DDL scripts
│   └── Snowflake_Tables.sql          # Snowflake DDL scripts
│
├── ADF_SETUP_GUIDE.md                # Azure Data Factory setup
├── SNOWFLAKE_SETUP_GUIDE.md          # Snowflake configuration
│
├── oracle_snowflake_dbt/             # dbt Project
│   ├── dbt_project.yml               # dbt configuration
│   ├── profiles.yml                  # Snowflake connection (gitignored)
│   ├── .env.template                 # Environment variables template
│   ├── run_dbt.ps1                   # PowerShell helper script
│   │
│   └── models/
│       ├── staging/
│       │   ├── sources.yml           # Source definitions
│       │   ├── stg_customers.sql
│       │   ├── stg_products.sql
│       │   ├── stg_sales.sql
│       │   └── ... (6 more)
│       │
│       └── marts/
│           ├── core/
│           │   ├── dim_customer.sql
│           │   ├── dim_product.sql
│           │   └── fct_sales.sql
│           │
│           └── reporting/
│               └── rpt_sales_by_customer.sql
│
└── Documentation/
    ├── DBT_SETUP_GUIDE.md
    ├── DBT_MODELS_PLAN.md
    └── COMPLETE_DBT_PROJECT_SUMMARY.md
```

---

## 🚀 Getting Started

### Prerequisites
- Oracle Database access
- Azure subscription with Data Factory
- Snowflake account
- Python 3.8+ with dbt-snowflake
- Git

### Installation

1. **Clone the repository**
```bash
git clone <your-repo-url>
cd Oracle-SnowFlake-DBt
```

2. **Set up Python virtual environment**
```bash
python -m venv .venv
.venv\Scripts\activate  # Windows
pip install dbt-snowflake
```

3. **Configure credentials**
```bash
cd oracle_snowflake_dbt
cp .env.template .env
# Edit .env with your Snowflake credentials
```

4. **Test dbt connection**
```powershell
.\run_dbt.ps1 debug
```

5. **Run transformations**
```powershell
.\run_dbt.ps1 run
```

---

## 📈 Sample Analytics Queries

### Top 10 Customers by Revenue
```sql
SELECT
    full_name,
    total_revenue,
    total_transactions,
    customer_segment,
    customer_lifetime_value
FROM INTERMEDIATE_MART.rpt_sales_by_customer
ORDER BY total_revenue DESC
LIMIT 10;
```

### Product Profitability Analysis
```sql
SELECT
    p.category,
    p.product_name,
    SUM(s.amount_sold) AS revenue,
    SUM(s.gross_profit) AS profit,
    AVG(s.profit_margin_percentage) AS avg_margin_pct
FROM INTERMEDIATE_MART.fct_sales s
JOIN INTERMEDIATE_MART.dim_product p ON s.product_id = p.product_id
GROUP BY p.category, p.product_name
ORDER BY profit DESC;
```

### Customer Segmentation Distribution
```sql
SELECT
    customer_segment,
    COUNT(*) AS customer_count,
    SUM(total_revenue) AS segment_revenue,
    AVG(customer_lifetime_value) AS avg_clv
FROM INTERMEDIATE_MART.rpt_sales_by_customer
GROUP BY customer_segment
ORDER BY segment_revenue DESC;
```

---

## 🧪 Testing & Quality

### dbt Tests
```powershell
# Run all tests
.\run_dbt.ps1 test

# Test specific model
.\run_dbt.ps1 test --select dim_customer
```

### Data Quality Checks
- ✅ Unique primary keys
- ✅ Not null constraints
- ✅ Referential integrity
- ✅ Valid date ranges
- ✅ Positive amounts

---

## 📚 Documentation

### Generate dbt Docs
```powershell
.\run_dbt.ps1 docs generate
.\run_dbt.ps1 docs serve
```

This creates an interactive website with:
- 📊 Data lineage diagrams
- 📝 Model descriptions
- 🔗 Column-level documentation
- 🌳 Dependency graphs

---

## 🎓 Skills Demonstrated

### Data Engineering
- Cloud data warehouse architecture (Snowflake)
- ETL pipeline development (Azure Data Factory)
- SQL optimization and performance tuning
- Data modeling (dimensional modeling)

### Development & DevOps
- Version control (Git)
- Infrastructure as Code
- Automation and scripting (PowerShell, Python)
- CI/CD practices

### Analytics Engineering
- dbt transformations
- Data quality testing
- Documentation generation
- Analytics-ready data modeling

---

## 📊 Performance Metrics

- **Pipeline Execution Time**: ~15-30 minutes (for full refresh)
- **Data Volume**: 1M+ records processed
- **Tables Migrated**: 10 source tables
- **Models Created**: 13 dbt models
- **Parallel Processing**: 5 tables simultaneously

---

## 🔐 Security & Best Practices

- ✅ Credentials stored in `.env` files (gitignored)
- ✅ Azure SAS tokens for secure blob access
- ✅ Snowflake role-based access control
- ✅ Encrypted data in transit
- ✅ Audit trails and logging

---

## 🛣️ Roadmap & Future Enhancements

- [ ] Implement incremental models for large fact tables
- [ ] Add data quality monitoring dashboard
- [ ] Schedule automated pipeline runs
- [ ] Implement slowly changing dimensions (SCD Type 2)
- [ ] Create Power BI/Tableau dashboards
- [ ] Add real-time CDC (Change Data Capture)

---

## 📝 License

This project is available for educational and portfolio purposes.

---

## 🤝 Connect

**Author**: Srinivas Perumandla
**LinkedIn**: https://www.linkedin.com/in/srinivs-p
**GitHub**:  https://github.com/Srinivs-p
**Email**: *********@****.com 

---

## 🙏 Acknowledgments

- Oracle sample database (SH schema)
- dbt community for best practices
- Snowflake documentation
- Azure Data Factory tutorials

---

## 📸 Screenshots

### dbt Lineage Graph
![dbt Lineage](docs/images/dbt-lineage.png)

### Snowflake Data Model
![Data Model](docs/images/data-model.png)

### ADF Pipeline
![ADF Pipeline](docs/images/adf-pipeline.png)

---

**⭐ If you found this project helpful, please consider giving it a star!**
