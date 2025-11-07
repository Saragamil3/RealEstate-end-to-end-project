use RealEstateDB
go 


-- CUSTOMER DIMENSION 
CREATE TABLE Dim_Customers (
    Customer_sk INT IDENTITY(1,1) PRIMARY KEY,
    Lead_id INT,
    Full_Name NVARCHAR(100),
    Email NVARCHAR(150),
    Phone NVARCHAR(150),
	source_type NVARCHAR(50),
    stage_name NVARCHAR(50),

    Source_System_Code   TINYINT NOT NULL,
   
); 

drop table Dim_Customers; 

-- PROPERTY DIMENSION
CREATE TABLE Dim_Property (
    Property_sk INT IDENTITY(1,1) PRIMARY KEY,
    Property_id INT,
    Property_Name NVARCHAR(150),
    Property_Type NVARCHAR(50),
    Size_Sqft float,
    Size_Sqm float,
    Bedrooms tinyint,
    Bathrooms int,
	Maidroom  INT,
    Down_Payment float,
    Payment_Method NVARCHAR(50),
    Price int,
    Listed_Date DATE,
    Available_From DATE,
    Status NVARCHAR(50),
    Source_Name NVARCHAR(100),
    Country NVARCHAR(100),
    Region NVARCHAR(100),
    City NVARCHAR(100),

    Source_System_Code   TINYINT NOT NULL,
    Start_Date        DATETIME, 
    End_Date          DATETIME,
    Is_Current       TINYINT NOT NULL
);




-- AGENT DIMENSION
CREATE TABLE Dim_Agents (
    Agent_sk INT IDENTITY(1,1) PRIMARY KEY,
    Agent_id INT,
    Agent_Name NVARCHAR(100),
    Email NVARCHAR(150),
    Phone NVARCHAR(50),
    Office_Name NVARCHAR(100),
    Hire_Date DATE,
    Status NVARCHAR(50),

    Source_System_Code   TINYINT NOT NULL,
    Start_Date        DATETIME, 
    End_Date          DATETIME,
    Is_Current       TINYINT NOT NULL
);


-- CAMPAIGN DIMENSION
CREATE TABLE Dim_Campaigns (
    Campaign_sk INT IDENTITY(1,1) PRIMARY KEY,
    Campaign_id INT,
    Campaign_Name NVARCHAR(150),
    Start_Date DATE,
    End_Date DATE,
    Budget DECIMAL(15,2),
    Cost DECIMAL(15,2),
    Impressions INT,
    Clicks INT,
    Channel NVARCHAR(100),
    Status NVARCHAR(50),

    Source_System_Code   TINYINT NOT NULL,

);



---------------------------------------------------------------
-- FACT TABLES


-- FACT LEADS
CREATE TABLE Fact_Leads (
    Lead_ID_pk INT IDENTITY(1,1) PRIMARY KEY,
    Property_sk INT,
    Agent_sk INT,
    Campaign_sk INT,
	Customer_sk INT,
    Created_Date_sk INT,
    Converted_Flag BIT

constraint property_fk foreign key(Property_sk)  references Dim_Property(Property_sk),
constraint Lead_ID_fk foreign key(Customer_sk)  references Dim_Customers(Customer_sk),
constraint agent_fk foreign key(Agent_sk)  references Dim_Agents(Agent_sk),
constraint campaign_fk foreign key(Campaign_sk)  references Dim_Campaigns(Campaign_sk),
constraint date_fk foreign key(Created_Date_sk)  references DimDate(DateSK) 
);




-- FACT SALES
CREATE TABLE Fact_Sales (
    Sale_ID INT IDENTITY(1,1) PRIMARY KEY,
    Property_sk INT,
    Customer_sk INT,
    Agent_sk INT,
    Campaign_sk INT,
    Sale_Date_sk INT,
    Sale_Price DECIMAL(15,2),
    Commission_Rate DECIMAL(5,2),
    Commission_Amount DECIMAL(15,2),
    Revenue DECIMAL(15,2),
    Days_to_Sell INT

constraint sales_property_fk foreign key(Property_sk)  references Dim_Property(Property_sk),
constraint sales_customer_fk foreign key(customer_sk)  references Dim_Customers(Customer_sk),
constraint sales_agent_fk foreign key(Agent_sk)  references Dim_Agents(Agent_sk),
constraint sales_campaign_fk foreign key(Campaign_sk)  references Dim_Campaigns(Campaign_sk),
constraint sales_date_fk foreign key(Sale_date_sk)  references DimDate(DateSK) 
);


