-- creating a database Loan_analysis
CREATE database Loan_analysis;

-- Selecting the Loan_analysis database
USE Loan_analysis; 

-- describing the datatypes of the financial_data
describe financial_loan;

-- converting the issue_date column from text to date
Update financial_loan
set issue_date = str_to_date(issue_date,'%Y-%m-%d');
ALTER table financial_loan
modify column issue_date date;

-- converting the last_credit_pull_date from text to date
Update financial_loan
set last_credit_pull_date = str_to_date(last_credit_pull_date,'%Y-%m-%d');
ALTER table financial_loan
modify column last_credit_pull_date date;

-- converting the last_payment_date from text to date
Update financial_loan
set last_payment_date = str_to_date(last_payment_date,'%Y-%m-%d');
ALTER table financial_loan
modify column last_payment_date date;

-- converting the next_payment_date from text to date
Update financial_loan
set next_payment_date = str_to_date(next_payment_date,'%Y-%m-%d');
ALTER table financial_loan
modify column next_payment_date date;

select * from loan_data; 

-- KPI
-- Total Loan Applications
select count(id) as Total_applications from loan_data;

-- MTD Applications
SELECT count(id) as total_applications from loan_data
WHERE MONTH(issue_date) = 12;   -- (december_month)

-- PMTD Applications
SELECT count(id) as total_applications from loan_data
WHERE month(issue_date) = 11;    -- (previous_month(PMTD) = November month)

-- Total Funded amount
SELECT sum(loan_amount) as Total_Amount from loan_data;

-- MTD Total Funded amount
SELECT SUM(loan_amount) as Total_amount from loan_data
WHERE MONTH(issue_date) = 12;    -- (december_month)

-- PMTD Total Funded amount
SELECT SUM(loan_amount) as Total_amount from loan_data
WHERE MONTH(issue_date) = 11;    -- (previous_month(PMTD) = November month)

-- Total Amount received
SELECT sum(total_payment) as Total_amount_received from loan_data;

-- MTD Total Amount received
SELECT sum(total_payment) as Total_Amount_received from loan_data
WHERE month(issue_date) = 12;    -- (december_month)

-- PMTD Total Amount received
SELECT sum(total_payment) as Total_amount_received from loan_data
WHERE MONTH(issue_date) = 11;    -- (previous_month(PMTD) = November month)

-- Average Interest rate
SELECT round(avg(int_rate)*100,3) as Avg_int_rate from loan_data;

-- MTD Average Interest rate
SELECT round(AVG(int_rate)*100,3) as Avg_int_rate from loan_data
WHERE month(issue_date) = 12;    -- (december_month)

-- PMTD Total Amount received
SELECT round(avg(int_rate)*100,3) as Avg_int_rate from loan_data
WHERE MONTH(issue_date) = 11;    -- (previous_month(PMTD) = November month)

-- Average Debt_to_Income Ratio (DTI)
SELECT round(AVG(dti)*100,3) as Average_dti from loan_data;

--  MTD Average Interest rate
SELECT round(AVG(dti)*100,3) as Avg_dti from loan_data
WHERE month(issue_date) = 12;    -- (december_month)

-- PMTD Total Amount received
SELECT round(avg(dti)*100,3) as Avg_dti from loan_data
WHERE MONTH(issue_date) = 11;    -- (previous_month(PMTD) = November month)

select distinct(loan_status) from loan_data;

-- GOOD LOAN ISSUED
-- Good loan_percentage
SELECT 
	concat(round(count(case when loan_status IN ("Fully Paid","Current") THEN id end) *100 /
    count(id),3),"%") as good_loan_percentage
FROM loan_data;

-- Good loan Applications
SELECT count(id) as good_loan_applications from loan_data
where loan_status IN ("Fully Paid", "Current");

-- Good Loan Funded amount 
SELECT sum(loan_amount) as Good_loan_funded_amount from loan_data
WHERE loan_status IN ("Fully Paid","Current") 
and month(issue_date) = 12 and year(issue_date) = 2021;    -- Month(december) and year(2021)

-- Good loan Amount received
SELECT sum(total_payment) as Good_loan_amount_received from loan_data
WHERE loan_status IN ("Fully Paid","Current") ;


-- BAD LOAN ISSUED
-- BAD loan percentage
SELECT concat(round(count(case when loan_status = "Charged Off" then id end) * 100 /
count(id),3),"%") as bad_loan_percentage from loan_data;

-- BAD loan Applications
SELECT count(id) as bad_loan_applications from loan_data
where loan_status = "Charged Off";

-- BAD Loan Funded amount
SELECT sum(loan_amount) as Bad_loan_funded_amount from loan_data
where loan_status = "Charged Off";

-- BAD loan Amount received
SELECT SUM(total_payment) as Bad_loan_amount_received from loan_data
where loan_status = "Charged Off";

-- Loan Status
SELECT loan_status,
count(id) as Total_number_of_applications,
sum(loan_amount) as Total_funded_amount,
sum(total_payment) as Total_loan_amount_received,
concat(round(avg(int_rate)*100,3),"%") as Average_interest_rate,
concat(round(avg(dti)*100,3),"%") as Average_dti
from loan_data
GROUP BY 1;

-- Monthly analysis
SELECT loan_status,
count(id) as Total_number_of_applications,
sum(loan_amount) as MTD_Total_funded_amount,
sum(total_payment) as MTD_Total_loan_amount_received
from loan_data
WHERE month(issue_date) = 12
GROUP BY 1;

-- Bank Loan report (Monthly)
SELECT 
    MONTH(issue_date) AS Month_number,
    MONTHNAME(issue_date) AS Month_name,
    COUNT(id) AS Total_number_of_applications,
    SUM(loan_amount) AS Total_funded_amount,
    SUM(total_payment) AS Total_Amount_received
FROM 
    loan_data
GROUP BY 
    1,2
ORDER BY 
    MONTH(issue_date);
    
-- State
SELECT address_state,
count(id) as Total_number_of_applications,
sum(loan_amount) as Total_funded_amount,
sum(total_payment) as Total_amount_received
FROM loan_data
group by 1
ORDER BY 1;

-- Term
SELECT term,
count(id) as Total_number_of_applications,
sum(loan_amount) as Total_funded_amount,
sum(total_payment) as Total_amount_received
FROM loan_data
GROUP BY 1
ORDER BY 1;

-- Employee_length
SELECT emp_length as Employee_length,
count(id) as Total_number_of_applications,
sum(loan_amount) as Total_funded_amount,
sum(total_payment) as Total_amount_received
from loan_data
GROUP BY 1
ORDER BY 1;

-- Purpose
SELECT purpose,
count(id) as Total_number_of_applications,
sum(loan_amount) as Total_funded_amount,
sum(total_payment) as Total_amount_received
FROM loan_data
group by 1
ORDER BY 1;

-- House Ownership
SELECT home_ownership,
count(id) as Total_number_of_applications,
sum(loan_amount) as Total_funded_amount,
sum(total_payment) as Total_amount_received
FROM loan_data
GROUP BY 1
ORDER BY 1;

-- Bank_loan_report_analysis (Full_report)
SELECT count(id) as Total_number_of_applications,
address_state,
emp_length,
home_ownership,
loan_status,
purpose,
term,
sum(loan_amount) as Total_funded_Amount,
sum(total_payment) as Total_amount_received,
concat(round(avg(int_rate)*100,3),"%") as Average_interest_rate,
concat(round(avg(dti)*100,3),"%") as Average_DTI
FROM loan_data
GROUP BY 2,3,4,5,6,7
Order by 1 asc;
