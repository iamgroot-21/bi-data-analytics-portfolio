-- Healthcare Analytics Database Schema
-- Created by: Ayush Man Shrestha
-- Date: 2024
-- Purpose: Power BI Healthcare Analytics Dashboard

USE HealthcareDB;
GO

-- =============================================
-- DIMENSION TABLES
-- =============================================

-- Patients Dimension
CREATE TABLE Dim_Patients (
    PatientID INT PRIMARY KEY,
    PatientKey INT IDENTITY(1,1),
    PatientName NVARCHAR(100),
    DateOfBirth DATE,
    Gender NVARCHAR(10),
    Address NVARCHAR(200),
    City NVARCHAR(50),
    State NVARCHAR(2),
    ZipCode NVARCHAR(10),
    Phone NVARCHAR(15),
    Email NVARCHAR(100),
    InsuranceType NVARCHAR(50),
    InsuranceProvider NVARCHAR(100),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE()
);

-- Providers Dimension
CREATE TABLE Dim_Providers (
    ProviderID INT PRIMARY KEY,
    ProviderKey INT IDENTITY(1,1),
    ProviderName NVARCHAR(100),
    Specialty NVARCHAR(100),
    Department NVARCHAR(100),
    LicenseNumber NVARCHAR(50),
    Phone NVARCHAR(15),
    Email NVARCHAR(100),
    HireDate DATE,
    Status NVARCHAR(20),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE()
);

-- Departments Dimension
CREATE TABLE Dim_Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentKey INT IDENTITY(1,1),
    DepartmentName NVARCHAR(100),
    DepartmentCode NVARCHAR(10),
    ManagerName NVARCHAR(100),
    Budget DECIMAL(15,2),
    FloorNumber INT,
    BedCount INT,
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE()
);

-- Diagnosis Codes Dimension
CREATE TABLE Dim_DiagnosisCodes (
    DiagnosisID INT PRIMARY KEY,
    DiagnosisKey INT IDENTITY(1,1),
    ICD10Code NVARCHAR(10),
    DiagnosisDescription NVARCHAR(200),
    Category NVARCHAR(100),
    SeverityLevel NVARCHAR(20),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE()
);

-- Insurance Plans Dimension
CREATE TABLE Dim_InsurancePlans (
    InsuranceID INT PRIMARY KEY,
    InsuranceKey INT IDENTITY(1,1),
    PlanName NVARCHAR(100),
    InsuranceProvider NVARCHAR(100),
    PlanType NVARCHAR(50),
    CoveragePercentage DECIMAL(5,2),
    Deductible DECIMAL(10,2),
    Copay DECIMAL(8,2),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE()
);

-- Date Calendar Dimension
CREATE TABLE Dim_DateCalendar (
    DateKey INT PRIMARY KEY,
    FullDate DATE,
    DayOfWeek NVARCHAR(10),
    DayOfMonth INT,
    MonthName NVARCHAR(10),
    MonthNumber INT,
    Quarter INT,
    Year INT,
    IsWeekend BIT,
    IsHoliday BIT,
    FiscalYear INT,
    FiscalQuarter INT
);

-- =============================================
-- FACT TABLES
-- =============================================

-- Patient Admissions Fact Table
CREATE TABLE Fact_PatientAdmissions (
    AdmissionID INT PRIMARY KEY,
    PatientKey INT,
    ProviderKey INT,
    DepartmentKey INT,
    DiagnosisKey INT,
    InsuranceKey INT,
    DateKey INT,
    AdmissionDate DATETIME,
    DischargeDate DATETIME,
    LengthOfStayDays INT,
    ReadmissionFlag NVARCHAR(3),
    ReadmissionDays INT,
    SeverityLevel NVARCHAR(20),
    AdmissionType NVARCHAR(50),
    DischargeDisposition NVARCHAR(100),
    CreatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (PatientKey) REFERENCES Dim_Patients(PatientKey),
    FOREIGN KEY (ProviderKey) REFERENCES Dim_Providers(ProviderKey),
    FOREIGN KEY (DepartmentKey) REFERENCES Dim_Departments(DepartmentKey),
    FOREIGN KEY (DiagnosisKey) REFERENCES Dim_DiagnosisCodes(DiagnosisKey),
    FOREIGN KEY (InsuranceKey) REFERENCES Dim_InsurancePlans(InsuranceKey),
    FOREIGN KEY (DateKey) REFERENCES Dim_DateCalendar(DateKey)
);

-- Financial Transactions Fact Table
CREATE TABLE Fact_FinancialTransactions (
    TransactionID INT PRIMARY KEY,
    PatientKey INT,
    DepartmentKey INT,
    DateKey INT,
    TransactionDate DATETIME,
    TransactionType NVARCHAR(50),
    RevenueAmount DECIMAL(15,2),
    CostAmount DECIMAL(15,2),
    ProfitAmount DECIMAL(15,2),
    InsurancePayment DECIMAL(15,2),
    PatientPayment DECIMAL(15,2),
    ServiceCode NVARCHAR(20),
    ServiceDescription NVARCHAR(200),
    CreatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (PatientKey) REFERENCES Dim_Patients(PatientKey),
    FOREIGN KEY (DepartmentKey) REFERENCES Dim_Departments(DepartmentKey),
    FOREIGN KEY (DateKey) REFERENCES Dim_DateCalendar(DateKey)
);

-- Quality Metrics Fact Table
CREATE TABLE Fact_QualityMetrics (
    QualityID INT PRIMARY KEY,
    DepartmentKey INT,
    DateKey INT,
    MetricDate DATE,
    MetricType NVARCHAR(50),
    MetricValue DECIMAL(10,2),
    TargetValue DECIMAL(10,2),
    Status NVARCHAR(20),
    Notes NVARCHAR(500),
    CreatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (DepartmentKey) REFERENCES Dim_Departments(DepartmentKey),
    FOREIGN KEY (DateKey) REFERENCES Dim_DateCalendar(DateKey)
);

-- Operational Events Fact Table
CREATE TABLE Fact_OperationalEvents (
    EventID INT PRIMARY KEY,
    DepartmentKey INT,
    DateKey INT,
    EventDate DATETIME,
    EventType NVARCHAR(50),
    EventDescription NVARCHAR(200),
    DurationMinutes INT,
    ImpactLevel NVARCHAR(20),
    ResolutionTime INT,
    CreatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (DepartmentKey) REFERENCES Dim_Departments(DepartmentKey),
    FOREIGN KEY (DateKey) REFERENCES Dim_DateCalendar(DateKey)
);

-- =============================================
-- INDEXES FOR PERFORMANCE
-- =============================================

-- Fact table indexes
CREATE INDEX IX_Fact_Admissions_DateKey ON Fact_PatientAdmissions(DateKey);
CREATE INDEX IX_Fact_Admissions_PatientKey ON Fact_PatientAdmissions(PatientKey);
CREATE INDEX IX_Fact_Admissions_DepartmentKey ON Fact_PatientAdmissions(DepartmentKey);

CREATE INDEX IX_Fact_Financial_DateKey ON Fact_FinancialTransactions(DateKey);
CREATE INDEX IX_Fact_Financial_PatientKey ON Fact_FinancialTransactions(PatientKey);
CREATE INDEX IX_Fact_Financial_DepartmentKey ON Fact_FinancialTransactions(DepartmentKey);

CREATE INDEX IX_Fact_Quality_DateKey ON Fact_QualityMetrics(DateKey);
CREATE INDEX IX_Fact_Quality_DepartmentKey ON Fact_QualityMetrics(DepartmentKey);

CREATE INDEX IX_Fact_Operational_DateKey ON Fact_OperationalEvents(DateKey);
CREATE INDEX IX_Fact_Operational_DepartmentKey ON Fact_OperationalEvents(DepartmentKey);

-- Dimension table indexes
CREATE INDEX IX_Dim_Patients_InsuranceType ON Dim_Patients(InsuranceType);
CREATE INDEX IX_Dim_Providers_Specialty ON Dim_Providers(Specialty);
CREATE INDEX IX_Dim_Departments_DepartmentCode ON Dim_Departments(DepartmentCode);
CREATE INDEX IX_Dim_Diagnosis_Category ON Dim_DiagnosisCodes(Category);

-- =============================================
-- VIEWS FOR POWER BI
-- =============================================

-- Patient Admissions View
CREATE VIEW vw_PatientAdmissions AS
SELECT 
    pa.AdmissionID,
    p.PatientName,
    p.Gender,
    p.InsuranceType,
    pr.ProviderName,
    pr.Specialty,
    d.DepartmentName,
    dc.DiagnosisDescription,
    dc.Category,
    ip.PlanName,
    dc.FullDate,
    pa.AdmissionDate,
    pa.DischargeDate,
    pa.LengthOfStayDays,
    pa.ReadmissionFlag,
    pa.SeverityLevel,
    pa.AdmissionType,
    pa.DischargeDisposition
FROM Fact_PatientAdmissions pa
JOIN Dim_Patients p ON pa.PatientKey = p.PatientKey
JOIN Dim_Providers pr ON pa.ProviderKey = pr.ProviderKey
JOIN Dim_Departments d ON pa.DepartmentKey = d.DepartmentKey
JOIN Dim_DiagnosisCodes dc ON pa.DiagnosisKey = dc.DiagnosisKey
JOIN Dim_InsurancePlans ip ON pa.InsuranceKey = ip.InsuranceKey
JOIN Dim_DateCalendar dc ON pa.DateKey = dc.DateKey;

-- Financial Summary View
CREATE VIEW vw_FinancialSummary AS
SELECT 
    dc.FullDate,
    dc.MonthName,
    dc.Year,
    d.DepartmentName,
    SUM(ft.RevenueAmount) AS TotalRevenue,
    SUM(ft.CostAmount) AS TotalCost,
    SUM(ft.ProfitAmount) AS TotalProfit,
    COUNT(DISTINCT ft.PatientKey) AS PatientCount,
    AVG(ft.RevenueAmount) AS AvgRevenuePerPatient
FROM Fact_FinancialTransactions ft
JOIN Dim_Departments d ON ft.DepartmentKey = d.DepartmentKey
JOIN Dim_DateCalendar dc ON ft.DateKey = dc.DateKey
GROUP BY dc.FullDate, dc.MonthName, dc.Year, d.DepartmentName;

-- Quality Metrics View
CREATE VIEW vw_QualityMetrics AS
SELECT 
    dc.FullDate,
    dc.MonthName,
    dc.Year,
    d.DepartmentName,
    qm.MetricType,
    qm.MetricValue,
    qm.TargetValue,
    qm.Status,
    qm.Notes
FROM Fact_QualityMetrics qm
JOIN Dim_Departments d ON qm.DepartmentKey = d.DepartmentKey
JOIN Dim_DateCalendar dc ON qm.DateKey = dc.DateKey;

-- =============================================
-- STORED PROCEDURES
-- =============================================

-- Get Patient Analytics
CREATE PROCEDURE sp_GetPatientAnalytics
    @StartDate DATE,
    @EndDate DATE,
    @DepartmentID INT = NULL
AS
BEGIN
    SELECT 
        p.Gender,
        p.InsuranceType,
        d.DepartmentName,
        dc.Category,
        COUNT(*) AS AdmissionCount,
        AVG(pa.LengthOfStayDays) AS AvgLengthOfStay,
        SUM(CASE WHEN pa.ReadmissionFlag = 'Yes' THEN 1 ELSE 0 END) AS ReadmissionCount
    FROM Fact_PatientAdmissions pa
    JOIN Dim_Patients p ON pa.PatientKey = p.PatientKey
    JOIN Dim_Departments d ON pa.DepartmentKey = d.DepartmentKey
    JOIN Dim_DiagnosisCodes dc ON pa.DiagnosisKey = dc.DiagnosisKey
    WHERE pa.AdmissionDate BETWEEN @StartDate AND @EndDate
        AND (@DepartmentID IS NULL OR d.DepartmentID = @DepartmentID)
    GROUP BY p.Gender, p.InsuranceType, d.DepartmentName, dc.Category
    ORDER BY AdmissionCount DESC;
END;

-- Get Financial Performance
CREATE PROCEDURE sp_GetFinancialPerformance
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        d.DepartmentName,
        dc.MonthName,
        dc.Year,
        SUM(ft.RevenueAmount) AS TotalRevenue,
        SUM(ft.CostAmount) AS TotalCost,
        SUM(ft.ProfitAmount) AS TotalProfit,
        (SUM(ft.ProfitAmount) / SUM(ft.RevenueAmount)) * 100 AS ProfitMargin
    FROM Fact_FinancialTransactions ft
    JOIN Dim_Departments d ON ft.DepartmentKey = d.DepartmentKey
    JOIN Dim_DateCalendar dc ON ft.DateKey = dc.DateKey
    WHERE dc.FullDate BETWEEN @StartDate AND @EndDate
    GROUP BY d.DepartmentName, dc.MonthName, dc.Year
    ORDER BY dc.Year, dc.MonthName, TotalRevenue DESC;
END;

-- =============================================
-- ROW-LEVEL SECURITY
-- =============================================

-- Create security function
CREATE FUNCTION fn_DepartmentSecurity(@DepartmentID INT)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN
SELECT 1 AS AccessGranted
WHERE @DepartmentID = CAST(SESSION_CONTEXT(N'DepartmentID') AS INT)
   OR CAST(SESSION_CONTEXT(N'Role') AS NVARCHAR(50)) = 'Admin';

-- Apply RLS to fact tables
ALTER TABLE Fact_PatientAdmissions ADD CONSTRAINT CK_DepartmentSecurity_Admissions
CHECK (fn_DepartmentSecurity(DepartmentKey) = 1);

ALTER TABLE Fact_FinancialTransactions ADD CONSTRAINT CK_DepartmentSecurity_Financial
CHECK (fn_DepartmentSecurity(DepartmentKey) = 1);

-- =============================================
-- SAMPLE DATA INSERTION (Basic Structure)
-- =============================================

-- Note: In a real implementation, you would populate these tables with actual data
-- This is a template for data insertion

-- Insert sample departments
INSERT INTO Dim_Departments (DepartmentID, DepartmentName, DepartmentCode, ManagerName, Budget, FloorNumber, BedCount)
VALUES 
(1, 'Emergency Medicine', 'EM', 'Dr. Sarah Johnson', 2500000.00, 1, 25),
(2, 'Cardiology', 'CARD', 'Dr. Michael Chen', 1800000.00, 2, 20),
(3, 'Orthopedics', 'ORTHO', 'Dr. Robert Wilson', 1200000.00, 3, 15),
(4, 'Pediatrics', 'PED', 'Dr. Lisa Martinez', 900000.00, 4, 18),
(5, 'Intensive Care Unit', 'ICU', 'Dr. David Thompson', 3000000.00, 2, 12);

-- Insert sample diagnosis codes
INSERT INTO Dim_DiagnosisCodes (DiagnosisID, ICD10Code, DiagnosisDescription, Category, SeverityLevel)
VALUES 
(1, 'I21.9', 'Acute myocardial infarction', 'Cardiovascular', 'High'),
(2, 'S72.001A', 'Fracture of unspecified part of femur', 'Orthopedic', 'Medium'),
(3, 'J44.9', 'Chronic obstructive pulmonary disease', 'Respiratory', 'Medium'),
(4, 'E11.9', 'Type 2 diabetes mellitus', 'Endocrine', 'Low'),
(5, 'I63.9', 'Cerebral infarction', 'Neurological', 'High');

-- Insert sample insurance plans
INSERT INTO Dim_InsurancePlans (InsuranceID, PlanName, InsuranceProvider, PlanType, CoveragePercentage, Deductible, Copay)
VALUES 
(1, 'Premium Health Plan', 'Blue Cross Blue Shield', 'PPO', 90.00, 500.00, 25.00),
(2, 'Standard Health Plan', 'Aetna', 'HMO', 80.00, 1000.00, 35.00),
(3, 'Basic Health Plan', 'Cigna', 'EPO', 70.00, 2000.00, 50.00),
(4, 'Medicare Advantage', 'UnitedHealth', 'Medicare', 85.00, 0.00, 20.00),
(5, 'Medicaid Plan', 'State Health', 'Medicaid', 100.00, 0.00, 0.00);

PRINT 'Healthcare Analytics Database Schema created successfully!';
PRINT 'Tables, indexes, views, and stored procedures are ready for Power BI connection.'; 