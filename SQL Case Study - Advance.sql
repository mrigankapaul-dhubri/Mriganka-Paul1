--Questions
--Q1. List all the states in which we have customers who have bought cel phones from 2005 till date.
select T2.state, T2.country, T1.date
from fact_transactions T1
inner join dim_location T2 on T1.idlocation = T2.idlocation
where year(T1.date) >= 2005
order by T1.date desc
--------------------------------------------------------------------------------------------------------------------------------------------

--Q2. Which state in the US is buying more 'Samsung' call phones.
select Top 1 sum(T1.Quantity) "Total no. of quantity sold",T2.City, T2.Country
from fact_transactions T1
inner join DIM_LOCATION T2 on T1.IDLocation = T2.IDLocation
inner join DIM_MODEL T3 on T1.IDModel = T3.IDModel
inner join DIM_MANUFACTURER T4 on T3.IDManufacturer = T4.IDManufacturer
where T4.Manufacturer_Name = 'Samsung' and T2.Country = 'US'
group by T2.City, T2.Country
order by sum(T1.Quantity) desc
----------------------------------------------------------------------------------------------------------------------------------------------

--Q3. Show the number of transactions for each model per zip code per state
select count(T1.Quantity) "Number of transactions",T3.Model_Name, T2.State, T2.Country, T2.ZipCode
from fact_transactions T1
inner join DIM_LOCATION T2 on T1.IDLocation = T2.IDLocation
inner join DIM_MODEL T3 on T1.IDModel = T3.IDModel
group by T3.Model_Name, T2.State, T2.Country, T2.ZipCode
order by T2.State
----------------------------------------------------------------------------------------------------------------------------------------------

--Q4. Show the cheapest cellphone.
select Top 1 * from DIM_MODEL T1
inner join DIM_MANUFACTURER T2 on T1.IDManufacturer = T2.IDManufacturer
order by Unit_price asc
----------------------------------------------------------------------------------------------------------------------------------------------

--Q5. Find out the average price for each model in the top5 manufacturers in terms of sales quantity and order by average price
select avg(T4.TotalPrice) "Average Price for each model", T5.model_name, T6.manufacturer_name
from FACT_TRANSACTIONS T4
inner join DIM_MODEL T5 on T4.IDModel = T5.IDModel
inner join DIM_MANUFACTURER T6 on T5.IDManufacturer = T6.IDManufacturer
where T6.Manufacturer_Name in (select top 5 T3.manufacturer_name
                               from FACT_TRANSACTIONS T1
                               inner join DIM_MODEL T2 on T1.IDModel = T2.IDModel
                               inner join DIM_MANUFACTURER T3 on T2.IDManufacturer = T3.IDManufacturer
                               group by T3.Manufacturer_Name
                               order by sum(T1.Quantity) desc, avg(T2.Unit_price) desc)
group by T5.model_name, T6.manufacturer_name
order by T6.manufacturer_name
--------------------------------------------------------------------------------------------------------------------------------------------

--Q6. List the names of the customers and average amount spent in 2009, where the average is higher than 500
select avg(T1.totalprice) "Average Amount Spent", T2.Customer_Name, year(T1.date) "Year"
from FACT_TRANSACTIONS T1
inner join DIM_CUSTOMER T2 on T1.IDCustomer = T2.IDCustomer
where year(T1.date) = 2009
group by T2.Customer_Name, year(T1.date)
having avg(T1.totalprice) > 500
---------------------------------------------------------------------------------------------------------------------------------------------

--Q7. List if there is any model that was in the top 5 in terms of quantity, simultaneously in 2008, 2009 and 2010.

select distinct T1.idmodel, T2.model_name, year(T1.date) as "Year"
from fact_transactions T1 
inner join dim_model T2 on T1.idmodel = T2.idmodel
where year(T1.date) in (2008,2009,2010) and T1.idmodel in (select top 5 idmodel
                                               from fact_transactions 
											   where year(date) = 2009 and idmodel in (select top 5 idmodel
																						from fact_transactions 
																						where year(date) = 2010 and (idmodel in (select top 5 idmodel
																						                                         from fact_transactions 
																						                                         where year(date) = 2008
																						                                         group by idmodel
																						                                         order by sum(quantity) desc))
																						group by idmodel
																						order by sum(quantity) desc)
											   group by idmodel
											   order by sum(quantity) desc)
---------------------------------------------------------------------------------------------------------------------------------------------------------

--Q9. Show the manufacturers that sold cellphone in 2010 but didnot in 2009.

select distinct T3.manufacturer_name
from fact_transactions T1
inner join dim_model T2 on T1.idmodel = T2.idmodel
inner join dim_manufacturer T3 on T2.idmanufacturer = T2.idmanufacturer 
where year(T1.date) = 2010 and (T3.manufacturer_name not in (select distinct T6.manufacturer_name
															from fact_transactions T4
															inner join dim_model T5 on T5.idmodel = T4.idmodel
															inner join dim_manufacturer T6 on T5.idmanufacturer = T6.idmanufacturer 
															where year(T4.date) = 2009))
---------------------------------------------------------------------------------------------------------------------------------------------------------








select * from DIM_CUSTOMER
select * from dim_date
select * from dim_location
select * from dim_model
select * from DIM_MANUFACTURER
select * from fact_transactions


