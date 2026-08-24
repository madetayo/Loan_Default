USE LoanDB;

SELECT *
FROM dbo.borrower_profiles;

SELECT *
FROM dbo.loan_applications;

--Business Questions
-- what is the overall default rate?

SELECT
  loan_status,
  COUNT(*) OVER() AS Total_Count_of_Loan_Status,
  COUNT(*) OVER(PARTITION BY loan_status ORDER BY loan_status) AS Total_Count_By_Loan_Status,
  ROUND(CAST( COUNT(*) OVER(PARTITION BY loan_status ORDER BY loan_status) AS DECIMAL(10,2)) / CAST(COUNT(*) OVER() AS DECIMAL(10,2)) * CAST(100 AS DECIMAL(10,2)),0) AS loan_status_rate
  FROM dbo.loan_applications;

  -- It shows out of every 100 loan Application, 24 borrowers have defaulted, the rate is 24% default rate

  -- How does it break down by credit score range (e.g 520-599, 600-649, 650-699, 700-759, 750+)

  WITH CTE_Default_Rate AS 
  ( SELECT 
  la.loan_id,
  la.loan_purpose,
  la.loan_status,
  bp.credit_score,
  bp.borrower_id,
  bp.employment_status
  FROM dbo.loan_applications la
  LEFT JOIN dbo.borrower_profiles bp
  ON la.borrower_id = bp.borrower_id
  WHERE la.loan_status = 'Default'
  )
  SELECT
  (SELECT
  COUNT(*) 
  FROM CTE_Default_Rate
  WHERE credit_score BETWEEN 520 AND 599) AS bucket1_529_599,
  (SELECT
  COUNT(*) 
  FROM CTE_Default_Rate
  WHERE credit_score BETWEEN 600 AND 649) AS bucket2_600_649,
  (SELECT
  COUNT(*) 
  FROM CTE_Default_Rate
  WHERE credit_score BETWEEN 650 AND 699) AS bucket3_650_699 ,
  (SELECT
  COUNT(*)
  FROM CTE_Default_Rate
  WHERE credit_score BETWEEN 700 AND 759) AS bucket4_700_759,
  (SELECT
  COUNT(*) 
  FROM CTE_Default_Rate
  WHERE credit_score BETWEEN 751 AND 1000) AS bucket5_751_1000


  -- Solution 2:
  SELECT
		COUNT(CASE WHEN credit_score BETWEEN 520 AND 599 THEN 1 END) AS bucket1_520_599,
		COUNT(CASE WHEN credit_score BETWEEN 600 AND 649 THEN 1 END) AS bucket1_600_649,
		COUNT(CASE WHEN credit_score BETWEEN 650 AND 699 THEN 1 END) AS bucket1_650_699,
		COUNT(CASE WHEN credit_score BETWEEN 700 AND 750 THEN 1 END) AS bucket1_700_750,
		COUNT(CASE WHEN credit_score BETWEEN 751 AND 1000 THEN 1 END) AS bucket5_751_1000
  FROM (
		SELECT
		la.loan_id,
        la.loan_purpose,
        la.loan_status,
        bp.credit_score,
        bp.borrower_id,
        bp.employment_status
    FROM dbo.loan_applications AS la
    LEFT JOIN dbo.borrower_profiles AS bp
        ON la.borrower_id = bp.borrower_id
    WHERE la.loan_status = 'Default'
) AS Default_Rate;

  

  -- QUESTION 2: Is there a relationship between a borrower’s debt-to-income (DTI) ratio and the likelihood of defaulting?
  -- What DTI threshold would you recommend as a cutoff for loan approval?
  
  
  SELECT 
	dti_ratio,
	loan_status
	FROM dbo.loan_applications
	WHERE loan_status = 'Default' AND dti_ratio BETWEEN 0 AND 40

-- Yes, there is a correlation between the borrower's dti ratio and the likehood to default, from the total of 146 
-- that defaulted, about 115 borrowers with dti ratio between 41 and above while 31 borrowers with Dti ratio between 0 and 40,
-- this shows that dti has a significant impact to the likelihood of defaulting. 
-- I would recommend that the dti ratio cutoff should be 35 this will further reduce the rate of default by borrowers

-- Which loan purposes have the highest default rates, and does the average loan amount differ
-- significantly between defaulted and non defaulted loans

SELECT 
	loan_purpose,
	COUNT(*) Total_Default_By_Loan_Purpose,
	AVG(loan_amount) Avg_Loan_Amount
FROM dbo.loan_applications
WHERE loan_status = 'Default'
GROUP BY loan_purpose 
ORDER BY COUNT(*) DESC;
-- The Home Improvement has the highest Default rate followed by Wedding and Auto Loan
-- Recommendation: The financial institution should placed a stricter measure on Home Improvement purpose, Wedding and Auto loan
-- This is to ensure that there is likelihood paying off their loan.

-- How do employment status and years employed affect default risk?
SELECT
employment_status,
COUNT(*) Total_Default_By_Employment_Status,
AVG(years_employed) Avg_years_employed
FROM 
(
SELECT 
pb.employment_status,
pb.years_employed,
la.loan_status
FROM dbo.borrower_profiles pb
LEFT JOIN dbo.loan_applications la
ON pb.borrower_id = la.borrower_id
WHERE loan_status = 'Default'
) AS defaulted_borrower
GROUP BY employment_status
ORDER BY COUNT(*) DESC;

-- Full Time employment status has the highest number of default_rate which is about 73
-- while the average years employed is about 11years which does not actually have a significant effect on default rate
	
-- Are Borrowers with less than 2years of employment significantly more likely to default
SELECT
employment_status,
COUNT(*) AS Total_Count_For_Employee_Years_Less_Than_2_Years
FROM
(SELECT 
pb.employment_status,
pb.years_employed,
la.loan_status
FROM dbo.borrower_profiles pb
LEFT JOIN dbo.loan_applications la
ON pb.borrower_id = la.borrower_id
WHERE loan_status = 'Default') AS defaulted_borrower
WHERE years_employed < 2
GROUP BY employment_status;



   

  

  