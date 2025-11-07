
-- Property Performance
create view property_KPIs as (
select format(avg(cast(s.sale_price as float)) , 'N0') 'Average Property Value Sold',
       avg(case when status='Sold' then datediff(day,listed_date ,sold_date) end) 'Average Time on Market',
	   count(case when status='Sold' then p.property_id end ) *100 / count(p.property_id)  'Property Occupancy Rate',
	   count(case when status='Sold' then p.property_id end) 'sold properties',
	   count(p.property_id) 'No of properties'
from properties p left join sales_transactions s
on p.property_id=s.property_id
) 
GO

select * from  property_KPIs ;

Go 


-- Listings status by Region
create procedure ListingsStatusByRegion 
  @Status varchar(50) 
as
begin
	select l.region, count(p.property_id) 'No of Listing listings'
	from properties p join locations l
	on l.location_id= p.location_id
	where p.status=  @Status
	group by  l.region 
end;
GO

EXEC  ListingsStatusByRegion 'Active' ;

GO

-- Agent performance
-- deals closed per agent (top 5) in a specific date 
alter procedure GetTopAgentsByClosedDeals 
  @target_month int , @target_year int
as
begin
	select top 5 a.full_name ,
	      count(l.lead_id) 'deals closed',
	      format(avg(st.sale_price), 'N0') 'Average Revenue',
		  format(avg(c.commission_amount) , 'N0') 'Average Commession'
	from agents a join leads l
	on l.agent_id=a.agent_id join sales_transactions st
	on a.agent_id=st.agent_id join commissions c
	on st.commission_id=c.commission_id 
	where l.converted=1 and month(st.sale_date)= @target_month and year(st.sale_date)=@target_year 
	group by a.full_name 
	order by 2 desc 
end;

GO

EXEC GetTopAgentsByClosedDeals 9,2024 ;

GO


-- Market insights and pricing distribution
create view Market_insights as(
select loc.region,pt.type_name,
       count(st.sale_id) 'sold properties', 
	   format(avg(st.sale_price) , 'N0') 'Average price' ,
	   format(avg(p.size_sqm) , 'N0')  'Average of Square Meter'
from properties p join sales_transactions st
on st.property_id= p.property_id join property_types pt 
on p.type_id=pt.type_id join locations loc
on loc.location_id=p.location_id 
where p.status='Sold'
group by loc.region,pt.type_name 

);
GO

select * from Market_insights
order by 3 desc 




-- Total sales and revenue trends
create view SalesTrends as (
select year(sale_date) 'Year',
       month(sale_date) 'month',
       count(st.sale_id) Sales,
	   format(sum(cast(st.sale_price as float)), 'N0') Revenue,
	   format(sum(cast(st.sale_price as float)-c.commission_amount) , 'N0') Net_Revenue
from sales_transactions st join commissions c
on st.commission_id=c.commission_id
group by year(sale_date), month(sale_date) 

);

select * from SalesTrends
order by 1 , 2;


-- Month-over-Month Growth
create procedure MOMGrowth 
    @year int
as 
begin
	select [month],
	        format(Revenue, 'N0') Revenue,
			format(Revenue- lag(cast(Revenue as float)) over(order by [month]) , 'N0')  MOMGrowth
	from(
	select month(sale_date) 'month',
		   sum(cast(sale_price as float)) Revenue
	from sales_transactions 
	where year(sale_date) = @year
	group by  month(sale_date)
	) as Revenue_Growth 
end ;

EXEC MOMGrowth 2024; 


-- top-performing campaigns
create view CampaignPerformance as(
select c.campaign_id,
       c.name, 
       datediff(day,c.start_date,c.end_date ) campaign_duration,
	   c.budget,
	   cp.clicks,
	   cp.cost,
	   cp.deals_closed,
	   cp.leads_generated,
	   cp.impressions,
	   cp.roi
from campaigns c join campaign_performance cp
on c.campaign_id=cp.campaign_id
)

select * from CampaignPerformance


-- top-performing offices
create view OfficesPerformance
as(
select o.office_name ,
       count(distinct a.agent_id) AgentsCount,
	   count(l.lead_id) LeadsCount,
	   count(case when l.converted=1 then lead_id end ) Sales 
from offices o  join  agents a
on a.office_id=o.office_id  join leads l 
on a.agent_id=l.agent_id 
group by o.office_name 
) ;

select top 5* from OfficesPerformance
order by Sales desc


-- Number of leads and Conversion_Rate 
create function LeadsAndConversion()
returns table
as
return(
	select count(lead_id) 'Total Leads Generated',
		   count(case when converted=1 then lead_id end) *100 / Count(lead_id) Conversion_Rate 
	from leads l )
; 

select * from dbo.LeadsAndConversion()



--Cost per Lead
create function Cost_per_Lead ()
returns nvarchar(50)
as
begin
    declare @totalCost float, @TotalLeads int, @CostPerLead nvarchar(50)
	set  @totalCost =( select sum(cast(cp.cost as float))
	from campaigns c  join campaign_performance cp 
	on cp.campaign_id=c.campaign_id  ) ;
	set @TotalLeads = (select count(lead_id) from leads) ;
	set @CostPerLead = @totalCost/@TotalLeads 
	Return @CostPerLead ;
end ;



select dbo.Cost_per_Lead() as CostPerLead 


--Lead Source Effectiveness
create view LeadSourceEffectiveness 
as(
select ls.source_name,
      cc.channel_name,
	  count(l.lead_id) 'No Of Leads'
from leads l join campaigns c
on l.campaign_id=c.campaign_id join campaign_channels cc
on c.channel_id=cc.channel_id join properties p
on p.property_id=l.property_id join listing_sources ls
on ls.source_id=p.source_id
group by ls.source_name,cc.channel_name 
) ;

 select * from LeadSourceEffectiveness ; 


-- Average Sales Cycle Duration
create function AvgSalesCycleDuration()
Returns int 
as
begin
     declare @AvgDuration int 
    set @AvgDuration= (select avg(datediff(day, l.created_at,st.sale_date) )
	from leads l join sales_transactions st
	on l.lead_id=st.lead_id)
	return @AvgDuration 
end ;

select dbo.AvgSalesCycleDuration()






