use BankLoanDB;
select * from bank_loan_data;

--1 Total Loan Applications
select count(*) as Total_Loan_Application from bank_loan_data;

--2 MTD Total Loan Applications
select count(*) as MTD_Total_Loan_Application from bank_loan_data where MONTH(issue_date) = (select MAX(MONTH(issue_date)) from bank_loan_data);

--3 Loan Applications Previous month
select count(*) as Previous_Month_Applications from bank_loan_data where MONTH(issue_date)=(select MAX(MONTH(issue_date)-1) from bank_loan_data);

--4 MTM Total Loan Applications change
with Current_month_application as
(select count(*) as MTD_Total_Loan_Application from bank_loan_data where MONTH(issue_date) = (select MAX(MONTH(issue_date)) from bank_loan_data)),
Previous_month_application as
(select count(*) as Previous_Month_Applications from bank_loan_data where MONTH(issue_date)=(select MAX(MONTH(issue_date)-1) from bank_loan_data))
select CAST((100.0*(MTD_Total_Loan_Application-Previous_Month_Applications)/Previous_Month_Applications) as DECIMAL(10,2)) as Total_MTM_Growth
from Current_month_application,Previous_month_application;

--5 Total Funded Amount 
select ROUND(SUM(loan_amount),2) as Total_Funded_Amount from bank_loan_data;

--6 MTD Total Funded Amount
select ROUND(SUM(loan_amount),2) as MTD_Total_Funded_Amount from bank_loan_data where MONTH(issue_date) = (select MAX(MONTH(issue_date)) from bank_loan_data);

--7 PMTD Total Funded Amount
select ROUND(SUM(loan_amount),2) as PMTD_Total_Funded_Amount from bank_loan_data where MONTH(issue_date) = (select MAX(MONTH(issue_date))-1 from bank_loan_data);

--8 MTM Total Funded Amount change
with CM_Fund_Amount as
(select ROUND(SUM(loan_amount),2) as MTD_Total_Funded_Amount from bank_loan_data where MONTH(issue_date) = (select MAX(MONTH(issue_date)) from bank_loan_data)),
PM_Fund_Amount as
(select ROUND(SUM(loan_amount),2) as PMTD_Total_Funded_Amount from bank_loan_data where MONTH(issue_date) = (select MAX(MONTH(issue_date))-1 from bank_loan_data))
select CAST((100.0*(MTD_Total_Funded_Amount-PMTD_Total_Funded_Amount)/PMTD_Total_Funded_Amount) as DECIMAL(10,2)) as Total_MTM_Fund_Growth
from CM_Fund_Amount,PM_Fund_Amount;

--9 Total Received Amount
select ROUND(SUM(total_payment),2) as Total_Amount_Received from bank_loan_data;

--10 Total Received Amount MTD
select ROUND(SUM(total_payment),2) as MTD_Total_Recieved from bank_loan_data where MONTH(issue_date)=(select MAX(MONTH(issue_date)) from bank_loan_data);

--11 Total Received Amount PMTD
select ROUND(SUM(total_payment),2) as PMTD_Total_Recieved from bank_loan_data where MONTH(issue_date)=(select MAX(MONTH(issue_date))-1 from bank_loan_data);

--12 MTM Total Received Amount Change
with CM_Recieve_Amount as
(select ROUND(SUM(total_payment),2) as MTD_Total_Received_Amount from bank_loan_data where MONTH(issue_date) = (select MAX(MONTH(issue_date)) from bank_loan_data)),
PM_Receive_Amount as
(select ROUND(SUM(total_payment),2) as PMTD_Total_Received_Amount from bank_loan_data where MONTH(issue_date) = (select MAX(MONTH(issue_date))-1 from bank_loan_data))
select CAST((100.0*(MTD_Total_Received_Amount-PMTD_Total_Received_Amount)/PMTD_Total_Received_Amount) as DECIMAL(10,2)) as Total_MTM_Received_Growth
from CM_Recieve_Amount,PM_Receive_Amount;

--13 Average Interest Rate
select ROUND(100*avg(int_rate),2) as Average_Interest_Rate from bank_loan_data;

--14 MTD Average Interest Rate
select ROUND(100*avg(int_rate),2) as MTD_Average_Interest_Rate from bank_loan_data where MONTH(issue_date)=(select MAX(MONTH(issue_date)) from bank_loan_data);

--15 PMTD Average Interest Rate
select ROUND(100*avg(int_rate),2) as PMTD_Average_Interest_Rate from bank_loan_data where MONTH(issue_date)=(select MAX(MONTH(issue_date))-1 from bank_loan_data);

--16 MTM Average Interest Rate Change
with CM_Average_Interest_Rate as
(select ROUND(100*avg(int_rate),2) as MTD_Average_Interest_Rate from bank_loan_data where MONTH(issue_date)=(select MAX(MONTH(issue_date)) from bank_loan_data)),
PM_Average_Interest_Rate as
(select ROUND(100*avg(int_rate),2) as PMTD_Average_Interest_Rate from bank_loan_data where MONTH(issue_date)=(select MAX(MONTH(issue_date))-1 from bank_loan_data))
select CAST((100.0*(MTD_Average_Interest_Rate-PMTD_Average_Interest_Rate)/PMTD_Average_Interest_Rate) as DECIMAL(10,2)) as MTM_Average_Interest_Rate_Growth
from CM_Average_Interest_Rate,PM_Average_Interest_Rate;

--17 Average Debt to Income Ratio

select ROUND(100*avg(dti),2) as Average_DTI from bank_loan_data;

--18 MTD DTI
select ROUND(100*avg(dti),2) as MTD_Average_DTI from bank_loan_data where MONTH(issue_date)=(select MAX(MONTH(issue_date)) from bank_loan_data);

--19 PMTD DTI
select ROUND(100*avg(dti),2) as PMTD_Average_DTI from bank_loan_data where MONTH(issue_date)=(select MAX(MONTH(issue_date))-1 from bank_loan_data);

--20 MTM DTI Change
with CM_Average_DTI as
(select ROUND(100*avg(dti),2) as MTD_Average_DTI from bank_loan_data where MONTH(issue_date)=(select MAX(MONTH(issue_date)) from bank_loan_data)),
PM_Average_DTI as
(select ROUND(100*avg(dti),2) as PMTD_Average_DTI from bank_loan_data where MONTH(issue_date)=(select MAX(MONTH(issue_date))-1 from bank_loan_data))
select CAST((100.0*(MTD_Average_DTI-PMTD_Average_DTI)/PMTD_Average_DTI) as DECIMAL(10,2)) as MTM_Average_DTI_Growth
from CM_Average_DTI,PM_Average_DTI;

--21 Good Loan Applications

select count(*) as total_good_loan_applications from bank_loan_data  where loan_status in ('fully paid','current');

--22 Good loan Applications percentage

with total_application as 
(select count(*) as Total_Loan_Application from bank_loan_data),
good_applications as
(select count(*) as total_good_loan_applications from bank_loan_data  where loan_status in ('fully paid','current'))
select CAST((100*CAST(total_good_loan_applications as DECIMAL(10,2))/CAST((Total_Loan_Application) as DECIMAL(10,2))) as DECIMAL(10,2))
as percentage_of_good_loans from total_application,good_applications;

--23 Good Loan Funded Amount

select ROUND(SUM(loan_amount),2) as total_good_loan_fund_amount from bank_loan_data  where loan_status in ('fully paid','current');

--24 Good Loan Received Amount

select ROUND(SUM(total_payment),2) as total_good_loan_recieved_amount from bank_loan_data  where loan_status in ('fully paid','current');

--25 Bad Loan Applications

select count(*) as total_bad_loan_applications from bank_loan_data  where loan_status='charged off'; 

--26 Bad loan Applications percentage

with total_application as 
(select count(*) as Total_Loan_Application from bank_loan_data),
bad_applications as
(select count(*) as total_bad_loan_applications from bank_loan_data  where loan_status='charged off')
select CAST((100*CAST(total_bad_loan_applications as DECIMAL(10,2))/CAST((Total_Loan_Application) as DECIMAL(10,2))) as DECIMAL(10,2))
as percentage_of_bad_loans from total_application,bad_applications;

--27 Bad Loan Funded Amount

select ROUND(SUM(loan_amount),2) as total_bad_loan_fund_amount from bank_loan_data where loan_status='charged off';

--27 Bad Loan Received Amount

select ROUND(SUM(total_payment),2) as total_bad_loan_received_amount from bank_loan_data where loan_status='charged off';

--28 Loan Status Grid View Amounts

select loan_status,COUNT(*) as total_loan_application,SUM(loan_amount) as total_loan_amount,SUM(total_payment) as total_amount_received,
ROUND(100*AVG(int_rate),2) as average_interest_rate,ROUND(100*AVG(dti),2) as average_debt_to_income from bank_loan_data group by loan_status;


select loan_status,ROUND(SUM(loan_amount),2) as MTD_Total_Funded_Amount,ROUND(SUM(total_payment),2) as MTD_Total_Recieved_Amount from bank_loan_data where MONTH(issue_date) = (select MAX(MONTH(issue_date)) from bank_loan_data) group by loan_status;


--29 Total Loan Applications by month

select MONTH(issue_date) as month_no,DATENAME(MONTH,issue_date) as month,COUNT(*) as total_applications ,
SUM(loan_amount) as total_funded_amount,SUM(total_payment) as total_received_amount 
from bank_loan_data
group by MONTH(issue_date),DATENAME(MONTH,issue_date)
order by MONTH(issue_date);

--30 Total Loan Applications State Wise

select address_state as State,COUNT(*) as total_applications ,
SUM(loan_amount) as total_funded_amount,SUM(total_payment) as total_received_amount 
from bank_loan_data 
group by address_state
order by total_applications desc,total_funded_amount desc;

--31 Term wise Percentage , total_applications,funded_amount and received_amount

select term,COUNT(*) as total_applications ,
SUM(loan_amount) as total_funded_amount,SUM(total_payment) as total_received_amount,
(CASE
When term='36 months' then 100*CAST((select count(*) from bank_loan_data where term='36 months') as decimal(10,2))/CAST((select count(*) from bank_loan_data ) as decimal(10,2)) 
When term='60 months' then 100*CAST((select count(*) from bank_loan_data where term='60 months') as decimal(10,2))/CAST((select count(*) from bank_loan_data) as decimal(10,2))
END) as percentage_of_composition
from bank_loan_data 
group by term;


--32 total_applications,funded_amount and received_amount by employee experience

select emp_length,COUNT(*) as total_applications ,
SUM(loan_amount) as total_funded_amount,SUM(total_payment) as total_received_amount
from bank_loan_data 
group by emp_length
order by total_applications desc , total_funded_amount desc;

--33 total_applications,funded_amount and received_amount by purpose

select purpose,COUNT(*) as total_applications ,
SUM(loan_amount) as total_funded_amount,SUM(total_payment) as total_received_amount
from bank_loan_data 
group by purpose
order by total_applications desc , total_funded_amount desc;

--34 total_applications,funded_amount and received_amount by home ownership

select home_ownership,COUNT(*) as total_applications ,
SUM(loan_amount) as total_funded_amount,SUM(total_payment) as total_received_amount
from bank_loan_data 
group by home_ownership
order by total_applications desc , total_funded_amount desc;

--35 Details Dashboard 

select id,purpose,home_ownership,grade,sub_grade,issue_date,loan_amount as Funded_Amount,int_rate as Interest_Rate,installment,total_payment as Amount_Collection
from bank_loan_data
order by id;


---------------------------------------------Filters Check ---------------------------------------------------------------------------------

--36 purpose - Credit card ,  Grade-D , State - TX (Texas)

select COUNT(*) as total_applications ,SUM(loan_amount) as Funded_Amount , SUM(total_payment) as Received_Amount from bank_loan_data 
group by purpose,grade,address_state 
having purpose='credit card' and grade='D' and address_state='TX';

--37 Bad Loan ,  Grade C , Find Total Applications by purpose

select purpose , COUNT(*) as Loan_Applications_By_Purpose from bank_loan_data 
where loan_status='charged off' 
group by grade,purpose
having grade='C'
order by Loan_Applications_By_Purpose desc;

--38 Good Loan ,  Grade -A, State-DC, Find Total Loan Application by term

select term,COUNT(*) as total_loan_applications_by_term  from bank_loan_data 
where loan_status not in ('charged off') 
group by term,grade,address_state
having grade='A' and address_state='DC';


--39 Grade F Month on Month Funded Amount

select MONTH(issue_date) as month_no,DATENAME(MONTH,issue_date) as month_name ,SUM(loan_amount) as funded_amount from bank_loan_data 
group by grade,MONTH(issue_date),DATENAME(MONTH,issue_date)
having grade='F'
order by month_no;

--40 Bad Loan Grade G State CA Find Details

select id,purpose,home_ownership,grade,sub_grade,issue_date,loan_amount as Funded_Amount,int_rate as Interest_Rate,installment,total_payment as Amount_Collection
from bank_loan_data
where grade='G' and address_state='CA' and loan_status='charged off'
order by id;



