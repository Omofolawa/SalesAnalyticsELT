## SalesAnalyticsELT

# Project Overview
The **SalesAnalyticsELT** project is designed to extract raw sales data from a flat file, load it into a staging area in SQL Server, and transform the data to fit into a normalized data model. The key stages of this ETL process include data extraction, transformation, and loading (ELT), and the project leverages SQL Server for data transformations and SSIS for data ingestion.

### Key Features
- **Data Extraction**: Raw sales data is extracted from flat files and loaded into a staging area.
- **Staging Area**: A heap table is used to store the denormalized raw data for further processing.
- **Data Modeling**: Conceptual, logical, and physical data models were created to structure the data. Entities and relationships were identified, and constraints were implemented to ensure data consistency and reduce redundancy.
- **Data Transformation**: The data is normalized into multiple tables using **SQL Common Table Expressions (CTE)** to identify unique records. This transformation ensures the data is structured according to the defined data model.
- **Loading**: SQL Server is used for loading and transforming data into normalized tables.
  
### Technology Stack
- **SQL Server**: Used for data storage, transformation, and loading.
- **SSIS (SQL Server Integration Services)**: Used for ingesting the data from flat files into the database using OLE DB as the destination.

### Workflow
1. **Extract**: Sales data is extracted from flat files and stored in a heap table (denormalized form) in the staging area.
2. **Transform**: The raw data is evaluated, and transformations are applied to normalize it. Common Table Expressions (CTEs) are used to identify unique records during the transformation process.
3. **Load**: The transformed data is loaded into normalized tables following the constraints and relationships defined in the data model.

### Project Goals
- Ensure **data consistency** and **reduce redundancy** in the normalized database.
- Create an efficient **data pipeline** for extracting, transforming, and loading sales data.
- Develop a **robust data model** to support future analytics and reporting needs.

