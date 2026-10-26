# Title: 
Loan Risk Analysis

# Business Problem
A financial company wants to know why the rate of default is about 25% of the total loan issued,
The VP of risk wants to understand what is driving this rate as the targeted default rate is 12%.

# Process and Business questions:
 Import and Explore
Load both CSVs.

Check for nulls, data types, and basic stats.

Join the two tables on borrower_id.

2. Segment Analysis:
Create credit score buckets and calculate default rates for each.

Do the same for DTI ranges, employment status, and loan purpose.

3. Correlation Analysis:
Identify which numeric variables (credit score, DTI, income, loan amount, interest rate) have the strongest correlation with defaults.

4. Visualization:
Build charts showing default rate by credit score range, a scatter plot of DTI vs. default status, and a bar chart comparing loan purposes.

5. Recommendations:
Write a brief summary recommending the top 3 risk factors and suggest specific thresholds (e.g., minimum credit score, maximum DTI) for the underwriting team.

# Data
Data source is a financial data from a financial institution, It contains two datasets
which are loan_application and borrower's profile which are both in csv.
The borrower profile data has 11 fields and 500 columns while loan applications data
has about 12 fields and 601 rows.

# Approach
 - I used pandas which is one of the python libraries used for processing data to carry out exploratory analysis,
   this helps me to determine the numeric fields and string fields and also to understand the data as well as
   grouping some of the fields like credit_score, dti_ratio, age_group and interest_rate for easily analysis.
- Secondly I automate data pipeline from my pandas to sql server to answer some business questions in sql
- lastly I used excel for visualization which is also automated as well.

# Key Findings
- Customers with credit score below 600 drives about 40% of the total default rate
- Analysis shows that customers with debt to income ratio of 41 and above makes up about 65% of the default rate which is extremely high
- Customers with full time job contributed to about 50% of the default rate
- Age is not a major factor in determining the default rate as there is no unnecessary gap in the default rate when it comes to age
- The interest rate played a major part as customers with 8% to 14% interest rate contributed to about 68% of the total default rate.

# Recommendations
- The fiancial company should increase the credit score for accessing loan to about 600 and above, this will reduce the default rate significantly
  and this might meet their expected 12% default rate goal
- It is also important for the VP in risk to take a deeper look at debt to income ratio of customers as customers with debt to income ratio from 41 and above played
  a major role in contributing to the default rate, ensure customer with debt to income ratio is below 50 which will also have a major shift in further reducing the   default rate.

# Visuals
<img width="1845" height="993" alt="loan_purpose" src="https://github.com/user-attachments/assets/7e30952e-502d-4110-8d32-b579ff82163e" />
<img width="1653" height="993" alt="interest rate" src="https://github.com/user-attachments/assets/b388b5f5-7175-4e8d-8fe0-8b207c03bdec" />
<img width="1993" height="993" alt="employment_status" src="https://github.com/user-attachments/assets/5773d65c-58cf-4f25-805d-5bf0af8ead2b" />
<img width="1653" height="993" alt="Dti ratio by default rate" src="https://github.com/user-attachments/assets/99725aef-78ca-4027-a230-66bc4c9e6c60" />
<img width="1653" height="993" alt="Default_Rate By Credit Band" src="https://github.com/user-attachments/assets/70817bdc-51ee-43b1-84ca-455654e811d8" />
<img width="1653" height="993" alt="age" src="https://github.com/user-attachments/assets/7df98347-178d-4a87-bfa8-77abca817951" />



# Tech Stack
 - pandas in python
 - sql sql server
 - Excel
 - 



