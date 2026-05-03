# Executive Sales & Inventory Intelligence: Retail Sector

## 📊 Project Overview
This business intelligence project delivers a comprehensive data analysis solution for a retail bakery and pastry establishment. Using **PostgreSQL** for data management and **Power BI** for advanced visualization, the project transforms raw transactional data into actionable insights for operational and financial optimization.

---

## 📈 Executive Summary
Based on the analyzed period, the business processed **20,918 units** across **3,478 orders**, resulting in total revenue of **$108,661**. The operation maintains a gross profit of **$58,592**, with a consistent **54% margin** over production costs ($50,007).

### Key Performance Indicators (KPIs)
*   **Total Revenue:** $108,661
*   **Net Profit:** $58,592
*   **Average Ticket (AOV):** $31.00
*   **Total Units Sold:** 20,918

---

## 🔍 Strategic Business Insights

### 1. Product Performance & Pricing Strategy
The analysis identifies the **"Café Marrón Grande"** as the high-volume leader, while the **"Golfeado con Queso"** shows lower traction.

*   **Pricing Strategy:** A 54% margin is recommended to maintain competitiveness. Increasing prices could lead to customer churn and brand damage.
*   **Product Quality Alerts:** Items with lower ratings (2-3 stars), such as the "Golfeado con Queso", require quality or marketing interventions to justify their production costs.

### 2. Operational Efficiency (Peak Hours)
Data reveals that **Sundays, Thursdays, and Saturdays** account for 50% of total weekly orders.

*   **Peak Demand:** 8:00 AM and 4:00 PM are the busiest windows.
*   **Recommendations:** Optimization of front-of-house staff and production scheduling is critical during these high-traffic periods to ensure service quality.

### 3. Inventory & Display Management
Display cases show an average turnover of **33 daily units per product**.

*   **Autonomy:** Current stock levels provide 2 days of autonomy.
*   **Waste Mitigation:** Reducing production batches for slow-moving items to a 1-day cycle is advised to guarantee freshness and minimize shrinkage.

---

## 🛠️ Technical Stack
*   **Database Management:** PostgreSQL (Database Schema Design, Complex Joins, and Aggregations).
*   **Business Intelligence:** Power BI (Data Modeling, DAX Measures, and UI/UX Design).
*   **Data Audit:** Advanced SQL querying for data integrity and error detection.

---

## 🚀 Repository Structure

The project is organized into clear modules for data engineering, analysis, and visualization:

*   **`Assets/`**: Contains visual documentation of the project.
    *   `Dashboard_Screenshots/`: High-resolution images of all report pages.
    *   `Project_Demo.mp4`: A video walkthrough demonstrating the interactive features and filters.
*   **`Scripts/`**: The core technical logic of the project.
    *   `01_database_setup.sql`: DDL and DML scripts for PostgreSQL schema creation and data insertion.
    *   `02_business_queries.sql`: Advanced SQL queries for data auditing and business insight extraction.
    *   `03_dax_measures.md`: Detailed documentation of all DAX formulas, calculated columns, and business logic used in Power BI.
*   **`Retail-Sales-Intelligence.pbix`**: The master Power BI Desktop file containing the data model and interactive visualizations.
*   **`README.md`**: Project overview, business analysis, and technical documentation.