 🛒 TheLook eCommerce Analytics Pipeline with dbt, BigQuery & Power BI

[![dbt](https://img.shields.io/badge/dbt-Core%20%2F%20Cloud-FF694B?logo=dbt&logoColor=white)](https://www.getdbt.com/)
[![Google BigQuery](https://img.shields.io/badge/Data_Warehouse-Google_BigQuery-669DF6?logo=google-cloud&logoColor=white)](https://cloud.google.com/bigquery)
[![Power BI](https://img.shields.io/badge/BI_Tool-Microsoft_Power_BI-F2C811?logo=power-bi&logoColor=black)](https://powerbi.microsoft.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

An end-to-end modern data stack pipeline implementing Medallion Architecture (Staging ➔ Intermediate ➔ Marts) using **dbt Core** and **Google BigQuery** on the public `thelook_ecommerce` dataset, finalized with an interactive 2-page executive dashboard in **Microsoft Power BI**.

---

## 🏗️ Architecture & Data Lineage

```mermaid
graph LR
    subgraph Sources
        src_orders[(orders)]
        src_items[(order_items)]
        src_users[(users)]
        src_products[(products)]
    end

    subgraph Staging
        stg_orders[stg_orders]
        stg_items[stg_order_items]
        stg_users[stg_users]
        stg_products[stg_products]
    end

    subgraph Intermediate
        int_details[int_order_items_detailed]
    end

    subgraph Marts
        fct_orders[fct_orders]
        dim_users[dim_users]
    end

    src_orders --> stg_orders
    src_items --> stg_items
    src_users --> stg_users
    src_products --> stg_products

    stg_orders --> int_details
    stg_items --> int_details
    stg_products --> int_details

    stg_orders --> fct_orders
    int_details --> fct_orders

    stg_users --> dim_users
    stg_orders --> dim_users
    fct_orders --> dim_users


📂 Project Structure & Medallion Layers
Staging Layer (Materialized as Views):
--stg_orders: Type casting of timestamps, column renaming, and standardizing status fields.--stg_order_items: Line-item transactions with sale prices and product references.
--stg_products: Product catalog with retail prices, costs, and brand categorization.
--stg_users: Customer profiles, registration metadata, and geographic attributes.

Intermediate Layer (Materialized as Views):
--int_order_items_detailed: Denormalized line-item table joining order items with product cost data to compute item-level gross margins.

Marts Layer (Materialized as Tables):
--fct_orders: Star-schema fact table aggregating order metrics (gross revenue, item counts, product costs, total profit margins, and fulfillment statuses).
--dim_users: Customer dimension enriched with lifetime value (LTV), total order counts, and first/last order acquisition dates.

🧪 Data Quality & Testing
Schema validations are configured in models/marts/schema.yml to ensure data integrity:
--Primary Key Assertions: unique and not_null tests on order_id and user_id.
--Referential Integrity: Validated relationship references between fact and dimension tables.
--Domain Validation: accepted_values test enforcing permissible order lifecycle statuses (Complete, Cancelled, Processing, Shipped, Returned).

📈 Power BI Reporting Layer
The dimensional models (fct_orders, dim_users) are consumed by a 2-page executive report in Microsoft Power BI Desktop & Service, optimized with custom DAX calculations and cross-filtering:

1. Executive OverviewCore 
--KPIs: Total Revenue ($), `Total Profit` ($), Profit Margin %, and AOV.
--Revenue vs. Margin Trend: Line and clustered column chart showing monthly sales volume against margin stability.
--Geographic & Demographics: Revenue breakdown by top international markets and customer age brackets (<20, 20-35, 36-50, 51-65, 65+).
--Order Status: Donut visual tracking order completion, cancellation, and return rates.

2. Customer Analytics
--Retention Metrics: Total Customers, Active Customers, Repeat Customer Rate %, and Average CLV.--Acquisition Trends: Customer account creation momentum over time.
--Traffic Channels: Sales volume attributed to traffic sources (Search, Organic, Facebook, Display, Email).
--Order Frequency Segmentation: Customer distribution categorized by purchase count (1 Order, 2-3 Orders, 4-5 Orders, 6+ Orders).
--VIP Performance: Top lifetime contributors matrix.

📐 Core DAX Measures

-- Total Revenue
Total Revenue = SUM('fct_orders'[sale_price])

-- Profit Margin %
Profit Margin % = 
DIVIDE([Total Profit], [Total Revenue], 0)

-- Active Purchasing Customers
Active Customers = DISTINCTCOUNT('fct_orders'[user_id])

-- Average Customer Lifetime Value
Average CLV = DIVIDE([Total Revenue], [Active Customers], 0)

-- Repeat Customer Rate %
Repeat Customers = 
CALCULATE(
    DISTINCTCOUNT('dim_users'[user_id]),
    'dim_users'[lifetime_orders] >= 2
)

Repeat Customer Rate % = 
DIVIDE([Repeat Customers], [Active Customers], 0)


🚀 Getting Started
Prerequisites
1.Python 3.10+
2.Google Cloud Platform account with BigQuery enabled
3.Google Cloud CLI (gcloud) authenticated via OAuth or Service Account
4.Microsoft Power BI Desktop

Installation & Run
1.Activate Virtual Environment:
--PowerShell
.\venv\Scripts\Activate.ps1
cd thelook_analytics

2.Verify Connections:
--PowerShell
dbt debug

3.Build Models & Run Tests:
--PowerShell
dbt run
dbt test

4.Launch Documentation & Lineage Graph:
--PowerShell
dbt docs generate
dbt docs serve

5.Power BI Setup:
--Open Power BI Desktop and connect to Google BigQuery.
--Import fct_orders and dim_users from your dataset.
--Build relationships on user_id (1:N) and apply the DAX measures provided above.

👤 Author
--Dennis Iliopoulos https://github.com/Deniliop