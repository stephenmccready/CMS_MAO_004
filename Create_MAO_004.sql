IF OBJECT_ID('dbo.MAO004_HDR') IS NOT NULL Drop Table dbo.MAO004_HDR
CREATE TABLE dbo.MAO004_HDR (
	RecordType			varchar(1)		-- 0 = Header
,	Delimiter01			varchar(1)		-- *
,	ReportID			varchar(7)		-- MAO-004
,	Delimiter02			varchar(1)		-- *
,	MAContractID		varchar(5)		-- 
,	Delimiter03			varchar(1)		-- *
,	ReportDate			varchar(8)		-- CCYYMMDD
,	Delimiter04			varchar(1)		-- *
,	ReportDesc			varchar(53)		-- "Encounter Data Diagnosis Eligible for Risk Adjustment"
,	Delimiter05			varchar(1)		-- *
,	Filler01			varchar(30)		-- Spaces
,	Delimiter06			varchar(1)		-- *
,	SubmissionFileType	varchar(4)		-- PROD or TEST
,	Delimiter07			varchar(1)		-- *
,	Phase				varchar(1)		-- Alphanumeric
,	Delimiter08			varchar(1)		-- *
,	[Version]			varchar(1)		-- Alphanumeric
,	Delimiter09			varchar(1)		-- *
,	Filler02			varchar(381)	-- Spaces
,	DateImported		dateTime		-- 
,	[FileName]			varchar(256)	-- path + filename
)

IF OBJECT_ID('dbo.MAO004_DTL') IS NOT NULL Drop Table dbo.MAO004_DTL
CREATE TABLE dbo.MAO004_DTL (
	RecordType			varchar(1)		-- 1 = Detail
,	Delimiter01			varchar(1)		-- *
,	ReportID			varchar(7)		-- MAO-004
,	Delimiter02			varchar(1)		-- *
,	MAContractID		varchar(5)		-- Medicare Advantage Contract ID
,	Delimiter03			varchar(1)		-- *
,	BeneficiaryHICN		varchar(12)		-- Beneficiary Health Insurance Claim Number
,	Delimiter04			varchar(1)		-- *
,	EncounterICN		varchar(20)		-- Encounter Data System (EDS) Internal Control Number (ICN)
										-- Note: Currently the ICN is 13 characters long
,	Delimiter05			varchar(1)		-- *
,	EncounterTypeSwitch	varchar(1)		-- See ## Note 1 Below
,	Delimiter06			varchar(1)		-- *
,	LinkEncounterICN	varchar(20)		-- Encounter Data System (EDS) Internal Control Number (ICN)
										-- See ## Note 2 Below
,	Delimiter07			varchar(1)		-- *
,	LinkEncAllowStatus	varchar(1)		-- Allowed/ Disallowed Status of Encounter Linked To
										-- See ## Note 3 Below
,	Delimiter08			varchar(1)		-- *
,	EncounterSubmissionDate	varchar(8)	-- CCYYMMDD
,	Delimiter09			varchar(1)		-- *
,	FromDateOfService	varchar(8)		-- CCYYMMDD
,	Delimiter10			varchar(1)		-- *
,	ThruDateOfService	varchar(8)		-- CCYYMMDD
,	Delimiter11			varchar(1)		-- *
,	ServiceType			varchar(1)		-- Type of Claim: P=Professional, I=Inpatient, O=Outpatient, D=DMV, N=(AllOthers) Not Applicable
,	Delimiter12			varchar(1)		-- *

,	AllowedDisallowedFlag varchar(1)	-- This field indicates if diagnoses on the current encounter data record are allowed or disallowed for risk
										-- adjustment.
										-- ‘A’ = Diagnoses are allowed for risk adjustment.
										-- ‘D’ = Diagnoses are disallowed for risk adjustment.
										--		 Note: Non voids and non-chart review deletes with Service Type designated with ‘N’ will be ‘D’.
										-- Blank = All Voids and chart review deletes,regardless of the service type, since allowed and disallowed status do not apply
,	Delimiter13			varchar(1)		-- *
,	AllowedDisallowedReasonCode varchar(1)	-- See ## Note 4 Below
,	Delimiter14			varchar(1)		-- *
,	DiagnosisICD		varchar(1)		-- 0 = ICD-10, 9 = ICD-9
,	Delimiter15			varchar(1)		-- *
,	Diagnosis01			varchar(7)		-- ICD-10 (ICD-9 for pre ICD-10 implementation dates)
,	Delimiter16			varchar(1)		-- *
,	AddOrDeleteFlag01	varchar(1)		-- A = Add, D = Delete
										-- See ## Note 5 Below
,	Delimiter17			varchar(1)		-- *
,	Diagnosis02			varchar(7)
,	DelimiterD02		varchar(1)		-- *
,	AddOrDeleteFlag02	varchar(1)
,	DelimiterF02		varchar(1)		-- *
,	Diagnosis03			varchar(7)
,	DelimiterD03		varchar(1)		-- *
,	AddOrDeleteFlag03	varchar(1)
,	DelimiterF03		varchar(1)		-- *
,	Diagnosis04			varchar(7)
,	DelimiterD04		varchar(1)		-- *
,	AddOrDeleteFlag04	varchar(1)
,	DelimiterF04		varchar(1)		-- *
,	Diagnosis05			varchar(7)
,	DelimiterD05		varchar(1)		-- *
,	AddOrDeleteFlag05	varchar(1)
,	DelimiterF05		varchar(1)		-- *
,	Diagnosis06			varchar(7)
,	DelimiterD06		varchar(1)		-- *
,	AddOrDeleteFlag06	varchar(1)
,	DelimiterF06		varchar(1)		-- *
,	Diagnosis07			varchar(7)
,	DelimiterD07		varchar(1)		-- *
,	AddOrDeleteFlag07	varchar(1)
,	DelimiterF07		varchar(1)		-- *
,	Diagnosis08			varchar(7)
,	DelimiterD08		varchar(1)		-- *
,	AddOrDeleteFlag08	varchar(1)
,	DelimiterF08		varchar(1)		-- *
,	Diagnosis09			varchar(7)
,	DelimiterD09		varchar(1)		-- *
,	AddOrDeleteFlag09	varchar(1)
,	DelimiterF09		varchar(1)		-- *
,	Diagnosis10			varchar(7)
,	DelimiterD10		varchar(1)		-- *
,	AddOrDeleteFlag10	varchar(1)
,	DelimiterF10		varchar(1)		-- *
,	Diagnosis11			varchar(7)
,	DelimiterD11		varchar(1)		-- *
,	AddOrDeleteFlag11	varchar(1)
,	DelimiterF11		varchar(1)		-- *
,	Diagnosis12			varchar(7)
,	DelimiterD12		varchar(1)		-- *
,	AddOrDeleteFlag12	varchar(1)
,	DelimiterF12		varchar(1)		-- *
,	Diagnosis13			varchar(7)
,	DelimiterD13		varchar(1)		-- *
,	AddOrDeleteFlag13	varchar(1)
,	DelimiterF13		varchar(1)		-- *
,	Diagnosis14			varchar(7)
,	DelimiterD14		varchar(1)		-- *
,	AddOrDeleteFlag14	varchar(1)
,	DelimiterF14		varchar(1)		-- *
,	Diagnosis15			varchar(7)
,	DelimiterD15		varchar(1)		-- *
,	AddOrDeleteFlag15	varchar(1)
,	DelimiterF15		varchar(1)		-- *
,	Diagnosis16			varchar(7)
,	DelimiterD16		varchar(1)		-- *
,	AddOrDeleteFlag16	varchar(1)
,	DelimiterF16		varchar(1)		-- *
,	Diagnosis17			varchar(7)
,	DelimiterD17		varchar(1)		-- *
,	AddOrDeleteFlag17	varchar(1)
,	DelimiterF17		varchar(1)		-- *
,	Diagnosis18			varchar(7)
,	DelimiterD18		varchar(1)		-- *
,	AddOrDeleteFlag18	varchar(1)
,	DelimiterF18		varchar(1)		-- *
,	Diagnosis19			varchar(7)
,	DelimiterD19		varchar(1)		-- *
,	AddOrDeleteFlag19	varchar(1)
,	DelimiterF19		varchar(1)		-- *
,	Diagnosis20			varchar(7)
,	DelimiterD20		varchar(1)		-- *
,	AddOrDeleteFlag20	varchar(1)
,	DelimiterF20		varchar(1)		-- *
,	Diagnosis21			varchar(7)
,	DelimiterD21		varchar(1)		-- *
,	AddOrDeleteFlag21	varchar(1)
,	DelimiterF21		varchar(1)		-- *
,	Diagnosis22			varchar(7)
,	DelimiterD22		varchar(1)		-- *
,	AddOrDeleteFlag22	varchar(1)
,	DelimiterF22		varchar(1)		-- *
,	Diagnosis23			varchar(7)
,	DelimiterD23		varchar(1)		-- *
,	AddOrDeleteFlag23	varchar(1)
,	DelimiterF23		varchar(1)		-- *
,	Diagnosis24			varchar(7)
,	DelimiterD24		varchar(1)		-- *
,	AddOrDeleteFlag24	varchar(1)
,	DelimiterF24		varchar(1)		-- *
,	Diagnosis25			varchar(7)
,	DelimiterD25		varchar(1)		-- *
,	AddOrDeleteFlag25	varchar(1)
,	DelimiterF25		varchar(1)		-- *
,	Diagnosis26			varchar(7)
,	DelimiterD26		varchar(1)		-- *
,	AddOrDeleteFlag26	varchar(1)
,	DelimiterF26		varchar(1)		-- *
,	Diagnosis27			varchar(7)
,	DelimiterD27		varchar(1)		-- *
,	AddOrDeleteFlag27	varchar(1)
,	DelimiterF27		varchar(1)		-- *
,	Diagnosis28			varchar(7)
,	DelimiterD28		varchar(1)		-- *
,	AddOrDeleteFlag28	varchar(1)
,	DelimiterF28		varchar(1)		-- *
,	Diagnosis29			varchar(7)
,	DelimiterD29		varchar(1)		-- *
,	AddOrDeleteFlag29	varchar(1)
,	DelimiterF29		varchar(1)		-- *
,	Diagnosis30			varchar(7)
,	DelimiterD30		varchar(1)		-- *
,	AddOrDeleteFlag30	varchar(1)
,	DelimiterF30		varchar(1)		-- *
,	Diagnosis31			varchar(7)
,	DelimiterD31		varchar(1)		-- *
,	AddOrDeleteFlag31	varchar(1)
,	DelimiterF31		varchar(1)		-- *
,	Diagnosis32			varchar(7)
,	DelimiterD32		varchar(1)		-- *
,	AddOrDeleteFlag32	varchar(1)
,	DelimiterF32		varchar(1)		-- *
,	Diagnosis33			varchar(7)
,	DelimiterD33		varchar(1)		-- *
,	AddOrDeleteFlag33	varchar(1)
,	DelimiterF33		varchar(1)		-- *
,	Diagnosis34			varchar(7)
,	DelimiterD34		varchar(1)		-- *
,	AddOrDeleteFlag34	varchar(1)
,	DelimiterF34		varchar(1)		-- *
,	Diagnosis35			varchar(7)
,	DelimiterD35		varchar(1)		-- *
,	AddOrDeleteFlag35	varchar(1)
,	DelimiterF35		varchar(1)		-- *
,	Diagnosis36			varchar(7)
,	DelimiterD36		varchar(1)		-- *
,	AddOrDeleteFlag36	varchar(1)
,	DelimiterF36		varchar(1)		-- *
,	Diagnosis37			varchar(7)
,	DelimiterD37		varchar(1)		-- *
,	AddOrDeleteFlag37	varchar(1)
,	DelimiterF37		varchar(1)		-- *
,	Diagnosis38			varchar(7)
,	DelimiterD38		varchar(1)		-- *
,	AddOrDeleteFlag38	varchar(1)
,	DelimiterF38		varchar(1)		-- *
,	Filler				varchar(10)	  	-- 
,	DateImported		dateTime		-- 
,	[FileName]			varchar(256)	-- path + filename
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
	This field reports the ICN of the record an adjustment, void, linked chart review add, or linked chart review delete is linked to. 
	It will be blank for original encounters and unlinked chart reviews.
 ## Note 3. This field indicates if the diagnoses on the encounter data record or chart review record that is 
	referenced in the original ICN were allowed or disallowed for risk	adjustment.
		‘A’ = Diagnoses on previous record were allowed.
		‘D’ = Diagnoses on previous record were disallowed.
		Blank = (1) if the current record is an original encounter data record, or 
				(2) if the current record is an unlinked chart review record and no record is referenced in 
					the original ICN, or 
				(3) if the record is a linked chart review with an invalid ICN in the original ICN, or 
				(4) if the diagnoses on the record whose original ICN did not pass the filtering logic and were 
				    not previously reported on a MAO-004 report.
 ## Note 4. Allowed/Disallowed Reason Code
 If applicable, this field will indicate why diagnoses on the current record are disallowed, or will indicate that diagnoses which previously did not pass the CMS filtering logic are now allowed based on an updated CPT/HCPCS list. 
	‘H’ = CPT/HCPCS code is not acceptable for risk adjustment. This value is applicable to only outpatient and professional encounters, not to inpatient encounters. 
	‘T’= Type of Bill is not acceptable for risk adjustment. This value is applicable to only outpatient and inpatient encounters, not to professional encounters. 
	‘Q’ = the diagnoses on the current encounter are now allowed due to CPT/HCPCS quarterly update. This value is only applicable to reprocessed outpatient and professional encounters, not to inpatient encounters. 
	Blank = the diagnoses on the current record have passed CMS filtering criteria and are allowed. 
			If the diagnoses on the record is disallowed for both type of bill and CPT/HCPCS code, reason code 'T' will be reported. 
			This is only applicable to outpatient encounters. 
	‘D’ = for diagnoses on EDRs and CRRs that were submitted and accepted after the riskadjustment deadline for the relevant payment year. 
	‘N’ = for all other EDRs and CRRs that are not Inpatient, Outpatient, Professional or DME 
	Note: The risk adjustment deadline will take precedence over TOB and HCPCS disallowed reason codes. 
		If the cutoff date is missed, it doesn't matter whether a record has CPT/HCPCS (Prof & Outpatient) or TOB (Inpatient or Outpatient) since it is 
		disallowed due to the risk adjustment deadline. ‘D’ = (Deadline Date) > T (Type of Bill) > H (CPT/HCPCS) 
 ## Note 5. Add Or Delete Flag
	Original encounters which Add diagnoses, and Replacements that effectively Add or Delete diagnoses, shall be 
	flagged with A or D accordingly. Replacements that have no effect on the diagnoses submitted in the Original 
	encounter are not reported again in the MAO-004 report in the submission month of the Replacement, as the 
	diagnoses in the Original submission stand as originally submitted
 ## Note 6. Diagnosis Codes
	This field represents up to 11 (for Professional) or up to 24 (for Institutional) occurrences of the diagnosis 
	codes along with the corresponding Diagnosis ICD and Add or Delete flag (field #25-30 values)
*/

IF OBJECT_ID('dbo.MAO004_TRL') IS NOT NULL Drop Table dbo.MAO004_TRL
CREATE TABLE dbo.MAO004_TRL (
	RecordType			varchar(1)		-- 9 = Trailer
,	Delimiter01			varchar(1)		-- *
,	ReportID			varchar(7)		-- MAO-004
,	Delimiter02			varchar(1)		-- *
,	MAContractID		varchar(5)		-- Medicare Advantage Contract ID
,	Delimiter03			varchar(1)		-- *
,	TotalNumberOfRecords varchar(18)	-- Count of records on this report
,	Delimiter04			varchar(1)		-- *
,	Filler				varchar(465)	-- Spaces
,	DateImported		dateTime		-- 
,	[FileName]			varchar(256)	-- path + filename
)
