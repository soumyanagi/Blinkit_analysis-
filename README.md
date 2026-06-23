# Blinkit_analysis-
Blinkit Sales Analysis using PostgreSQL, SQL & Python
Project Overview
This project presents an end-to-end sales analytics solution using the Blinkit Grocery Dataset. The objective is to uncover meaningful business insights from retail sales data by combining PostgreSQL, SQL analytics, Python data processing, and data visualization techniques.
The project simulates a real-world Data Analyst workflow:
Raw Dataset → PostgreSQL Database → SQL Analysis → Python Visualization → Business Insights
This project was developed as part of my Data Analytics portfolio to demonstrate practical skills in SQL, PostgreSQL, Python, Pandas, Matplotlib, Seaborn, and Business Intelligence.

Dataset Columns
item_identifier
item_weight
item_fat_content
item_visibility
item_type
item_mrp
outlet_identifier
outlet_establishment_year
outlet_size
outlet_location_type
outlet_type
item_outlet_sales

Technology Stack
Layer	Technology
Database	PostgreSQL 18
Query Language	SQL
Programming Language	Python
Data Processing	Pandas
Data Visualization	Matplotlib, Seaborn
Database Connectivity	SQLAlchemy, psycopg2
IDE	Jupyter Notebook
Version Control	Git & GitHub

Project Structure
blinkit-sales-analysis/
├── notebooks/
│ └── blinkit_analysis.ipynb
├── sql/
│ └── analysis_queries.sql
├── charts/
│ ├── 1_revenue_by_outlet_type.png
│ ├── 2_top_categories.png
│ ├── 3_location_tier.png
│ ├── 4_price_bucket.png
│ ├── 5_fat_content.png
│ ├── 6_establishment_trend.png
│ ├── 7_category_contribution.png
│ ├── 8_outlet_size.png
│ ├── 9_outlet_ranking.png
│ └── 10_heatmap.png
├── data/
│ └── blinkit_data.csv
├── business_summary.csv
└── README.md

SQL Concepts Demonstrated
Aggregation Functions
SUM()
AVG()
COUNT()
Conditional Logic
CASE WHEN
Common Table Expressions (CTEs)
WITH clause
Window Functions
RANK()
PARTITION BY
Advanced SQL Techniques
CROSS JOIN
Subqueries
Revenue Contribution Analysis
Sales Benchmarking

Key Business Insights
Certain outlet types contribute significantly more revenue than others.
Product categories such as Fruits & Vegetables and Snack Foods generate a major share of sales.
Outlet location plays a critical role in sales performance.
Medium-sized outlets show strong operational efficiency.
Premium-priced products contribute substantially to overall revenue.
Long-established outlets tend to generate higher sales compared to newer outlets.
Sales performance varies significantly across outlet categories and locations.

Visualizations
The project contains:
Revenue by Outlet Type
Top Product Categories
Location Tier Analysis
Price Bucket Analysis
Fat Content Analysis
Outlet Size Performance
Revenue Contribution Analysis
Outlet Ranking Dashboard
Correlation Heatmap

Learning Outcomes
Through this project, I strengthened my skills in:
PostgreSQL Database Management
SQL Query Optimization
Data Cleaning and Transformation
Exploratory Data Analysis (EDA)
Business Intelligence Reporting
Data Visualization
Data Storytelling

Future Enhancements
Interactive Power BI Dashboard
Sales Forecasting using Machine Learning
Customer Segmentation Analysis
Inventory Optimization Models
Product Recommendation System

Author
Soumya Nagi
Skills:
SQL | PostgreSQL | Python | Pandas | NumPy | Matplotlib | Seaborn | Power BI | Machine Learning
Aspiring Data Analyst | Data Science Enthusiast

