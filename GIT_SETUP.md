# Git Repository Setup Guide

Step-by-step instructions to set up this project as a Git repository and push to GitHub.

---

## 📋 Prerequisites

- [ ] Git installed on your machine
- [ ] GitHub account created
- [ ] Git configured with your name and email

### Verify Git Installation
```bash
git --version
# Should show: git version 2.x.x
```

### Configure Git (if not done)
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

---

## 🚀 Step 1: Initialize Local Repository

```bash
# Navigate to project directory
cd c:\Users\750571\Desktop\codeClaude\Oracle-SnowFlake-DBt

# Initialize git repository
git init

# Verify .gitignore exists
# (It should already be there - protects sensitive data!)
cat .gitignore
```

---

## 🔐 Step 2: Protect Sensitive Data

**IMPORTANT**: Before committing, ensure these files are NOT tracked:

```bash
# Check what will be committed
git status

# These should NOT appear:
# ❌ oracle_snowflake_dbt/.env
# ❌ oracle_snowflake_dbt/profiles.yml
# ❌ Any files with credentials

# If they appear, they're already in .gitignore
# If not, add them to .gitignore immediately!
```

---

## 📦 Step 3: Stage and Commit Files

```bash
# Add all files (respecting .gitignore)
git add .

# Check what will be committed
git status

# Create first commit
git commit -m "Initial commit: Oracle to Snowflake migration project with dbt

- Complete ETL pipeline using Azure Data Factory
- 10 Oracle tables migrated to Snowflake
- 13 dbt transformation models
- Comprehensive documentation
- Automated testing and validation"
```

---

## 🌐 Step 4: Create GitHub Repository

### Option A: Via GitHub Website (Recommended)

1. Go to https://github.com/new
2. **Repository name**: `oracle-snowflake-migration-dbt`
3. **Description**: `End-to-end data migration from Oracle to Snowflake using Azure Data Factory and dbt transformations`
4. **Visibility**:
   - ✅ **Public** (for portfolio - recommended)
   - or Private (if you prefer)
5. **DO NOT** initialize with README (we already have one)
6. Click "Create repository"

### Option B: Via GitHub CLI

```bash
# Install GitHub CLI if not already
# https://cli.github.com/

# Login
gh auth login

# Create repository
gh repo create oracle-snowflake-migration-dbt --public --source=. --remote=origin
```

---

## 🔗 Step 5: Connect Local to Remote

After creating the GitHub repository, connect it:

```bash
# Add remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/oracle-snowflake-migration-dbt.git

# Verify remote
git remote -v

# Push to GitHub
git push -u origin main
# or if your default branch is 'master':
# git push -u origin master
```

---

## ✨ Step 6: Add Repository Topics (GitHub)

On your GitHub repository page:
1. Click "⚙️ Manage topics"
2. Add these topics:
   - `data-engineering`
   - `etl`
   - `snowflake`
   - `azure-data-factory`
   - `dbt`
   - `oracle`
   - `data-warehouse`
   - `analytics-engineering`
   - `portfolio-project`

---

## 📝 Step 7: Customize README

Update the README.md with your personal information:

```bash
# Edit README.md
# Replace placeholders:
# - [Your Name]
# - [Your LinkedIn Profile]
# - [Your GitHub Profile]
# - [Your Email]
```

Then commit the changes:
```bash
git add README.md
git commit -m "docs: Update README with personal information"
git push
```

---

## 🎨 Step 8: Add Project Highlights (Optional)

### Create a Project Banner

Use tools like:
- https://www.canva.com/ (free design tool)
- https://carbon.now.sh/ (code screenshots)

Save as `docs/images/banner.png` and reference in README.

### Add Badges

Already included in README:
- dbt version
- Snowflake ready
- Azure Data Factory

### Add Screenshots

Create `docs/images/` folder:
```bash
mkdir -p docs/images
```

Take screenshots of:
1. dbt lineage graph (from `dbt docs serve`)
2. Snowflake data model
3. ADF pipeline

Add to repository:
```bash
git add docs/images/
git commit -m "docs: Add project screenshots"
git push
```

---

## 📊 Step 9: GitHub Repository Settings

### Enable GitHub Pages (Optional)

1. Repository → Settings → Pages
2. Source: Deploy from a branch
3. Branch: `main` → `/docs`
4. Save

This can host your dbt docs!

### Add Repository Description

1. Repository main page → About (⚙️)
2. Description: "End-to-end data engineering project: Oracle → Azure Data Factory → Snowflake → dbt"
3. Website: Your portfolio website
4. Topics: (already added in Step 6)
5. Save changes

---

## 🔄 Step 10: Regular Updates

### Making Changes

```bash
# Pull latest changes (if working from multiple locations)
git pull

# Make your changes
# ... edit files ...

# Stage changes
git add .

# Commit with meaningful message
git commit -m "feat: Add incremental model for sales fact table"

# Push to GitHub
git push
```

### Commit Message Convention

Use conventional commits:
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `refactor:` - Code refactoring
- `test:` - Adding tests
- `chore:` - Maintenance tasks

Examples:
```bash
git commit -m "feat: Add customer segmentation report"
git commit -m "docs: Update setup instructions"
git commit -m "fix: Correct profit margin calculation in fct_sales"
git commit -m "refactor: Optimize dim_customer query performance"
```

---

## 🌟 Step 11: Make Your Repository Stand Out

### Add a CONTRIBUTING.md (if you want contributions)

```markdown
# Contributing

This is a portfolio project, but feedback is welcome!

## Reporting Issues
- Use GitHub Issues
- Provide detailed descriptions
- Include error messages if applicable

## Suggestions
- Feature requests welcome
- Performance improvements appreciated
```

### Add a LICENSE

For portfolio projects, consider:
- **MIT License** (most permissive)
- **Apache 2.0** (includes patent protection)

```bash
# Create LICENSE file
# Choose from: https://choosealicense.com/

git add LICENSE
git commit -m "docs: Add MIT license"
git push
```

---

## ✅ Repository Checklist

- [ ] Repository created on GitHub
- [ ] .gitignore properly configured
- [ ] No sensitive data committed
- [ ] README.md customized with your info
- [ ] Repository description added
- [ ] Topics/tags added
- [ ] Screenshots added (optional)
- [ ] License added (optional)
- [ ] All commits have meaningful messages

---

## 🎓 Share Your Project

### On LinkedIn

Post template:
```
🚀 Excited to share my latest data engineering project!

I built an end-to-end data pipeline migrating 1M+ records from Oracle to Snowflake:

✅ Azure Data Factory for automated ETL
✅ dbt for SQL transformations
✅ 13 analytics models in production
✅ Complete documentation & testing

Tech Stack: Oracle | Azure Data Factory | Snowflake | dbt | SQL | Python

Key outcomes:
📊 10 tables migrated
⚡ Automated pipeline processing
📈 Analytics-ready data models
🧪 Comprehensive testing

Check it out: [Your GitHub Repo URL]

#DataEngineering #Snowflake #Azure #dbt #Analytics #Portfolio
```

### On GitHub Profile README

Add to your profile:
```markdown
### 🔥 Featured Project
**[Oracle to Snowflake Migration](repo-url)** - Complete data engineering pipeline with ADF and dbt
```

---

## 🆘 Common Git Issues

### Issue: "Permission denied"
```bash
# Use HTTPS instead of SSH initially
git remote set-url origin https://github.com/YOUR_USERNAME/repo.git
```

### Issue: "Large file detected"
```bash
# Remove from history
git rm --cached path/to/large/file
git commit --amend
git push --force
```

### Issue: "Merge conflicts"
```bash
# Pull with rebase
git pull --rebase origin main
# Resolve conflicts manually
git add .
git rebase --continue
git push
```

---

**Your repository is now ready to showcase your skills!** 🎉

Remember to keep your `.env` file and credentials secure - they should NEVER be committed to Git!
