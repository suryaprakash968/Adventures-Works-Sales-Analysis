create database project;
use project;
show tables;

                              -- KPI --
-- 1.TOTAL SALES
select 
	round(sum(salesamount),0) as 
    Totalsales from factsales;
    
   -- 2.TOTAL PROFIT
select 
     round(sum(salesamount-totalproductcost),0) as 
     Totalprofit from factsales;
     
-- 3.TOTAL ORDER COUNT
select 
     count(orderdatekey) as 
     Totalordercount from factsales; 


-- 4.TOTAL PRODUCTIONCOST 
select 
     round(sum(Totalproductcost),0) as 
     Totalproductioncost from factsales;

-- 5.TOTAL FRIEGHT CHARGES 
select 
     round(sum(freight),0) as 
     Frieghtcharges from factsales;

-- YEAR/MONTH/QUARTER/DAY
	-- YEAR
	select 
           d.calendaryear as Year,round(sum(f.salesamount ),0) as Totalsales from factsales as f
           join dimdate as d on d.datekey = f.orderdatekey
           group by d.calendaryear 
           order by  d.calendaryear;
    
    
          -- MONTHWISESALES--
    select 
           d.englishmonthname as Month,round(sum(f.salesamount),0) as Totalsales from factsales as f 
           join dimdate as d on d.datekey = f.orderdatekey
           group by d.MonthNumberOfYear,d.englishmonthname
           order by d.MonthNumberOfYear;
    
    
             -- QUARTERWISESALES--
	select 
		   d.calendarquarter as Quarter,round(sum(f.salesamount),0) as Totalsales from factsales as f 
           join dimdate as d on f.orderdatekey = d.datekey
           group by d.CalendarQuarter
           order by d.CalendarQuarter;
            
            
            -- DAYWISE SALES--
    select 
          d.englishdaynameofweek as WeekName,round(sum(f.salesamount),0) as Totalsales from dimdate d 
          join factsales f on d.datekey = f.orderdatekey
          group by d.EnglishDayNameOfWeek,d.DayNumberOfWeek
          order by d.DayNumberOfWeek;          
   
   
             -- GROWTH PERCENTAGE % YOY 
  with yearly as
	     (select year,SUM(totalsales) as Totalsales from factsales group by Year)
	     select year,totalsales,lag(totalsales) over(order by year) PreviousYear, 
	     totalsales-lag(totalsales) over()/lag(totalsales) over()
	     as YOY_Growth from yearly order by year;
          
          
          -- SALES AMOUNT--
    select 
           sum((unitprice* orderquantity)-unitpricediscountpct)
           as Salesamount from factsales;
           
           
           -- PRODUCTIONCOST
	select 
           sum(UnitCost/orderquantity)  
           as Productioncost from factsales;        
	
           -- TOTAL PROFIT
    select
           round(sum(salesamount-productioncost),0) as Profit from factsales ;
           
           
           -- TOP 5 PRODUCT BY SALES
    select
           d.englishproductname as Top5product ,round(sum(f.salesamount),0) as Totalsales from factsales f 
           join dimproduct d on f.productkey = d.productkey
           group by d.EnglishProductName
           order by totalsales desc limit 5;
           
		   
           
           
           -- REGIONWISE SALES         
    select 
          d.salesterritoryregion as region, sum(f.salesamount) as Totalsales from dimsalesterritory as d 
          join factsales as f on d.salesterritorykey= f.salesterritorykey
		  group by d.SalesTerritoryRegion
          order by totalsales;
    
          -- COUNTRYWISE SALES   
   select 
         d.salesterritorycountry as country, sum(f.salesamount) as Totalsales from dimsalesterritory as d 
         join factsales as f on d.salesterritorykey= f.salesterritorykey
         group by d.SalesTerritorycountry
         order by totalsales; 
    
    
           -- TOP 5 CUSTOMERS
    select
          d.fullname,sum(f.salesamount) as totalsales  from dimcustomer d
          join factsales f on d.customerkey = f.customerkey
          group by d.FullName
          order by totalsales desc limit  5;
    
           
           -- TOP 5 PRODUCT   
    select  
          productname , sum(salesamount) as salesamount from factsales 
          group by productname
	      order by salesamount  desc limit 5;
           
           
           -- UNION OF FACTINTERNETSALES AND FACTINTERNETSALESNEW
    select * from factinternetsales
    union
    select * from factinternetsalesnew;
    
select d.englishproductname as ProductName from dimproduct d 
left join factsales f on d.productkey = f. OrderDateKey
group by d.EnglishProductName;

select  concat(c.firstname,c.lastname) as customerfullname,sum(f.unitprice) as unitprice  from dimcustomer c
left join factsales f on c.customerkey =  f.customerkey
group by customerfullname;




