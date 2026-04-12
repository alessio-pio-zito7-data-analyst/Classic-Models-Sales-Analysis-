# Classic Models Sales Analysis

##  Quick Summary

- Revenue grew +33% YoY driven by higher order frequency and customer growth  
- Business is not dependent on large orders → growth is distributed  
- Strong retention (87.84%) and increasing customer engagement  
- All product lines are growing, supported by strong cross-selling dynamics  
- Performance is concentrated among top employees, but lower performers are significantly improving

---

##  Key Insights

- Revenue grew +33% YoY, driven by customers and order frequency  
- Growth is balanced and not dependent on large transactions  
- Small and mid-sized orders are key drivers  
- Strong retention and increasing customer engagement  
- Growth is distributed across products and categories  
- Strong cross-selling relationships between product lines  
- Pareto distribution in employee performance, with improving lower performers  

---

##  Recommendations

- Increase order frequency through incentives (e.g., free shipping thresholds)  

- Strengthen engagement with lower-tier customers to reduce churn  

- Leverage cross-selling through bundles and targeted promotions  

- Support underperforming offices:  
  Tokyo should expand its team, as it currently operates with only one representative despite strong market potential  

- Encourage knowledge sharing between top and lower-performing employees  

- Focus on Ferrari models (top sellers) and expand similar offerings  
  while reducing inventory of underperforming products

--- 

##  Snapshot 
![Dashboard](Tableau/https://github.com/alessio-pio-zito7-data-analyst/Classic-Models-Sales-Analysis-/blob/main/Tableau/Classic%20Cars%20Business%20Analysis.png)

---

## Full Dashboards

Two interactive Tableau dashboards are available to explore the key insights from this analysis:

🔗 [View Classic Cars Business Analysis on Tableau Public](https://public.tableau.com/shared/BY3RWDY4J?:display_count=n&:origin=viz_share_link)


🔗 [View Classic Cars Sales and Offices Performance Overview on Tableau Public](https://public.tableau.com/shared/QS93QD756?:display_count=n&:origin=viz_share_link)

Both tables previews are available in the folder **Tableau**


**Full analysis below**

##  Project Overview

This project analyzes the sales performance of a classic cars company, focusing on revenue drivers, customer behavior, product performance, and office efficiency.

The analysis is based on data from **2003–2004**, simulating a real-world scenario where business performance is evaluated at the beginning of 2005.

---

##  Business Questions

- What are the main drivers of revenue growth?  
- Who are the most valuable customers in terms of revenue and profitability?  
- How are different offices and sales representatives performing?  
- Which product lines and products perform best and worst?  
- Is the business growing, stable, or declining over time?  

---

##  Tools Used

- SQL (MySQL Workbench)  
- Excel (data validation)  
- Tableau (data visualization)  

---

##  Dataset

The dataset consists of 8 tables covering customers, orders, products, payments, employees, and offices.

It includes transactional data (quantity, price), customer information, product categories, and organizational structure, enabling a complete analysis of business performance.

---

##  Analysis Approach

The project follows a structured workflow:

1. Data quality checks  
2. Exploratory analysis using SQL  
3. Validation in Excel  
4. Data visualization in Tableau  

Project folders are organized accordingly, including SQL queries, outputs, and dashboards.

---

##  Data Checks

- No duplicates found across primary keys  
- Strong referential integrity across all tables  

- Missing values were identified only in non-critical (qualitative) fields  
  (e.g., missing sales representatives for a subset of customers)  

- These records are associated with customers who have not placed orders, indicating inactive or non-relevant accounts  

- No missing values were found in key quantitative fields (price, quantity, revenue)  
- No invalid values detected (e.g., negative or zero quantities/prices)  

Overall, the dataset is clean and suitable for analysis.

---

##  Customers Performance

Most customers placed no more than 1–2 orders per year.

Although average order value slightly increased in 2004, even top customers still place relatively small orders at times.  
This highlights a key insight: **small orders play a significant role in overall revenue**.

Both high-value and lower-value customers contribute meaningfully, suggesting that increasing order frequency — even for smaller transactions — can drive growth.

YoY analysis shows:
- Top-tier customers are growing  
- Mid-tier customers are improving  
- Lower-tier customers are declining  

This indicates a potential **early sign of churn** among lower-tier customers.

---

##  Revenue Trends

Revenue follows a clear seasonal pattern, with lower performance at the beginning of the year and a peak toward year-end.

Q1 2004 grew significantly (+97.13% vs 2003), and each subsequent quarter outperformed the previous year.

Overall, revenue increased by **+33.43% YoY**, indicating strong and consistent growth.

---

##  Product Performance (Best Sellers)

Top-selling products are well distributed across product lines, indicating no single category dominance.

The same Ferrari model ranked first in both years, acting as a strong flagship product.

All product lines grew by at least 20%, confirming **broad-based expansion**.  
Total units sold increased by **+33.72%**.

Most products show positive growth, with only a few declining, highlighting a healthy and diversified portfolio.

---

##  Purchased Together 

Product lines are frequently purchased together, forming a highly interconnected ecosystem.

For example, without *Trucks and Buses*, around **52% of Classic Cars sales would not occur**, showing strong interdependencies.

*Classic Cars* acts as a central product line, consistently appearing across combinations.

This highlights strong cross-selling opportunities and the importance of maintaining a diversified catalog.

---

##  Employees & Offices Performance

The top 10 employees generate ~80% of total revenue (Pareto distribution).

Lower-performing employees in 2003 improved significantly in 2004, while some top performers declined.

No customer reassignment was detected, indicating improvements are driven by individual performance.

Paris is the top-performing office, with strong regional expansion.  
5 out of 7 offices show growth above +26%.

Underperforming offices:
- San Francisco (-2.87%) → limited geographic reach  
- Tokyo (-43.21%) → only one sales representative  

---

##  Order Value Distribution

Order values are balanced, with average and median closely aligned.

Median increased (30.4K → 31.6K), while higher percentiles slightly decreased, indicating fewer extreme large orders.

This confirms that **small and mid-sized orders drive revenue**, contributing to a more stable and distributed business model.

---

##  Business KPIs Overview

Revenue grew from **3.22M → 4.30M**, driven by more customers (73 → 87) and orders (108 → 145).

AOV remained stable, while purchase frequency increased (1.48 → 1.67).

Gross margin remained at 40%, and LTV increased (17.6K → 19.8K).

Growth is driven by **higher engagement, not larger transactions**.

---

##  Customer Retention & Growth

Retention is strong at **87.84%**, with a low churn rate of 12.16%.

24 new or reactivated customers contributed to growth  
(due to dataset limitations, they cannot be distinguished).

Growth is supported by:
- higher purchase frequency  
- increasing LTV  
- a broader customer base  
