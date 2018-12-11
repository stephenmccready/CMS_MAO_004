CREATE TABLE MAO_004_HDR (
	RecordType			varchar(1)		-- 0 = Header
,	Delimiter01			varchar(1)		-- *
,	ReportID			varchar(7)		-- MAO-004
,	Delimiter02			varchar(1)		-- *
,	MAContractID			varchar(5)		-- 
,	Delimiter03			varchar(1)		-- *
,	ReportDate			varchar(8)		-- CCYYMMDD
,	Delimiter04			varchar(1)		-- *
,	ReportDesc			varchar(53)		-- "Encounter Data Diagnosis Eligible for Risk Adjustment"
,	Delimiter05			varchar(1)		-- *
,	Filler01			varchar(30)		-- Spaces
,	Delimiter06			varchar(1)		-- *
,	SubmissionFileType		varchar(4)		-- PROD or TEST
,	Delimiter07			varchar(1)		-- *
,	Filler02			varchar(385)		-- Spaces
,	DateImported			dateTime		-- 
,	FileName			varchar(256)		-- path + filename
)

CREATE TABLE MAO_004_DTL (
	RecordType			varchar(1)		-- 1 = Detail
,	Delimiter01			varchar(1)		-- *
,	ReportID			varchar(7)		-- MAO-004
,	Delimiter02			varchar(1)		-- *
,	MAContractID			varchar(5)		-- 
,	Delimiter03			varchar(1)		-- *
,	BeneficiaryHICN			varchar(12)		-- Beneficiary Health Insurance Claim Number
,	Delimiter04			varchar(1)		-- *
,	EncounterICN			varchar(44)		-- Encounter Data System (EDS) Internal Control Number (ICN)
								-- Note: Currently the ICN is 13 characters long
,	Delimiter05			varchar(1)		-- *
,	EncounterTypeSwitch		varchar(1)		-- See ## Note 1 Below
,	Delimiter06			varchar(1)		-- *
,	OriginalEncounterICN 		varchar(44)		-- Encounter Data System (EDS) Internal Control Number (ICN)
								-- See ## Note 2 Below
,	Delimiter07			varchar(1)		-- *
,	PlanSubmissionDate		varchar(8)		-- CCYYMMDD
,	Delimiter08			varchar(1)		-- *
,	ProcessingDate			varchar(8)		-- CCYYMMDD
,	Delimiter09			varchar(1)		-- *
,	FromDateOfService		varchar(8)		-- CCYYMMDD
,	Delimiter10			varchar(1)		-- *
,	ThruDateOfService		varchar(8)		-- CCYYMMDD
,	Delimiter11			varchar(1)		-- *
,	ClaimType			varchar(1)		-- Type of Claim: P = Professional, I = Inpatient, O = Outpatient
,	Delimiter12			varchar(1)		-- *
,	DiagnosisCode			varchar(7)		-- ICD-10 (ICD-9 for pre ICD-10 implementation dates)
,	Delimiter13			varchar(1)		-- *
,	DiagnosisICD			varchar(1)		-- 0 = ICD-10, 9 = ICD-9
,	Delimiter14			varchar(1)		-- *
,	AddOrDeleteFlag			varchar(1)		-- A = Add, D = Delete
								-- See ## Note 3 Below
,	Delimiter15			varchar(1)		-- *
,	DiagnosisCodes			varchar(288)		-- See ## Note 4 Below
,	Filler				varchar(41)	  	-- 
,	DateImported			dateTime		-- 
,	FileName			varchar(256)		-- path + filename
)
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

CREATE TABLE MAO_004_TL (
	RecordType			varchar(1)		-- 9 = Trailer
,	Delimiter01			varchar(1)		-- *
,	ReportID			varchar(7)		-- MAO-004
,	Delimiter02			varchar(1)		-- *
,	MAContractID			varchar(5)		-- 
,	Delimiter03			varchar(1)		-- *
,	TotalNumberOfRecords 		varchar(18)		-- Count of records on this report
,	Delimiter04			varchar(1)		-- *
,	Filler				varchar(465)		-- Spaces
,	DateImported			dateTime		-- 
,	FileName			varchar(256)		-- path + filename
)
