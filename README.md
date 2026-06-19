# **Data_Engineering Projects**

**🏨 Hotel Booking Data Pipeline Using Snowflake**

A modern data warehousing project built on hotel booking transactions, showcasing the Medallion Architecture (Bronze, Silver, Gold layers) for structured ingestion, cleaning, transformation, and analytics.

It includes:

📥 **Data Ingestion:** Raw booking dataset uploaded into Snowflake stage and loaded into bronze tables

🧹 **Data Cleaning (Silver Layer):** Removed duplicates, standardized booking status values, converted date columns, and retained only meaningful records

📊 **Business Analysis (Gold Layer):** SQL aggregations for monthly revenue, bookings, city‑level performance, and KPIs

🔍 **Visuals & Charts:** 
Line charts for revenue per month and bookings per month.
Bar charts for top cities by revenue, bookings by type, and bookings by status.
KPI cards for total revenue, total bookings, and unique cities

❄️ **Dashboard Adaptation:** Since Snowflake’s dashboard feature was disabled, the cleaned dataset was exported and converted into visualizations using Claude AI, ensuring SQL outputs were still transformed into recruiter‑ready business insights

📑 **Business Impact:** Delivered accurate, consistent, and actionable insights on hotel booking trends, customer behavior, and revenue drivers
