# 📊 End-to-End Data Warehouse & Power BI Analytics Dashboard

![Architecture](https://img.shields.io/badge/Architecture-Medallion_(Bronze_Silver_Gold)-blue?style=for-the-badge)
![Data Warehouse](https://img.shields.io/badge/Data_Warehouse-SQL-CC292B?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)
![Power BI](https://img.shields.io/badge/Power_BI-Dashboard-F2C94C?style=for-the-badge&logo=powerbi&logoColor=black)
![Status](https://img.shields.io/badge/Status-Completed-success?style=for-the-badge)

An overview of an end-to-end Data Warehouse implementation leveraging the **Medallion Architecture** to process, clean, and model raw data across three distinct layers (Bronze, Silver, Gold). The pipeline connects seamlessly to an interactive **Power BI** dashboard to deliver actionable business intelligence and support strategic decision-making.

---

## 📑 Table of Contents
- [🎯 Project Objective](#-project-objective)
- [🏗️ Data Warehouse Architecture](#️-data-warehouse-architecture)
- [🔄 Medallion Architecture Layers](#-medallion-architecture-layers)
  - [🟤 Bronze Layer (Raw Data)](#-1-bronze-layer-raw-data)
  - [⚪ Silver Layer (Cleansed & Transformed)](#-2-silver-layer-cleansed--transformed)
  - [🟡 Gold Layer (Business Ready & Aggregated)](#-3-gold-layer-business-ready--aggregated)
- [📐 Data Modeling & Star Schema](#-data-modeling--star-schema)
- [📊 DAX Measures & Power BI Calculations](#-dax-measures--power-bi-calculations)
- [📈 Power BI Dashboard](#-power-bi-dashboard)
- [🛠️ Tech Stack](#️-tech-stack)
- [🚀 How to Run](#-how-to-run)

---

## 🎯 Project Objective
The primary goal of this project is to transform raw, unstructured data from multiple sources into a centralized, scalable, and highly efficient analytical Data Warehouse. By strictly applying data quality and validation rules, the solution prepares consumption-ready data models that power interactive Power BI reports to help stakeholders monitor Key Performance Indicators (KPIs) and business trends.

---
## 🏗️ Data Warehouse Architecture

The solution follows the industry-standard **Medallion Architecture**, ensuring clear separation of concerns, end-to-end data lineage, easy maintenance, and robust data quality validation at every stage.

---
mermaid
graph TD
    A[Raw Data Sources] --> B[Bronze Layer: Raw Ingestion]
    B --> C[Silver Layer: Cleansed & Validated]
    C --> D[Gold Layer: Star Schema & Aggregations]
    D --> E[Power BI Interactive Dashboard]
---

## 🔄 Medallion Architecture Layers

### 🟤 1. Bronze Layer (Raw Data)
* **Description:** The raw landing zone where data is ingested directly from source systems without altering its format or granularity.
* **Key Operations:**
  - Ingesting raw files (CSV, operational databases, etc.).
  - Preserving historical snapshots and raw structures for auditability.
  - Injecting metadata columns such as `Ingestion_Timestamp` to trace data freshness.
  - Retaining original data types to prevent data loss during early ingestion.

### ⚪ 2. Silver Layer (Cleansed & Transformed)
* **Description:** The curated data layer where raw data is cleaned, validated, enriched, and structured into reliable tables.
* **Key Operations:**
  - **Data Cleaning:** Handling missing values, removing duplicate records, and trimming whitespaces.
  - **Data Standardization:** Casting columns to appropriate data types, standardizing formats (dates, text cases).
  - **Validation & Business Rules:** Applying business logic and integrity checks to filter invalid records.
  - **Structural Adjustments:** Merging normalized entities and removing non-essential fields.

### 🟡 3. Gold Layer (Business Ready & Aggregated)
* **Description:** The presentation-ready layer optimized for reporting, advanced analytics, and BI integration.
* **Key Operations:**
  - **Data Modeling:** Transforming cleansed data into a **Star Schema** consisting of Fact and Dimension tables.
  - **Aggregations:** Computing pre-calculated metrics to accelerate analytical query performance.
  - **Indexing & Optimization:** Tuning table indexes for fast execution when queried by Power BI.

---

## 📐 Data Modeling & Star Schema

The Gold Layer is structured using dimensional modeling principles (Kimball methodology) to optimize analytical performance:
- **Fact Table:** Captures transactional metrics and quantitative measurements (e.g., `Fact_Transactions`).
- **Dimension Tables:** Contains context and attributes for filtering and grouping (e.g., `Dim_Customer`, `Dim_Merchants`, `Dim_Date`).

---
## 📈 Power BI Dashboard & Advanced Features

The Gold Layer serves as the direct engine powering a multi-page, highly interactive **Power BI Dashboard** (4 main analytical views + contextual detail pages). Designed with a modern Dark Theme UI, it ensures intuitive navigation and seamless data exploration.

### 🖼️ Dashboard Pages Overview

1. **Overview Page:** Executive summary displaying high-level KPIs (`Total Customers`, `Total Merchants`, `Total Transactions`, `Total Sales`), merchant activity trends, and quarterly customer performance.
2. <img width="1323" height="745" alt="image" src="https://github.com/user-attachments/assets/80351855-8409-4bf4-9859-7298e8de3e4a" />

3. **Customers Page:** In-depth customer demographics analysis, geographical sales mapping (Azure Maps), distribution by `loyalty_tier`, `job`, and age metrics.
4. <img width="1317" height="737" alt="image" src="https://github.com/user-attachments/assets/291ac2d5-1c11-424d-a384-361a818bf9c9" />


5. **Transactions Page:** Transactional behavioral analysis across payment channels (`digital_wallet`, `debit_card`, `credit_card`), Category-wise breakdown, and fraud rate monitoring.
6. <img width="1325" height="737" alt="image" src="https://github.com/user-attachments/assets/cd82affd-cdb8-4b9c-aab7-c6d0f7638354" />

7. **Merchants Page:** Merchant tenure analysis, fraud transaction distribution by device type, and merchant breakdown by `dominant_category`.
8. <img width="1317" height="738" alt="image" src="https://github.com/user-attachments/assets/b61f9aa0-178e-4e2f-9524-3f7d6cb18ed4" />


---

### 🚀 Advanced UX & Interactive Features

- **Drill-Through Capabilities:** Enables users to right-click on high-level visuals (e.g., specific customer tiers or merchant categories) and navigate directly to dedicated granular detail pages (such as Customer Detail Table or Merchant Audit Page) with context automatically filtered.
- **Custom Report Page Tooltips:** Hovering over dynamic dimensions (such as `dominant_category`) triggers custom tooltip pages displaying supplementary sub-metrics and mini-visuals without cluttering the main screen.
- **Dynamic Slicers & Cross-Filtering:** Comprehensive slicers for timeframes (`month_name`), categories, and merchant tenure across all report views.

- -------
<table>
  <thead>
    <tr>
      <th align="left">Category</th>
      <th align="left">Technology / Tools Used</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><b>Data Warehouse</b></td>
      <td>SQL Server Management Studio (SSMS)</td>
    </tr>
    <tr>
      <td><b>ETL & Data Processing</b></td>
      <td>T-SQL / Stored Procedures</td>
    </tr>
    <tr>
      <td><b>Data Modeling</b></td>
      <td>Star Schema Design (Kimball Methodology)</td>
    </tr>
    <tr>
      <td><b>Business Intelligence</b></td>
      <td>Microsoft Power BI (DAX, Power Query)</td>
    </tr>
    <tr>
      <td><b>Version Control</b></td>
      <td>Git & GitHub</td>
    </tr>
  </tbody>
</table>

-----------------------------------------
🚀 How to Run
## Database Setup:

1. Run the SQL scripts for the Bronze layer to load the raw source datasets.

2. Execute the Silver layer procedures to execute data cleaning and transformations.

3. Run the Gold layer scripts to build the Fact and Dimension tables.

## Power BI Dashboard Configuration:

1. Open Dashboard.pbix in Power BI Desktop.

2. Update the Data Source Settings to point to your Gold Layer database.

3. Click Refresh to load the processed data into the visuals.

