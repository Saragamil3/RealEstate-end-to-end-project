-- == Foreign Keys for 'properties' table ==
ALTER TABLE properties
ADD CONSTRAINT FK_properties_locations
FOREIGN KEY (location_id) REFERENCES locations(location_id);

ALTER TABLE properties
ADD CONSTRAINT FK_properties_property_types
FOREIGN KEY (type_id) REFERENCES property_types(type_id);

ALTER TABLE properties
ADD CONSTRAINT FK_properties_listing_sources
FOREIGN KEY (source_id) REFERENCES listing_sources(source_id);

ALTER TABLE properties
ADD CONSTRAINT FK_properties_agents
FOREIGN KEY (agent_id) REFERENCES agents(agent_id);

-- == Foreign Keys for 'leads' table ==
ALTER TABLE leads
ADD CONSTRAINT FK_leads_agents
FOREIGN KEY (agent_id) REFERENCES agents(agent_id);

ALTER TABLE leads
ADD CONSTRAINT FK_leads_lead_sources
FOREIGN KEY (source_id) REFERENCES lead_sources(source_id);

ALTER TABLE leads
ADD CONSTRAINT FK_leads_campaigns
FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id);

ALTER TABLE leads
ADD CONSTRAINT FK_leads_funnel_stages
FOREIGN KEY (funnel_stage_id) REFERENCES funnel_stages(funnel_stage_id);

ALTER TABLE leads
ADD CONSTRAINT FK_leads_properties
FOREIGN KEY (property_id) REFERENCES properties(property_id);

-- == Foreign Keys for 'agents' table ==
ALTER TABLE agents
ADD CONSTRAINT FK_agents_offices
FOREIGN KEY (office_id) REFERENCES offices(office_id);

-- == Foreign Keys for 'commissions' table ==
ALTER TABLE commissions
ADD CONSTRAINT FK_commissions_agents
FOREIGN KEY (agent_id) REFERENCES agents(agent_id);

-- == Foreign Keys for 'campaigns' table ==
ALTER TABLE campaigns
ADD CONSTRAINT FK_campaigns_campaign_channels
FOREIGN KEY (channel_id) REFERENCES campaign_channels(channel_id);

-- == Foreign Keys for 'campaign_performance' table ==
ALTER TABLE campaign_performance
ADD CONSTRAINT FK_campaign_performance_campaigns
FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id);

-- == Foreign Keys for 'lead_interactions' (Junction Table) ==
ALTER TABLE lead_interactions
ADD CONSTRAINT FK_lead_interactions_leads
FOREIGN KEY (lead_id) REFERENCES leads(lead_id);

ALTER TABLE lead_interactions
ADD CONSTRAINT FK_lead_interactions_agents
FOREIGN KEY (agent_id) REFERENCES agents(agent_id);

--ALTER TABLE lead_interactions
--ADD CONSTRAINT FK_lead_interactions_interaction_type
--FOREIGN KEY (interaction_type_id) REFERENCES interaction_type(interaction_type_id);

-- == Foreign Keys for 'sales_transactions' (Junction Table) ==
ALTER TABLE sales_transactions
ADD CONSTRAINT FK_sales_transactions_leads
FOREIGN KEY (lead_id) REFERENCES leads(lead_id);

ALTER TABLE sales_transactions
ADD CONSTRAINT FK_sales_transactions_properties
FOREIGN KEY (property_id) REFERENCES properties(PROPERTY_ID); 

ALTER TABLE sales_transactions
ADD CONSTRAINT FK_sales_transactions_agents
FOREIGN KEY (agent_id) REFERENCES agents(agent_id);

ALTER TABLE sales_transactions
ADD CONSTRAINT FK_sales_transactions_commission
FOREIGN KEY (commission_id) REFERENCES commissions(commission_id);

ALTER TABLE sales_transactions
ADD CONSTRAINT FK_sales_transactions_campaigns
FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id);

