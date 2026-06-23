#!/usr/bin/env python
# coding: utf-8

# In[1]:


get_ipython().system('pip install pandas matplotlib seaborn sqlalchemy psycopg2-binary')


# In[7]:


import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sqlalchemy import create_engine,text

engine = create_engine(
    "postgresql+psycopg2://postgres:Dolly%40165@localhost/blinkit_db"
)


print("Connected Successfully")


# In[13]:


from sqlalchemy import create_engine

engine = create_engine(
    "postgresql+psycopg2://postgres:Dolly%40165@localhost:5433/blinkit_db"
)

conn = engine.connect()

print("Connection Successful!")
conn.close()


# In[14]:


import pandas as pd

query = """
SELECT *
FROM blinkit_data
LIMIT 5;
"""

df = pd.read_sql(query, engine)
print(df.head())


# 

# In[15]:


query = """
SELECT *
FROM blinkit_data
LIMIT 5;
"""

df = pd.read_sql(query, engine)
print(df.columns.tolist())


# In[17]:


plt.rcParams['figure.figsize'] = (10, 5)
sns.set_theme(style="whitegrid")
BLINKIT_GREEN  = "#0C831F"
BLINKIT_YELLOW = "#F9C62B"

# Revenue by Outlet Type
# In[18]:


query1 = """
SELECT
    outlet_type,
    ROUND(SUM(item_outlet_sales)::numeric,2) AS total_sales,
    ROUND(AVG(item_outlet_sales)::numeric,2) AS avg_sales
FROM blinkit_data
GROUP BY outlet_type
ORDER BY total_sales DESC;
"""

df1 = pd.read_sql(query1, engine)
print(df1)


# In[32]:


plt.figure(figsize=(10,5))

sns.barplot(
    data=df1,
    x='total_sales',
    y='outlet_type'
)

plt.title("Revenue by Outlet Type")
plt.show()

# Top 10 Product Categories
# In[19]:


query2 = """
SELECT
    item_type,
    ROUND(SUM(item_outlet_sales)::numeric,2) AS total_sales,
    COUNT(*) AS item_count
FROM blinkit_data
GROUP BY item_type
ORDER BY total_sales DESC
LIMIT 10;
"""

df2 = pd.read_sql(query2, engine)
print(df2)


# In[34]:


plt.figure(figsize=(10,6))
sns.barplot(data=df2,
            x='total_sales',
            y='item_type')

plt.title("Top 10 Product Categories")

plt.tight_layout()
plt.savefig("charts/2_top_categories.png")
plt.show()

# Sales by Location Tier
# In[20]:


query3 = """
SELECT
    outlet_location_type,
    ROUND(SUM(item_outlet_sales)::numeric,2) AS total_sales,
    COUNT(*) AS item_count
FROM blinkit_data
GROUP BY outlet_location_type
ORDER BY total_sales DESC;
"""

df3 = pd.read_sql(query3, engine)
print(df3)


# In[35]:


plt.figure(figsize=(7,7))

plt.pie(
    df3['total_sales'],
    labels=df3['outlet_location_type'],
    autopct='%1.1f%%'
)

plt.title("Revenue Share by Location Tier")

plt.savefig("charts/3_location_tier.png")
plt.show()

# Price Bucket Analysis
# In[21]:


query4 = """
SELECT
CASE
    WHEN item_mrp < 50 THEN 'Budget'
    WHEN item_mrp BETWEEN 50 AND 150 THEN 'Mid Range'
    WHEN item_mrp BETWEEN 150 AND 250 THEN 'Premium'
    ELSE 'Luxury'
END AS price_bucket,

COUNT(*) AS item_count,

ROUND(AVG(item_outlet_sales)::numeric,2) AS avg_sales,

ROUND(SUM(item_outlet_sales)::numeric,2) AS total_sales

FROM blinkit_data

GROUP BY price_bucket
ORDER BY total_sales DESC;
"""

df4 = pd.read_sql(query4, engine)
print(df4)


# In[36]:


plt.figure(figsize=(8,5))

sns.barplot(
    data=df4,
    x='price_bucket',
    y='total_sales'
)

plt.title("Price Bucket Revenue")

plt.savefig("charts/4_price_bucket.png")
plt.show()

# Fat Content Analysis
# In[22]:


query5 = """
SELECT
    item_fat_content,
    COUNT(*) AS item_count,
    ROUND(AVG(item_outlet_sales)::numeric,2) AS avg_sales,
    ROUND(SUM(item_outlet_sales)::numeric,2) AS total_sales
FROM blinkit_data
GROUP BY item_fat_content
ORDER BY total_sales DESC;
"""

df5 = pd.read_sql(query5, engine)
print(df5)


# In[37]:


plt.figure(figsize=(8,5))

sns.barplot(
    data=df5,
    x='item_fat_content',
    y='avg_sales'
)

plt.title("Average Sales by Fat Content")

plt.savefig("charts/5_fat_content.png")
plt.show()

# Outlet Establishment Trend
# In[23]:


query6 = """
SELECT
    outlet_establishment_year,
    ROUND(SUM(item_outlet_sales)::numeric,2) AS total_sales,
    COUNT(DISTINCT outlet_identifier) AS num_outlets
FROM blinkit_data
GROUP BY outlet_establishment_year
ORDER BY outlet_establishment_year;
"""

df6 = pd.read_sql(query6, engine)
print(df6)


# In[38]:


plt.figure(figsize=(12,5))

plt.plot(
    df6['outlet_establishment_year'],
    df6['total_sales'],
    marker='o'
)

plt.title("Sales Trend by Outlet Establishment Year")

plt.xlabel("Year")
plt.ylabel("Sales")

plt.savefig("charts/6_establishment_trend.png")
plt.show()

# Category Revenue Contribution
# In[40]:


query7 = """
WITH category_sales AS
(
SELECT
item_type,
SUM(item_outlet_sales) sales
FROM blinkit_data
GROUP BY item_type
)

SELECT *
FROM category_sales
ORDER BY sales DESC
LIMIT 8;
"""

df7 = pd.read_sql(query7, engine)

print(df7)

plt.figure(figsize=(10,5))

sns.barplot(
    data=df7,
    x='sales',
    y='item_type'
)

plt.title("Top Category Revenue Contribution")

plt.savefig("charts/7_category_contribution.png")
plt.show()

# Outlet Size Performance
# In[25]:


query8 = """
SELECT
    outlet_size,
    ROUND(SUM(item_outlet_sales)::numeric,2) AS total_sales,
    COUNT(*) AS item_count
FROM blinkit_data
GROUP BY outlet_size
ORDER BY total_sales DESC;
"""

df8 = pd.read_sql(query8, engine)
print(df8)


# In[41]:


plt.figure(figsize=(8,5))

sns.barplot(
    data=df8,
    x='outlet_size',
    y='total_sales'
)

plt.title("Outlet Size Performance")

plt.savefig("charts/8_outlet_size.png")
plt.show()

# Outlet Ranking
# In[43]:


query9 = """
SELECT

outlet_identifier,
outlet_location_type,

ROUND(SUM(item_outlet_sales)::numeric,2) AS total_sales,

RANK() OVER(
PARTITION BY outlet_location_type
ORDER BY SUM(item_outlet_sales) DESC
) AS sales_rank

FROM blinkit_data

GROUP BY
outlet_identifier,
outlet_location_type

ORDER BY sales_rank;
"""

df9 = pd.read_sql(query9, engine)

print(df9.head(15))

top10 = df9.head(10)

plt.figure(figsize=(10,5))

sns.barplot(
    data=top10,
    x='total_sales',
    y='outlet_identifier'
)

plt.title("Top Ranked Outlets")

plt.savefig("charts/9_outlet_ranking.png")
plt.show()

# Correlation Heatmap
# In[44]:


query10 = """
SELECT
item_weight,
item_visibility,
item_mrp,
item_outlet_sales
FROM blinkit_data;
"""

df10 = pd.read_sql(query10, engine)

corr = df10.corr()

plt.figure(figsize=(8,6))

sns.heatmap(
    corr,
    annot=True,
    cmap='YlGnBu'
)

plt.title("Correlation Heatmap")

plt.savefig("charts/10_heatmap.png")

plt.show()


# In[28]:


import os

os.makedirs("charts", exist_ok=True)


# In[ ]:




