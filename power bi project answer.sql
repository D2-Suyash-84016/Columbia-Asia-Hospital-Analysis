create database power_bi_project;
use power_bi_project;
show tables;
select * from doctor_patients_data;
-- 15.	Identify the top 5 doctors who generated the most revenue but had the fewest patients. (SQL)
select doctor_name, sum(total_bill) as revenue ,count(distinct patient_id) as number_of_patients from doctor_patients_data
group by 1
order by
revenue desc ,number_of_patients asc limit 5;

-- Q16
with cte as(
select department_referral as department,mid(date,04,02) as month,avg(patient_waittime) as avg_waittime from hospital_data group by 1,2 )
,cte1 as(
select *,lag(avg_waittime,1)over(partition by department order by month asc) as prev_waittime,
lag(avg_waittime,2)over(partition by department order by month asc) as prev_prev_waittime from cte)
,cte2 as(
select *,case when avg_waittime>prev_waittime and prev_waittime>prev_prev_waittime then "yes" else "no"
end as decision from cte1)
select * from cte2 where decision="yes";
-- Q17
with doctor_patients as(
select doctor_id,sum(case when patient_gender='m' then 1 else 0 end)/sum(case when patient_gender='f' then 1 else 0 end) as ratio from
doctor_patients_data a join hospital_data b on a.patient_id=b.patient_id
group by 1)


select *,dense_rank()over(order by ratio desc) as `rank` from doctor_patients;
-- --Q18
 SELECT
dp. Doctor_ID,
dp. Doctor_Name,
ROUND (AVG(he.patient_sat_score), 2) AS avg_satisfaction FROM  doctor_patients_data dp
JOIN hospital_data he ON dp.patient_id = he.patient_id
WHERE he.patient_sat_score IS NOT NULL
GROUP BY 1,2;
-- 19. Find doctors who have treated patients from different races and calculate the diversity of their patient base. (SQL)

SELECT dp. Doctor_ID,dp. Doctor_Name,COUNT(DISTINCT he.patient_race) AS race_diversity
FROM doctor_patients_data dp
JOIN hospital_data he ON dp.patient_id = he.patient_id
GROUP BY 1,2
HAVING race_diversity > 1
ORDER BY race_diversity DESC;

-- Q20
Select d.department_referral as department ,
round(sum(case when h.patient_gender = "M" then d.total_bill else 0 end)/
sum(case when h.patient_gender = "F" then d.total_bill else 0 end),2) as gender_revenue_ratio
FROM doctor_patients_data d
JOIN hospital_data h ON d.patient_id = h.patient_id
group by d.department_referral 
order by gender_revenue_ratio desc , department asc;
 





