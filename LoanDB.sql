USE LoanDB;

SELECT *
FROM dbo.borrower_profiles;

SELECT *
FROM dbo.loan_applications;

-- What is the overall default rate
SELECT
	SUM(defaulted) AS total_default,
	COUNT(*) AS total_loan_application,
	ROUND(SUM(defaulted) * 1.0 / COUNT(*) * 100, 2) AS total_default_rate
FROM dbo.loan_applications;

-- how does it break down by credit score range (e.g., 520–599, 600–649, 650–699, 700–749, 750+)? 
-- Which credit score bucket has the highest default rate

SELECT
	COUNT(*) AS total_default,
	ROUND(COUNT(CASE WHEN credit_band = '520-599' THEN 1 END) * 1.0 /COUNT(*) * 100, 2) AS '520-599',
	ROUND(COUNT(CASE WHEN credit_band = '600-649' THEN 1 END) * 1.0 /COUNT(*) * 100, 2) AS '600-649',
	ROUND(COUNT(CASE WHEN credit_band = '650-699' THEN 1 END) * 1.0 /COUNT(*) * 100, 2) AS '650-699',
	ROUND(COUNT(CASE WHEN credit_band = '700-749' THEN 1 END) * 1.0 /COUNT(*) * 100, 2) AS '700-749',
	ROUND(COUNT(CASE WHEN credit_band = '750+' THEN 1 END) * 1.0 /COUNT(*) * 100, 2) AS '750+'
FROM loan_applications la
LEFT JOIN borrower_profiles bp
ON la.borrower_id = bp.borrower_id
WHERE la.loan_status = 'Default'



-- is there a relationship between a borrower’s debt-to-income (DTI) ratio and the likelihood of defaulting?
-- What DTI threshold would you recommend as a cutoff for loan approval?
SELECT
	COUNT(*) AS total_default,
	ROUND(COUNT(CASE WHEN dti_band = '0-20.99' THEN 1 END) * 1.0 /COUNT(*) * 100, 2) AS '0-20.99',
	ROUND(COUNT(CASE WHEN dti_band = '21-40.99' THEN 1 END) * 1.0 /COUNT(*) * 100, 2) AS '21-40.99',
	ROUND(COUNT(CASE WHEN dti_band = '41-60.99' THEN 1 END) * 1.0 /COUNT(*) * 100, 2) AS '41-60.99',
	ROUND(COUNT(CASE WHEN dti_band = '61-80.99' THEN 1 END) * 1.0 /COUNT(*) * 100, 2) AS '61-80.99',
	ROUND(COUNT(CASE WHEN dti_band = '81+' THEN 1 END) * 1.0 /COUNT(*) * 100, 2) AS '81+'
FROM loan_applications la
WHERE la.loan_status = 'Default'


-- Yes, there is a correlation between the borrower's dti ratio and the likehood to default, from the total of 146 
-- that defaulted, about 115 borrowers with dti ratio between 41 and above while 31 borrowers with Dti ratio between 0 and 40,
-- this shows that dti has a significant impact to the likelihood of defaulting. 
-- I would recommend that the dti ratio cutoff should be 35 this will further reduce the rate of default by borrowers

-- Which loan purposes have the highest default rates, and does the average loan amount differ
-- significantly between defaulted and non defaulted loans
SELECT 
	  loan_purpose,
	  COUNT(*) OVER() AS total_default,
	  ROUND(COUNT(*) OVER(PARTITION BY loan_purpose) * 1.0 / COUNT(*) OVER(), 2) * 100.0 AS default_rate
FROM dbo.loan_applications
WHERE loan_status = 'Default'


-- The Home Improvement has the highest Default rate followed by Wedding and Auto Loan
-- Recommendation: The financial institution should placed a stricter measure on Home Improvement purpose, Wedding and Auto loan
-- This is to ensure that there is likelihood paying off their loan.

-- How do employment status and years employed affect default risk?
SELECT
employment_status,
COUNT(*) OVER() AS Total_Default_By_Employment_Status,
ROUND(COUNT(*) OVER(PARTITION BY employment_status) * 1.0 / COUNT(*) OVER(), 2) * 100 AS default_rate
FROM dbo.borrower_profiles pb
LEFT JOIN dbo.loan_applications la
ON pb.borrower_id = la.borrower_id
WHERE loan_status = 'Default';


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





	


