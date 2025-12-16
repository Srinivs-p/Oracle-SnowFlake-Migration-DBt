# Setup Instructions

Complete setup guide for reproducing this project.

## 📋 Prerequisites

- [ ] Oracle Database (11g or higher)
- [ ] Azure Subscription
- [ ] Snowflake Account (trial or licensed)
- [ ] Python 3.8 or higher
- [ ] Git
- [ ] PowerShell (Windows) or Bash (Mac/Linux)

---

## ⏱️ Estimated Time

- **Total Setup Time**: 2-3 hours
- Phase 1 (Snowflake): 30 minutes
- Phase 2 (Azure Data Factory): 45 minutes
- Phase 3 (dbt): 30 minutes
- Phase 4 (First Run): 30 minutes

---

## 🚀 Phase 1: Snowflake Setup

### 1.1 Create Snowflake Account
1. Sign up at https://signup.snowflake.com/
2. Choose your cloud provider (Azure recommended)
3. Select region closest to you
4. Verify email and login

### 1.2 Run Setup Script
1. Open Snowflake UI → Worksheets
2. Open `snowflake_setup.sql`
3. Execute the script
4. Verify: `SHOW DATABASES LIKE 'ORACLE_MIGRATION';`

**Expected Result**: Database with STAGING, INTERMEDIATE, and MART schemas

---

## 🚀 Phase 2: Azure Data Factory Setup

### 2.1 Create ADF Resource
1. Azure Portal → Create Resource → Data Factory
2. Name: `adf-oracle-snowflake-001`
3. Region: Same as Snowflake
4. Click Create

### 2.2 Create Linked Services
1. Launch ADF Studio
2. Manage → Linked Services → + New

**Oracle Linked Service:**
- Name: `LS_Oracle_Source`
- Host: Your Oracle server
- Port: 1521
- Service: Your Oracle service name
- Credentials: Oracle username/password

**Snowflake Linked Service:**
- Name: `LS_Snowflake_Target`
- Account: Your Snowflake account identifier
- User: Your Snowflake username
- Password: Your Snowflake password
- Database: `ORACLE_MIGRATION`
- Warehouse: `MIGRATION_WH`

**Azure Blob Storage Linked Service:**
- Name: `LS_AzureBlob_Staging`
- Authentication: SAS URI
- SAS URL: Generate from Azure Storage Account

### 2.3 Create Pipeline
Follow instructions in `ADF_SETUP_GUIDE.md`

---

## 🚀 Phase 3: dbt Setup

### 3.1 Install Python Dependencies
```bash
# Create virtual environment
python -m venv .venv

# Activate (Windows)
.venv\Scripts\activate

# Activate (Mac/Linux)
source .venv/bin/activate

# Install dbt
pip install dbt-snowflake
```

### 3.2 Configure dbt
```bash
cd oracle_snowflake_dbt

# Copy environment template
cp .env.template .env

# Edit .env with your Snowflake credentials
# SNOWFLAKE_ACCOUNT=your_account
# SNOWFLAKE_USER=your_username
# SNOWFLAKE_PASSWORD=your_password
```

### 3.3 Test Connection
```powershell
.\run_dbt.ps1 debug
```

**Expected Output**: "All checks passed!"

---

## 🚀 Phase 4: Run the Pipeline

### 4.1 Run ADF Pipeline
1. Open ADF Studio
2. Navigate to `PL_Oracle_To_Snowflake_AllTables`
3. Click Trigger → Trigger Now
4. Monitor execution
5. Verify data in Snowflake STAGING schema

### 4.2 Run dbt Models
```powershell
cd oracle_snowflake_dbt

# Run all models
.\run_dbt.ps1 run

# Generate documentation
.\run_dbt.ps1 docs generate
.\run_dbt.ps1 docs serve
```

---

## ✅ Verification Checklist

### Snowflake Verification
```sql
USE DATABASE ORACLE_MIGRATION;

-- Check schemas
SHOW SCHEMAS;

-- Check raw data
USE SCHEMA STAGING;
SHOW TABLES;
SELECT COUNT(*) FROM CUSTOMERS;

-- Check dbt models
USE SCHEMA INTERMEDIATE_STAGING_DBT;
SHOW VIEWS;

USE SCHEMA INTERMEDIATE_MART;
SHOW TABLES;
SELECT * FROM dim_customer LIMIT 10;
```

### dbt Verification
```powershell
# List all models
.\run_dbt.ps1 list

# Run tests
.\run_dbt.ps1 test

# Check compiled SQL
# Look in target/compiled/ folder
```

---

## 🐛 Common Issues & Solutions

### Issue: Oracle Connection Fails
**Solution**:
- Check firewall rules
- Verify Oracle is running
- Test with SQL Developer first

### Issue: Snowflake Authentication Error
**Solution**:
- Verify account identifier format (no https://)
- Check username/password
- Ensure warehouse exists

### Issue: ADF Staging Error (403 Forbidden)
**Solution**:
- Regenerate SAS token
- Verify expiry date
- Check permissions (Read, Write, Delete, List)

### Issue: dbt Environment Variables Not Loaded
**Solution**:
- Always use `.\run_dbt.ps1` instead of `dbt` directly
- Verify .env file exists
- Check for typos in variable names

---

## 📚 Additional Resources

- [Snowflake Documentation](https://docs.snowflake.com/)
- [Azure Data Factory Docs](https://docs.microsoft.com/en-us/azure/data-factory/)
- [dbt Documentation](https://docs.getdbt.com/)
- [Project README](README.md)

---

## 🆘 Getting Help

If you encounter issues:
1. Check the troubleshooting guides in each setup document
2. Review error messages carefully
3. Check configurations match templates
4. Verify all prerequisites are met

---

**Good luck with your setup!** 🚀
