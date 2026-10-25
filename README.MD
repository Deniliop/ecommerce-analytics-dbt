# 🛒 TheLook eCommerce Analytics Pipeline with dbt & BigQuery

An end-to-end modern data stack pipeline implementing Medallion Architecture (Staging ➔ Intermediate ➔ Marts) using **dbt Core** and **Google BigQuery** on the public `thelook_ecommerce` dataset.

---

## 🏗️ Architecture & Lineage

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
```

---

## 📂 Project Structure & Medallion Layers

* **Staging Layer (Materialized as Views):**
  * `stg_orders`: Type casting of timestamps, column renaming, and standardizing status fields.
  * `stg_order_items`: Line-item transactions with sale prices and product references.
  * `stg_products`: Product catalog with retail prices, costs, and brand categorization.
  * `stg_users`: Customer profiles, registration metadata, and geographic attributes.

* **Intermediate Layer (Materialized as Views):**
  * `int_order_items_detailed`: Denormalized line-item table joining order items with product cost data to compute item-level gross margins.

* **Marts Layer (Materialized as Tables):**
  * `fct_orders`: Star-schema fact table aggregating order metrics (gross revenue, item counts, product costs, total profit margins, and fulfillment statuses).
  * `dim_users`: Customer dimension enriched with lifetime value (LTV), total order counts, and first/last order acquisition dates.

---

## 🧪 Data Quality & Testing

Schema validations are configured in `models/marts/schema.yml` to ensure data integrity:
* **Primary Key Assertions:** `unique` and `not_null` tests on `order_id` and `user_id`.
* **Referential Integrity:** Validated relationship references between fact and dimension tables.
* **Domain Validation:** `accepted_values` test enforcing permissible order lifecycle statuses (`Complete`, `Cancelled`, `Processing`, `Shipped`, `Returned`).

---

## 🚀 Getting Started

### Prerequisites
* Python 3.10+
* Google Cloud Platform account with BigQuery enabled
* Google Cloud CLI (`gcloud`) authenticated via OAuth or Service Account

### Installation & Run

1. **Activate Virtual Environment:**
   ```powershell
   .\venv\Scripts\Activate.ps1
   cd thelook_analytics
   ```

2. **Verify Connections:**
   ```powershell
   dbt debug
   ```

3. **Build Models & Run Tests:**
   ```powershell
   dbt run
   dbt test
   ```

4. **Launch Documentation & Lineage Graph:**
   ```powershell
   dbt docs generate
   dbt docs serve
   ```