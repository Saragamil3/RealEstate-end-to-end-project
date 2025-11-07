use RealEstateDB
go 

-- agent
SELECT 
    a.agent_id,
    a.full_name,
    a.email,
    a.phone,
    o.office_name,
    a.hire_date,
    a.status          
FROM agents a
LEFT JOIN offices o 
    ON a.office_id = o.office_id;  




-- property
SELECT
    p.Property_id,
    p.Property_Name,
    t.type_name AS Property_Type,
    p.size_sqft,
    p.size_sqm,
    p.bedrooms,
    p.maid_rooms,
    p.bathrooms,
    p.down_payment,
    p.payment_method,
    p.price,
    p.listed_date AS Listed_Date,
    p.available_from AS Available_From,
	p.status,
    s.source_name, 
    L.City,
    L.Region,
	l.Country
FROM properties p
LEFT JOIN locations l 
ON p.location_id = l.location_id
LEFT JOIN property_types t
on p.type_id = t.type_id
LEFT JOIN listing_sources s
on s.source_id = p.source_id
;  


-- Campaign
SELECT
    c.campaign_id,
    c.name As Campaign_Name,
    c.start_date,
	c.end_date,
	c.budget,
	c.status,
	ch.channel_name As Channel,
	cp.cost,
	cp.clicks,
	cp.impressions
FROM campaigns c
LEFT JOIN campaign_channels ch 
ON c.channel_id = ch.channel_id
LEFT JOIN campaign_performance cp
on c.campaign_id=cp.campaign_id 



--customer
SELECT 
    l.Lead_id,
    l.full_name AS Customer_Name,
    l.email,
    l.phone,
	ls.source_type,
	fs.stage_name,
	l.created_at
FROM leads l
Left join lead_sources ls
on l.source_id = ls.source_id
left join funnel_stages fs
on l.funnel_stage_id = fs.funnel_stage_id 



--fact_sales
SELECT 
   s.sale_id,             
    s.property_id ,
    s.lead_id ,
    s.agent_id ,
    s.campaign_id ,
    s.sale_date,                      
    s.sale_price,                     
    c.commission_rate,                
    c.commission_amount,             
    (s.sale_price - c.commission_amount) AS Revenue,  
    DATEDIFF(DAY, l.created_at, s.sale_date) AS days_to_sell  
FROM dbo.sales_transactions s join commissions c
on c.commission_id=s.commission_id  join leads l
on l.lead_id=s.lead_id 


-- fact_Lead
SELECT 
    l.lead_id,                      
    l.property_id,                  
    l.agent_id,                     
    l.campaign_id,                                       
    l.converted,
	l.created_at             
FROM dbo.leads AS l
