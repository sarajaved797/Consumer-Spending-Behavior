
 
# 1.Introduction

This report aims to explore consumer spending behavior with a focus on gender differences, transaction types, and fraud detection. 

By analyzing spending patterns across various demographics and transaction types, the goal is to identify trends that can impact business strategy.

# 2.Objective

The objective of this analysis is to provide insights into spending habits by gender, identify factors influencing fraud, and test various hypotheses about consumer behavior based on  credit card transaction data.

# 3.Data Source

This is a simulated credit card transaction dataset containing legitimate and fraud transactions from the duration 1st Jan 2019 - 31st Dec 2020. 

It covers credit cards of 1000 customers doing transactions with a pool of 800 merchants. It contains details about customer demographics, spending habits, and transaction types.

# 4.Data Cleaning
 
The data was cleaned using SQL to handle missing and duplicate values, incorrect entries, and ensure all transactions were categorized appropriately.

Age, high transaction flag and Transaction Type fields were engineered in SQL.

# 5.Methodology

## Analysis Techniques
I employed SQL queries for data extraction, followed by data exploration using Tableau to create visualizations. 

Various filters were applied to identify spending trends by gender, age, and transaction type. I also analyzed fraud patterns based on transaction amounts and frequency.

# 6.Findings and Insights

## Finding 1: Gender Differences in Spending

Women generally spend more than men, particularly on groceries and household-related items. Women’s total spending often exceeds men’s, especially in the food and healthcare categories.
[View Interactive Tableau Dashboard](Dashboard link coming soon)

## Finding 2: Age and Spending Trends

Women between the ages of 20-40 show a significant spike in spending compared to men, who maintain a more consistent spending pattern across all age groups.
[View Interactive Tableau Dashboard](Dashboard link coming soon)

## Finding 3: Fraud Detection Trends

Fraudulent transactions occur more frequently on weekends, especially in smaller cities. Women are more likely to have fraudulent transactions associated with larger amounts.
[View Interactive Tableau Dashboard](Dashboard link coming soon)

# 7. Hypotheses and Business Implications

# Hypothesis 1: Women’s Spending Priorities Are More Household-Centric Than Men’s

Based on the findings, women tend to spend more on groceries and household essentials, whereas men spend more on self-care and entertainment. 

This suggests that emotional factors and household responsibilities may influence women’s spending habits.

# Hypothesis 2: Fraud Risk Varies by Geography and Timing

The analysis of fraud detection trends indicates that fraudulent transactions are more common in smaller cities on weekends. 

This may indicate that fraud detection systems are less stringent in smaller regions.

# 8. Conclusion

In conclusion, the analysis of spending behavior by gender and age has revealed key differences in how men and women approach spending. 

Additionally, fraud trends show distinct patterns related to geographic location and the time of the week. 

These insights can guide future strategies in consumer engagement and fraud prevention.

# 9.Recommendations

Businesses can use these insights to optimize targeted marketing strategies and enhance fraud detection measures.

Additionally, fraud detection algorithms could be optimized by focusing on regions with higher fraudulent activity.

# 10. Limitations

## Data Limitations: The dataset lacks income and family structure details, limiting deeper spending insights. 

Additionally, the data might not fully account for seasonal variations or external factors influencing spending patterns.

## Geographic Limitations: The analysis is based on transactions from various states, but the dataset may not fully represent global spending habits. 

Fraud patterns could vary greatly in different countries, and additional geographic data would improve the accuracy of fraud detection trends.

## Timeframe Constraints: The analysis was conducted on data from a specific time frame 1st Jan 2019 - 31st Dec 2020 which may not capture long-term trends

or account for recent shifts in consumer behavior due to external factors like economic changes or the COVID-19 pandemic.

## Modeling Limitations: The analysis did not incorporate advanced machine learning techniques to predict future spending behaviors or fraud. 

The current findings are based on historical transaction data, which may not fully represent future trends.

## Subjectivity: The analysis is based on observed trends and may carry inherent biases due to my interpretations of gender roles and spending habits. 

Future research could focus on refining these interpretations and testing them with larger, more diverse datasets.

# 11 Acknowledgments

- I would like to thank OpenAI's GPT for assisting with brainstorming and clarifying concepts throughout this project.
- The dataset used in this analysis is created by Brandon Harris, and can be accessed at https://github.com/namebrandon/Sparkov_Data_Generation
- Special thanks to Kaggle for making this valuable resource available.

________________________________________









