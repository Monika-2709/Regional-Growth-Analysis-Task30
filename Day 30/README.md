# Regional Growth Analysis – Task 30

## Objective
Compare regional growth rates over time and practice period-over-period comparisons.

## Tools
- SQL
- Excel

## Dataset
A Superstore-style sales dataset was prepared for this task with 1,600 transactions from 2021–2024.
The dataset contains:
`Order_ID, Order_Date, Region, Category, Sub_Category, Segment, Sales, Quantity, Discount, Profit`.

## Deliverables
1. `superstore_regional_growth_data.csv` – raw analysis dataset.
2. `regional_growth_table.csv` – annual regional sales and growth calculations.
3. `Regional_Growth_Analysis.xlsx` – Excel workbook with raw data, growth table, chart data, chart, overall growth, and five insights.
4. `regional_sales_growth_chart.png` – regional sales trend chart.
5. `regional_growth_analysis.sql` – SQL queries for annual sales and YoY growth using `LAG()`.
6. `README.md` – project documentation.

## 5 Key Insights
1. West generated the highest total sales in 2024.
2. East recorded the strongest growth from 2023 to 2024.
3. Central recorded the weakest growth from 2023 to 2024 and should be monitored.
4. South had the highest CAGR over 2021–2024.
5. Percentage growth should be interpreted alongside the underlying sales base because small-base effects can make growth rates look unusually high.

## SQL Logic
The main period-over-period formula is:

Growth % = ((Current Period Sales - Previous Period Sales) / Previous Period Sales) × 100

`LAG()` is used to retrieve the previous year's sales for each region.

## Excel Steps
1. Load the CSV into Excel.
2. Convert `Order_Date` to date format.
3. Create a Year column.
4. Summarize Sales by Region and Year using a PivotTable.
5. Calculate YoY growth with:
   `=(Current Year Sales - Previous Year Sales) / Previous Year Sales`
6. Create a line chart for regional sales trends.
7. Review the five insights in the `Insights` sheet.

## Interview Questions
**Why can growth rate mislead?**  
Because percentage growth depends on the starting base. A small region can show a very high growth percentage even when its absolute sales increase is modest.

**What is a small-base effect?**  
It occurs when a small starting value makes a subsequent increase appear very large in percentage terms.
