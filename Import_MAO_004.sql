SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create procedure [dbo].[ImportMAO_004] @path As varChar(128), @filename As varChar(128)
As

Begin
-- Initial Set up of raw data table
/*
Drop Table [dbo].[tbl_MAO_004_In]
Create Table [dbo].[tbl_MAO_004_In] (col001 varchar(max))
*/

Truncate Table [dbo].[tbl_MAO_004_In]
Declare @BulkCmd As nvarChar(MAX)
Set		@BulkCmd = "BULK INSERT tbl_MAO_004_In FROM '"+@path+@filename+"' WITH (FIELDTERMINATOR = '\n')"
Exec	(@BulkCmd)
*/
Declare @today As DateTime 
Set @today=getDate()

-- Header
Insert	Into [dbo].[tbl_MAO_004_Header]
Select	  Cast(SubString(M4.Col001,1,1) As VarChar(1)) As [RecordType]		  		-- 0 = Header	
		, Cast(SubString(M4.Col001,2,1) As VarChar(1)) As [Delimiter01]			-- *
		, Cast(SubString(M4.Col001,3,7) As VarChar(7)) As [ReportID]			-- MAO-004
		, Cast(SubString(M4.Col001,10,1) As VarChar(1)) As [Delimiter02]		-- *
		, Cast(SubString(M4.Col001,11,5) As VarChar(5)) As [MAContractID]		-- 
		, Cast(SubString(M4.Col001,16,1) As VarChar(1)) As [Delimiter03]		-- *
		, Cast(SubString(M4.Col001,17,8) As VarChar(8)) As [ReportDate]			-- CCYYMMDD
		, Cast(SubString(M4.Col001,25,1) As VarChar(1)) As [Delimiter04]		-- *
		, Cast(SubString(M4.Col001,26,53) As VarChar(53)) As [ReportDesc]		-- "Encounter Data Diagnosis Eligible for Risk Adjustment"
		, Cast(SubString(M4.Col001,79,1) As VarChar(1)) As [Delimiter05]		-- *
		, Cast(SubString(M4.Col001,80,30) As VarChar(30)) As [Filler01]			-- Spaces
		, Cast(SubString(M4.Col001,110,1) As VarChar(1)) As [Delimiter06]		-- *
		, Cast(SubString(M4.Col001,111,4) As VarChar(4)) As [SubmissionFileType]	--  PROD or TEST
		, Cast(SubString(M4.Col001,115,1) As VarChar(1)) As [Delimiter07]		-- *
		, Cast(SubString(M4.Col001,116,385) As VarChar(385)) As [Filler02]	    	-- Spaces
		, @today As [DateImported]
		, @filename As [FileName]
From	[dbo].[tbl_MAO_004_In] As M4
Left	Outer Join [dbo].[tbl_MAO_004_Header] As MH
		  On MH.[ReportDate]=SubString(M4.Col001,17,8)
		  And MH.[FileName]=@filename
		  And MH.[DateImported] = @today
Where	SubString(M4.Col001,1,1) = '0'
And		MH.[RecordType] Is Null 

-- Detail
Insert	Into [dbo].[tbl_MAO_004_Detail]
Select	  Cast(SubString(M4.Col001,1,1) As VarChar(1)) As [RecordType]		  		-- 1 = Detail
		, Cast(SubString(M4.Col001,2,1) As VarChar(1)) As [Delimiter01]			-- *
		, Cast(SubString(M4.Col001,3,7) As VarChar(7)) As [ReportID]			-- MAO-004
		, Cast(SubString(M4.Col001,10,1) As VarChar(1)) As [Delimiter02]		-- *
		, Cast(SubString(M4.Col001,11,5) As VarChar(1)) As [MAContractID]		-- 
		, Cast(SubString(M4.Col001,16,1) As VarChar(1)) As [Delimiter03]		-- *
		, Cast(SubString(M4.Col001,17,12) As VarChar(12)) As [BeneficiaryHICN]  	-- Beneficiary Health Insurance Claim Number
		, Cast(SubString(M4.Col001,29,1) As VarChar(1)) As [Delimiter04]		-- *
		, Cast(SubString(M4.Col001,30,44) As VarChar(44)) As [EncounterICN]		-- Encounter Data System (EDS) Internal Control Number (ICN)
									                        -- Note: Currently the ICN is 13 characters long
		, Cast(SubString(M4.Col001,74,1) As VarChar(1)) As [Delimiter05]		-- *
		, Cast(SubString(M4.Col001,75,1) As VarChar(1)) As [EncounterTypeSwitch]	-- See ## Note 1 Below
		, Cast(SubString(M4.Col001,76,1) As VarChar(1)) As [Delimiter06]		-- *
		, Cast(SubString(M4.Col001,77,44) As VarChar(44)) As [OriginalEncounterICN]	-- Encounter Data System (EDS) Internal Control Number (ICN)
												-- See ## Note 2 Below
		, Cast(SubString(M4.Col001,121,1) As VarChar(1)) As [Delimiter07]		-- *
		, Cast(SubString(M4.Col001,122,8) As VarChar(8)) As [PlanSubmissionDate]	-- CCYYMMDD
		, Cast(SubString(M4.Col001,130,1) As VarChar(1)) As [Delimiter08]		-- *
		, Cast(SubString(M4.Col001,131,8) As VarChar(8)) As [ProcessingDate]	  	-- CCYYMMDD
		, Cast(SubString(M4.Col001,139,1) As VarChar(1)) As [Delimiter09]		-- *
		, Cast(SubString(M4.Col001,140,8) As VarChar(8)) As [FromDateOfService] 	-- CCYYMMDD
		, Cast(SubString(M4.Col001,148,1) As VarChar(1)) As [Delimiter10]		-- *
		, Cast(SubString(M4.Col001,149,8) As VarChar(8)) As [ThruDateOfService]		-- CCYYMMDD
		, Cast(SubString(M4.Col001,157,1) As VarChar(1)) As [Delimiter11]		-- *
		, Cast(SubString(M4.Col001,158,1) As VarChar(1)) As [ClaimType]			-- Type of Claim: P = Professional, I = Inpatient, O = Outpatient
		, Cast(SubString(M4.Col001,159,1) As VarChar(1)) As [Delimiter12]		-- *
		, Cast(SubString(M4.Col001,160,7) As VarChar(7)) As [DiagnosisCode]		-- ICD-10 (ICD-9 for pre ICD-10 implementation dates)
		, Cast(SubString(M4.Col001,167,1) As VarChar(1)) As [Delimiter13]		-- *
		, Cast(SubString(M4.Col001,168,1) As VarChar(1)) As [DiagnosisICD]		-- 0 = ICD-10, 9 = ICD-9
		, Cast(SubString(M4.Col001,169,1) As VarChar(1)) As [Delimiter14]		-- *
		, Cast(SubString(M4.Col001,170,1) As VarChar(1)) As [AddOrDeleteFlag]		-- A = Add, D = Delete
												-- See ## Note 3 Below
		, Cast(SubString(M4.Col001,171,1) As VarChar(1)) As [Delimiter15]		-- *
		, Cast(SubString(M4.Col001,172,288) As VarChar(288)) As [DiagnosisCodes]	-- See ## Note 4 Below
		, Cast(SubString(M4.Col001,460,1) As VarChar(1)) As [Filler]			-- Spaces
		, @today As [DateImported]
		, @filename As [FileName]
From	[dbo].[tbl_MAO_004_In] As M4
Left	Outer Join [dbo].[tbl_MAO_004_Detail] As MD
		  On MD.[BeneficiaryHICN]=SubString(M4.Col001,17,12)
		  And MD.[FileName]=@filename
Where	SubString(M4.Col001,1,1) = '1'
And		MD.[RecordType] Is Null 
/*
 ## Note 1. Encounter Type Switch
	1 = Original Encounter
	2 = Void to an Original Encounter
	3 = Replacement to an Original Encounter
	4 = Linked Chart Review
	5 = Void to a Linked Chart Review
	6 = Replacement to a Linked Chart Review
	7 = Unlinked Chart Review
	8 = Void to a Unlinked Chart Review
	9 = Replacement to a Unlinked Chart Review
 ## Note 2. Original Encounter Internal Control Number (ICN)
	This field on an Adjustment or Linked Chart Review record contains the ICN of the encounter data record to which 
	the adjustment or linked chart review record links. It will be blank on Original encounters 
	(and Unlinked Chart Reviews)
 ## Note 3. Add Or Delete Flag
	Original encounters which Add diagnoses, and Replacements that effectively Add or Delete diagnoses, shall be 
	flagged with A or D accordingly. Replacements that have no effect on the diagnoses submitted in the Original 
	encounter are not reported again in the MAO-004 report in the submission month of the Replacement, as the 
	diagnoses in the Original submission stand as originally submitted
 ## Note 4. Diagnosis Codes
	This field represents up to 11 (for Professional) or up to 24 (for Institutional) occurrences of the diagnosis 
	codes along with the corresponding Diagnosis ICD and Add or Delete flag (field #25-30 values)
*/

-- Trailer
Insert	Into [dbo].[tbl_MAO_004_Trailer]
Select	  Cast(SubString(M4.Col001,1,1) As VarChar(1)) As [RecordType]		  		-- 9 = Trailer
		, Cast(SubString(M4.Col001,2,1) As VarChar(1)) As [Delimiter01]			-- *
		, Cast(SubString(M4.Col001,3,7) As VarChar(7)) As [ReportID]            	-- MAO-004
		, Cast(SubString(M4.Col001,10,1) As VarChar(1)) As [Delimiter02]		-- *
		, Cast(SubString(M4.Col001,11,5) As VarChar(1)) As [MAContractID]       	-- 
		, Cast(SubString(M4.Col001,16,1) As VarChar(1)) As [Delimiter03]		-- *
		, Cast(SubString(M4.Col001,17,18) As VarChar(18)) As [TotalNumberOfRecords]	--
		, Cast(SubString(M4.Col001,35,1) As VarChar(1)) As [Delimiter04]		-- *
		, Cast(SubString(M4.Col001,36,465) As VarChar(465)) As [Filler]			-- Spaces
		, @today As [DateImported]
		, @filename As [FileName]
From	[dbo].[tbl_MAO_004_In] As M4
Left	Outer Join [dbo].[tbl_MAO_004_Trailer] As MT
		  On MT.[DateImported] = @today
		  And MT.[FileName] = @filename
Where	SubString(M4.Col001,1,1) = '9'
And		MT.[RecordType] Is Null
