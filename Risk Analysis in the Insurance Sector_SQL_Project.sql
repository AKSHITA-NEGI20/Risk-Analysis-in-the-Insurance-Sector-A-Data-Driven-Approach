select * from insurance_data

alter table insurance_data alter column age int;
alter table insurance_data alter column sex varchar(10);
alter table insurance_data alter column bmi float;
alter table insurance_data alter column children int;
alter table insurance_data alter column smoker varchar(10);
alter table insurance_data alter column region varchar(20);
alter table insurance_data alter column charges float;


--Basic Descriptive Statistics
-- Average charges
select AVG(charges) as avg_charges from  insurance_data;  --13270.422

-- Minimum and maximum charges
select MIN(charges) as min_charges, MAX(charges) as max_charges from insurance_data;  --1121.8739	63770.42801

-- Count of customers by region
SELECT region, COUNT(*) as customer_count FROM  insurance_data GROUP BY region;    --northeast=324, southeast=364,southwest=325,northwest=325

-- Count of smokers vs non-smokers
SELECT smoker, COUNT(*) as count FROM  insurance_data GROUP BY smoker; --yes=274  no=1064

--Identify Risk Factors
-- Age distribution
SELECT age, COUNT(*) as count FROM  insurance_data GROUP BY age ORDER BY age;

-- Correlation between BMI and charges
SELECT bmi, AVG(charges) as avg_charges FROM insurance_data GROUP BY bmi ORDER BY bmi;

-- Average charges for smokers vs non-smokers
SELECT smoker, AVG(charges) as avg_charges FROM insurance_data GROUP BY smoker;

-- Average charges by region
SELECT region, AVG(charges) as avg_charges FROM insurance_data GROUP BY region;

-- High-risk age groups based on average charges
SELECT age, AVG(charges) as avg_charges 
FROM insurance_data 
GROUP BY age 
HAVING avg_charges > (SELECT AVG(charges) FROM insurance_data) 
ORDER BY avg_charges DESC;

--Create a Risk Scoring Model
-- Add a risk_score column
ALTER TABLE insurance_data add risk_score INT;

-- Calculate risk scores based on charges
UPDATE insurance_data
SET risk_score = CASE
    WHEN charges > 20000 THEN 5
    WHEN charges BETWEEN 15000 AND 20000 THEN 4
    WHEN charges BETWEEN 10000 AND 15000 THEN 3
    WHEN charges BETWEEN 5000 AND 10000 THEN 2
    ELSE 1
END;

-- Reporting and Insights
--High-Risk Customers Report
SELECT age, sex, bmi, children, smoker, region, charges, risk_score
FROM insurance_data
WHERE risk_score >= 4
ORDER BY risk_score DESC, charges DESC;

-- Average risk score by region
SELECT region, AVG(risk_score) AS avg_risk_score
FROM insurance_data
GROUP BY region
ORDER BY avg_risk_score DESC;

-- Average risk score for smokers vs non-smokers
SELECT smoker, AVG(risk_score) AS avg_risk_score
FROM insurance_data
GROUP BY smoker
ORDER BY avg_risk_score DESC;


--This data-driven approach provides insights into high-risk factors, helping insurance companies to make informed decisions and improve their risk management strategies. ​