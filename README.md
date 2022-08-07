# E-Commerce-Data-Analysis-and-Visulization---Olist

## About Project 
Performed company, customer, product, and metrics analysis and visualization for Brazilian E-Commerce company (Olist)

Conducted ETL using SQL, including extracting, cleaning, and analyzing data in MySQL.

Developed a Tableau dashboard to perform analysis, producing quantitative and intuitive visualizations in Tableau to draw valuable insights and further provide business solutions.


## Data Source: 
[Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

## Technologies Used:
1. MySQL
2. Tableau
3. Jupyter Notebook

## Project Planning 

#### 1. Motivation
To unlock its early-stage sales and operation since its inception in 2015
To gain in-depth understanding of e-commerce database, business, metrics, and analysis methods
#### 2. Stakeholders
Strategy manager
Sales department
Customer service team
I.T Team
#### 3. Output
An informative and intuitive dashboard that delivers valuable insights for decision makers.


## Setup Process
### 1. Install all technologies 
### 2. Construct Database in MySQL
(See Build_databse.sql)

## Detailed Approaches
### 1. Data Prepossessing & Cleaning 

* Data Deduplication
* Missing Value 
* Abnormality Check
Compared with 2017 and 2018, the data at the end of 2016 is missing or abnormally small

### 2. Data Analysis Using MySQL 
*  Developed a quick overview and trend analysis of Olist’s sales, transactions, GMV, and average order value (AOV) from 2017.01 to 2018.08. (GMV_&_Sales_Insight.sql)
*  Performed general customer analysis such as spending, growth, and retention, while deep diving into core customers’ behavior and preference.  (Customer_Analysis.sql)
*  Scored recency, frequency, and monetary value for each customer, and implemented RFM customer segmentation (RFM_Segmentation.sql)
*  Developed a product analysis such as purchase delivery process, the most popular product category and the transaction trend. (Product_Analysis.sql)

### 3. Visualize Results USING Tableau
Tableau Dashboard with key insight
#### General 
<img width="600" alt="Screen Shot 2022-08-07 at 14 17 12" src="https://user-images.githubusercontent.com/48861299/183311338-90bde4cd-ed3f-4093-8998-2ce58f2eb8fa.png">

* State “SP” is the most important contributor to GMV ( ~37%)
* GMV surges in 2017.11 (holiday effect)

#### Customer
<img width="600" alt="Screen Shot 2022-08-07 at 14 15 48" src="https://user-images.githubusercontent.com/48861299/183311355-7581e057-2ad3-43cc-9651-1e0bf28e62da.png">

* Olist was very popular in the southeast of Brazil, especially the State ‘SP’. 
* Since Olist is in the early stage, they have high growth and high churn.

<img width="600" alt="Screen Shot 2022-08-07 at 14 16 00" src="https://user-images.githubusercontent.com/48861299/183311444-31e68c38-892d-4a66-90b4-82a07790ac96.png">

* Most of the core customers prefer to place orders during weekdays, especially Monday and Wednesday. During weekends, on the contrary, seldom do core customers make transactions. 
* A large percentage of customers placed only one order, about 3000 customers placed up to 4 orders. The maximum orders placed per customer is 17. 
73.14% of customers made their transactions using credit cards, only 1.21% of customers purchased using debit card.
* The top 2 spending distributions of core customers are spendings between $100 to $500 (49.13%), and spendings below $100 (46.21%).

<img width="600" alt="Screen Shot 2022-08-07 at 14 16 14" src="https://user-images.githubusercontent.com/48861299/183311412-d6aa42c3-c2b5-44b1-8651-ee6799753bcc.png">
RFM customer segmentation

#### Product
<img width="600" alt="Screen Shot 2022-08-07 at 14 16 26" src="https://user-images.githubusercontent.com/48861299/183311435-5ade40ec-b437-4a37-b4d2-d8ac14e3a036.png">

* Bes_bath_table is the top 1 sales category with most “recomendo” in comments
* On average, after a customer placed an order, they need around 24 days to receive the product.

<img width="600" alt="Screen Shot 2022-08-07 at 14 16 48" src="https://user-images.githubusercontent.com/48861299/183311426-c308ad8b-b01e-43f2-94ed-261fcc67ca40.png">

* Health beauty has top 5 sales and  a growth trend, which shows its potential
* Sports_leisure has top sales, but shows a decreasing trend, and it has the most canceled orders around all product categories, which is a warning sign

## Conclusion and Recommendations
* In 2017-2018, Olist showed growth but serious geological inequality in its GMV, so that it could boost growth and attract more customers in other areas (through holiday promotions or campaigns) while keeping their popularity in the southeast.
* With the high growth and high churn of customers, Olist should cultivate more loyal customers through deep diving into core customer’s behavior and preference (Ex. such as new product reminder and promotion in weekday, credit card encouragement, loyal program, personalized ads/emails, etc)
* With over 112k products, Olist should focus more on potential product categories (ex. Bed_bath_table, health_beauty), and figuring out why some categories (ex. Sport leisure) are not or no longer popular.
* In terms of satisfaction, Olist could improve their distribution, delivery, and after-sales questionnaire and service, in order to give customers a better shopping experience, and then shop more frequently and boost revenue.


