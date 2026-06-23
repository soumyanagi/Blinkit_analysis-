SELECT COUNT(*) AS total_records
FROM blinkit_data;

--Unique Item Types
SELECT DISTINCT Item_Type
FROM blinkit_data
ORDER BY Item_Type;

--Unique Outlet Types
SELECT DISTINCT Outlet_Type
FROM blinkit_data;

--2. SALES PERFORMANCE ANALYSIS
--Total and Average Sales by Outlet Type
SELECT
    Outlet_Type,
    COUNT(*) AS total_items,
    ROUND(SUM(Item_Outlet_Sales)::numeric, 2) AS total_sales,
    ROUND(AVG(Item_Outlet_Sales)::numeric, 2) AS avg_sales
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY total_sales DESC;

--Top 10 Best Selling Item Types
SELECT
    Item_Type,
    COUNT(*) AS item_count,
    ROUND(SUM(Item_Outlet_Sales)::numeric, 2) AS total_sales,
    ROUND(AVG(Item_Outlet_Sales)::numeric, 2) AS avg_sales
FROM blinkit_data
GROUP BY Item_Type
ORDER BY total_sales DESC
LIMIT 10;

--Sales by Outlet Location Tier
SELECT
    Outlet_Location_Type,
    COUNT(*) AS total_items,
    ROUND(SUM(Item_Outlet_Sales)::numeric, 2) AS total_sales,
    ROUND(AVG(Item_Outlet_Sales)::numeric, 2) AS avg_sales
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY total_sales DESC;

--Overall Sales KPI
SELECT
    ROUND(SUM(Item_Outlet_Sales)::numeric, 2) AS total_sales,
    ROUND(AVG(Item_Outlet_Sales)::numeric, 2) AS average_sales,
    COUNT(*) AS total_items
FROM blinkit_data;

--3. OUTLET PERFORMANCE ANALYSIS
--Revenue by Outlet Size
SELECT
    Outlet_Size,
    COUNT(*) AS total_items,
    ROUND(SUM(Item_Outlet_Sales)::numeric, 2) AS total_sales,
    ROUND(AVG(Item_Outlet_Sales)::numeric, 2) AS avg_sales
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY total_sales DESC;

--Best Performing Outlets Ranked by Sales
SELECT
    Outlet_Identifier,
    Outlet_Type,
    Outlet_Location_Type,
    Outlet_Size,
    ROUND(SUM(Item_Outlet_Sales)::numeric, 2) AS total_sales,
    COUNT(*) AS total_products
FROM blinkit_data
GROUP BY
    Outlet_Identifier,
    Outlet_Type,
    Outlet_Location_Type,
    Outlet_Size
ORDER BY total_sales DESC;

--Outlet Establishment Year Performance
SELECT
    Outlet_Establishment_Year,
    COUNT(DISTINCT Outlet_Identifier) AS num_outlets,
    ROUND(SUM(Item_Outlet_Sales)::numeric, 2) AS total_sales,
    ROUND(AVG(Item_Outlet_Sales)::numeric, 2) AS avg_sales
FROM blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year;

--Average MRP by Item Type
SELECT
    Item_Type,
    ROUND(AVG(Item_MRP)::numeric, 2) AS avg_mrp,
    ROUND(MIN(Item_MRP)::numeric, 2) AS min_mrp,
    ROUND(MAX(Item_MRP)::numeric, 2) AS max_mrp,
    ROUND(AVG(Item_Outlet_Sales)::numeric, 2) AS avg_sales
FROM blinkit_data
GROUP BY Item_Type
ORDER BY avg_mrp DESC;

--Fat Content Distribution and Sales Impact
SELECT
    Item_Fat_Content,
    COUNT(*) AS item_count,
    ROUND(AVG(Item_Outlet_Sales)::numeric, 2) AS avg_sales,
    ROUND(SUM(Item_Outlet_Sales)::numeric, 2) AS total_sales
FROM blinkit_data
GROUP BY Item_Fat_Content
ORDER BY total_sales DESC;

--Price Range Buckets vs Sales Performance
SELECT
    CASE
        WHEN Item_MRP < 50 THEN 'Budget (<50)'
        WHEN Item_MRP BETWEEN 50 AND 150 THEN 'Mid-Range (50-150)'
        WHEN Item_MRP BETWEEN 150 AND 250 THEN 'Premium (150-250)'
        ELSE 'Luxury (>250)'
    END AS price_bucket,

    COUNT(*) AS item_count,

    ROUND(AVG(Item_Outlet_Sales)::numeric, 2) AS avg_sales,

    ROUND(SUM(Item_Outlet_Sales)::numeric, 2) AS total_sales

FROM blinkit_data

GROUP BY price_bucket

ORDER BY total_sales DESC;

--5. CUSTOMER RATING ANALYSIS
--Average Sales by Outlet Type
SELECT
    Outlet_Type,
    ROUND(AVG(Item_Outlet_Sales)::numeric, 2) AS avg_sales,
    COUNT(*) AS total_products
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY avg_sales DESC;

--Sales Distribution Analysis
SELECT
    CASE
        WHEN Item_Outlet_Sales < 1000 THEN 'Low Sales'
        WHEN Item_Outlet_Sales BETWEEN 1000 AND 3000 THEN 'Medium Sales'
        ELSE 'High Sales'
    END AS sales_category,
    COUNT(*) AS product_count
FROM blinkit_data
GROUP BY sales_category
ORDER BY product_count DESC;

--High Performing vs Low Performing Outlets
SELECT
    Outlet_Identifier,
    Outlet_Type,

    ROUND(AVG(Item_Outlet_Sales)::numeric, 2) AS avg_sales,

    ROUND(SUM(Item_Outlet_Sales)::numeric, 2) AS total_sales,

    CASE
        WHEN AVG(Item_Outlet_Sales) >= 3000 THEN 'High Performing'
        WHEN AVG(Item_Outlet_Sales) BETWEEN 1500 AND 3000 THEN 'Average'
        ELSE 'Needs Improvement'
    END AS performance_category

FROM blinkit_data

GROUP BY Outlet_Identifier, Outlet_Type

ORDER BY avg_sales DESC;

--6. ADVANCED ANALYSIS - WINDOW FUNCTIONS & CTEs      
--Running Total of Sales by Outlet Type
SELECT
    Outlet_Type,
    Item_Type,

    ROUND(SUM(Item_Outlet_Sales)::numeric, 2) AS sales,

    ROUND(
        SUM(SUM(Item_Outlet_Sales))
        OVER (
            PARTITION BY Outlet_Type
            ORDER BY Item_Type
        )::numeric,
        2
    ) AS running_total

FROM blinkit_data

GROUP BY Outlet_Type, Item_Type

ORDER BY Outlet_Type, Item_Type;

--Rank Outlets Within Each Location Tier
SELECT
    Outlet_Identifier,
    Outlet_Location_Type,
    Outlet_Type,

    ROUND(SUM(Item_Outlet_Sales)::numeric, 2) AS total_sales,

    RANK() OVER (
        PARTITION BY Outlet_Location_Type
        ORDER BY SUM(Item_Outlet_Sales) DESC
    ) AS sales_rank

FROM blinkit_data

GROUP BY
    Outlet_Identifier,
    Outlet_Location_Type,
    Outlet_Type

ORDER BY
    Outlet_Location_Type,
    sales_rank;

--CTE: Outlets Performing Above Average Sales
WITH outlet_sales AS
(
    SELECT
        Outlet_Identifier,
        Outlet_Type,
        Outlet_Location_Type,

        ROUND(SUM(Item_Outlet_Sales)::numeric, 2) AS total_sales,

        ROUND(AVG(Item_Outlet_Sales)::numeric, 2) AS avg_sales

    FROM blinkit_data

    GROUP BY
        Outlet_Identifier,
        Outlet_Type,
        Outlet_Location_Type
),

overall_avg AS
(
    SELECT
        ROUND(AVG(Item_Outlet_Sales)::numeric, 2) AS overall_avg_sales
    FROM blinkit_data
)

SELECT
    o.Outlet_Identifier,
    o.Outlet_Type,
    o.Outlet_Location_Type,

    o.total_sales,

    oa.overall_avg_sales,

    CASE
        WHEN o.avg_sales > oa.overall_avg_sales
        THEN 'Above Average'
        ELSE 'Below Average'
    END AS performance

FROM outlet_sales o

CROSS JOIN overall_avg oa

ORDER BY o.total_sales DESC;

--CTE: Revenue Contribution by Product Category
WITH category_sales AS
(
    SELECT
        Item_Type,

        ROUND(
            SUM(Item_Outlet_Sales)::numeric,
            2
        ) AS category_total

    FROM blinkit_data

    GROUP BY Item_Type
),

total AS
(
    SELECT
        ROUND(
            SUM(Item_Outlet_Sales)::numeric,
            2
        ) AS grand_total

    FROM blinkit_data
)

SELECT
    cs.Item_Type,

    cs.category_total,

    t.grand_total,

    ROUND(
        (cs.category_total / t.grand_total) * 100,
        2
    ) AS revenue_contribution_pct

FROM category_sales cs

CROSS JOIN total t

ORDER BY revenue_contribution_pct DESC;
