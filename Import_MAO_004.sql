SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

Create Procedure usp_VerifyfactEDPSMAO04Diagnosis @path varchar(256), @MAO004filename varchar(256) As 
Begin

If OBJECT_ID('dbo.MAO004In') Is Not Null Drop Table [dbo].[MAO004In]
Create Table [dbo].[MAO004In] (col001 varchar(max))

-- Bulk Insert is untested as need permissions
Declare @BulkCmd As nvarChar(4000)
Set		@BulkCmd = "BULK INSERT [dbo].[MAO004In] FROM '"+@path+@MAO004filename+"' WITH (ROWTERMINATOR = '0x0a')"
Exec	(@BulkCmd)

Declare @today As DateTime 
Set @today=getDate()

-- Header
Insert	Into [dbo].[MAO004_HDR]
Select	  SubString(M4.Col001,1,1) As [RecordType]		  	-- 0 = Header	
		, SubString(M4.Col001,2,1) As [Delimiter01]		-- *
		, SubString(M4.Col001,3,7) As [ReportID]		-- MAO-004
		, SubString(M4.Col001,10,1) As [Delimiter02]		-- *
		, SubString(M4.Col001,11,5) As [MAContractID]		-- 
		, SubString(M4.Col001,16,1) As [Delimiter03]		-- *
		, SubString(M4.Col001,17,8) As [ReportDate]		-- CCYYMMDD
		, SubString(M4.Col001,25,1) As [Delimiter04]		-- *
		, SubString(M4.Col001,26,53) As [ReportDesc]		-- "Encounter Data Diagnosis Eligible for Risk Adjustment"
		, SubString(M4.Col001,79,1) As [Delimiter05]		-- *
		, SubString(M4.Col001,80,30) As [Filler01]		-- Spaces
		, SubString(M4.Col001,110,1) As [Delimiter06]		-- *
		, SubString(M4.Col001,111,4) As [SubmissionFileType]	--  PROD or TEST
		, SubString(M4.Col001,115,1) As [Delimiter07]		-- *
		, SubString(M4.Col001,116,1) As [Phase]			--  Phase
		, SubString(M4.Col001,117,1) As [Delimiter08]		-- *
		, SubString(M4.Col001,118,1) As [Version]		--  Version
		, SubString(M4.Col001,119,1) As [Delimiter09]		-- *
		, SubString(M4.Col001,120,381) As [Filler02]	    	-- Spaces
		, @today As [DateImported]
		, @MAO004filename As [FileName]
From	[dbo].[MAO004In] As M4
Left	Outer Join [dbo].[MAO004_HDR] As MH
		On MH.[ReportDate]=SubString(M4.Col001,17,8)
		And MH.[FileName]=@MAO004filename
Where	SubString(M4.Col001,1,1) = '0' -- Header Record
And		MH.[RecordType] Is Null 

-- Detail
Insert	Into [dbo].[MAO004_DTL]
Select	  SubString(M4.Col001,1,1) As [RecordType]		  	-- 1 = Detail
		, SubString(M4.Col001,2,1) As [Delimiter01]		-- *
		, SubString(M4.Col001,3,7) As [ReportID]		-- MAO-004
		, SubString(M4.Col001,10,1) As [Delimiter02]		-- *
		, SubString(M4.Col001,11,5) As [MAContractID]		-- Medicare Advantage Contract ID
		, SubString(M4.Col001,16,1) As [Delimiter03]		-- *
		, SubString(M4.Col001,17,12) As [BeneficiaryHICN]   	-- Beneficiary Health Insurance Claim Number or Medicare Beneficiary Identifier (MBI)
		, SubString(M4.Col001,29,1) As [Delimiter04]		-- *
		, SubString(M4.Col001,30,20) As [EncounterICN]		-- Encounter Data System (EDS) Internal Control Number (ICN)
									-- Note: Currently the ICN is 13 characters long
		, SubString(M4.Col001,50,1) As [Delimiter05]		-- *
		, SubString(M4.Col001,51,1) As [EncounterTypeSwitch]-- See ## Note 1 Below
		, SubString(M4.Col001,52,1) As [Delimiter06]		-- *
		, SubString(M4.Col001,53,20) As [LinkEncounterICN]	-- Encounter Data System (EDS) Internal Control Number (ICN)
									-- See ## Note 2 Below 
		, SubString(M4.Col001,73,1) As [Delimiter07]		-- *
		, SubString(M4.Col001,74,1) As [LinkEncAllowStatus] 	-- See ## Note 3 Below 													
		, SubString(M4.Col001,75,1) As [Delimiter08]		-- *
		, SubString(M4.Col001,76,8) As [EncounterSubmissionDate]-- CCYYMMDD
		, SubString(M4.Col001,84,1) As [Delimiter09]		-- *
		, SubString(M4.Col001,85,8) As [FromDateOfService] 	-- CCYYMMDD
		, SubString(M4.Col001,93,1) As [Delimiter10]		-- *
		, SubString(M4.Col001,94,8) As [ThruDateOfService]	-- CCYYMMDD
		, SubString(M4.Col001,102,1) As [Delimiter11]		-- *
		, SubString(M4.Col001,103,1) As [ServiceType]		-- Type of Claim: P=Professional, I=Inpatient, O=Outpatient, D=DMV, N=(AllOthers) Not Applicable
		, SubString(M4.Col001,104,1) As [Delimiter12]		-- *
		, SubString(M4.Col001,105,1) As [AllowedDisallowedFlag]	-- This field indicates if diagnoses on the current encounter data record are allowed or disallowed for risk adjustment.
									-- ‘A’ = Diagnoses are allowed for risk adjustment.
									-- ‘D’ = Diagnoses are disallowed for risk adjustment.
									--		 Note: Non voids and non-chart review deletes with Service Type designated with ‘N’ will be ‘D’.
									-- Blank = All Voids and chart review deletes,regardless of the service type, since allowed and disallowed status do not apply
		, SubString(M4.Col001,106,1) As [Delimiter13]		-- *
		, SubString(M4.Col001,107,1) As [AllowedDisallowedReasonCode]	
									-- See ## Note 4 Below
		, SubString(M4.Col001,108,1) As [Delimiter14]		-- *
		, SubString(M4.Col001,109,1) As [DiagnosisICD]		-- 0 = ICD-10, 9 = ICD-9
		, SubString(M4.Col001,110,1) As [Delimiter15]		-- *
		, SubString(M4.Col001,111,7) As [DiagnosisCode01]	-- *
		, SubString(M4.Col001,118,1) As [Delimiter16]		-- *
		, SubString(M4.Col001,119,1) As [AddOrDeleteFlag01]	-- A = Add, D = Delete
									-- See ## Note 5 Below
		, SubString(M4.Col001,120,1) As [Delimiter17]		-- *
		, SubString(M4.Col001,121,7) As [DiagnosisCode02]	-- See ## Note 6 Below
		, SubString(M4.Col001,128,1) As [DelimiterD02]		-- *
		, SubString(M4.Col001,129,1) As [AddOrDeleteFlag02]	-- 
		, SubString(M4.Col001,130,1) As [DelimiterF02]		-- *
		, SubString(M4.Col001,131,7) As [DiagnosisCode03]	--
		, SubString(M4.Col001,138,1) As [DelimiterD03]		-- *
		, SubString(M4.Col001,139,1) As [AddOrDeleteFlag03]	-- 
		, SubString(M4.Col001,140,1) As [DelimiterF03]		-- *
		, SubString(M4.Col001,141,7) As [DiagnosisCode04]	--
		, SubString(M4.Col001,148,1) As [DelimiterD04]		-- *
		, SubString(M4.Col001,149,1) As [AddOrDeleteFlag04]	-- 
		, SubString(M4.Col001,150,1) As [DelimiterF04]		-- *
		, SubString(M4.Col001,151,7) As [DiagnosisCode05]	--
		, SubString(M4.Col001,158,1) As [DelimiterD05]		-- *
		, SubString(M4.Col001,159,1) As [AddOrDeleteFlag05]	-- 
		, SubString(M4.Col001,160,1) As [DelimiterF05]		-- *
		, SubString(M4.Col001,161,7) As [DiagnosisCode06]	--
		, SubString(M4.Col001,168,1) As [DelimiterD06]		-- *
		, SubString(M4.Col001,169,1) As [AddOrDeleteFlag06]	-- 
		, SubString(M4.Col001,170,1) As [DelimiterF06]		-- *
		, SubString(M4.Col001,171,7) As [DiagnosisCode07]	--
		, SubString(M4.Col001,178,1) As [DelimiterD07]		-- *
		, SubString(M4.Col001,179,1) As [AddOrDeleteFlag07]	-- 
		, SubString(M4.Col001,180,1) As [DelimiterF07]		-- *
		, SubString(M4.Col001,181,7) As [DiagnosisCode08]	--
		, SubString(M4.Col001,188,1) As [DelimiterD08]		-- *
		, SubString(M4.Col001,189,1) As [AddOrDeleteFlag08]	-- 
		, SubString(M4.Col001,190,1) As [DelimiterF08]		-- *
		, SubString(M4.Col001,191,7) As [DiagnosisCode09]	--
		, SubString(M4.Col001,198,1) As [DelimiterD09]		-- *
		, SubString(M4.Col001,199,1) As [AddOrDeleteFlag09]	-- 
		, SubString(M4.Col001,200,1) As [DelimiterF09]		-- *
		, SubString(M4.Col001,201,7) As [DiagnosisCode10]	--
		, SubString(M4.Col001,208,1) As [DelimiterD10]		-- *
		, SubString(M4.Col001,209,1) As [AddOrDeleteFlag10]	-- 
		, SubString(M4.Col001,210,1) As [DelimiterF10]		-- *
		, SubString(M4.Col001,211,7) As [DiagnosisCode11]	--
		, SubString(M4.Col001,218,1) As [DelimiterD11]		-- *
		, SubString(M4.Col001,219,1) As [AddOrDeleteFlag11]	-- 
		, SubString(M4.Col001,220,1) As [DelimiterF11]		-- *
		, SubString(M4.Col001,221,7) As [DiagnosisCode12]	--
		, SubString(M4.Col001,228,1) As [DelimiterD12]		-- *
		, SubString(M4.Col001,229,1) As [AddOrDeleteFlag12]	-- 
		, SubString(M4.Col001,230,1) As [DelimiterF12]		-- *
		, SubString(M4.Col001,231,7) As [DiagnosisCode13]	--
		, SubString(M4.Col001,238,1) As [DelimiterD13]		-- *
		, SubString(M4.Col001,239,1) As [AddOrDeleteFlag13]	-- 
		, SubString(M4.Col001,240,1) As [DelimiterF13]		-- *
		, SubString(M4.Col001,241,7) As [DiagnosisCode14]	--
		, SubString(M4.Col001,248,1) As [DelimiterD14]		-- *
		, SubString(M4.Col001,249,1) As [AddOrDeleteFlag14]	-- 
		, SubString(M4.Col001,250,1) As [DelimiterF14]		-- *
		, SubString(M4.Col001,251,7) As [DiagnosisCode15]	--
		, SubString(M4.Col001,258,1) As [DelimiterD15]		-- *
		, SubString(M4.Col001,259,1) As [AddOrDeleteFlag15]	-- 
		, SubString(M4.Col001,260,1) As [DelimiterF15]		-- *
		, SubString(M4.Col001,261,7) As [DiagnosisCode16]	--
		, SubString(M4.Col001,268,1) As [DelimiterD16]		-- *
		, SubString(M4.Col001,269,1) As [AddOrDeleteFlag16]	-- 
		, SubString(M4.Col001,270,1) As [DelimiterF16]		-- *
		, SubString(M4.Col001,271,7) As [DiagnosisCode17]	--
		, SubString(M4.Col001,278,1) As [DelimiterD17]		-- *
		, SubString(M4.Col001,279,1) As [AddOrDeleteFlag17]	-- 
		, SubString(M4.Col001,280,1) As [DelimiterF17]		-- *
		, SubString(M4.Col001,281,7) As [DiagnosisCode18]	--
		, SubString(M4.Col001,288,1) As [DelimiterD18]		-- *
		, SubString(M4.Col001,289,1) As [AddOrDeleteFlag18]	-- 
		, SubString(M4.Col001,290,1) As [DelimiterF18]		-- *
		, SubString(M4.Col001,291,7) As [DiagnosisCode19]	--
		, SubString(M4.Col001,298,1) As [DelimiterD19]		-- *
		, SubString(M4.Col001,299,1) As [AddOrDeleteFlag19]	-- 
		, SubString(M4.Col001,300,1) As [DelimiterF19]		-- *
		, SubString(M4.Col001,301,7) As [DiagnosisCode20]	--
		, SubString(M4.Col001,308,1) As [DelimiterD20]		-- *
		, SubString(M4.Col001,309,1) As [AddOrDeleteFlag20]	-- 
		, SubString(M4.Col001,310,1) As [DelimiterF20]		-- *
		, SubString(M4.Col001,311,7) As [DiagnosisCode21]	--
		, SubString(M4.Col001,318,1) As [DelimiterD21]		-- *
		, SubString(M4.Col001,319,1) As [AddOrDeleteFlag21]	-- 
		, SubString(M4.Col001,320,1) As [DelimiterF21]		-- *
		, SubString(M4.Col001,321,7) As [DiagnosisCode22]	--
		, SubString(M4.Col001,328,1) As [DelimiterD22]		-- *
		, SubString(M4.Col001,329,1) As [AddOrDeleteFlag22]	-- 
		, SubString(M4.Col001,330,1) As [DelimiterF22]		-- *
		, SubString(M4.Col001,331,7) As [DiagnosisCode23]	--
		, SubString(M4.Col001,338,1) As [DelimiterD23]		-- *
		, SubString(M4.Col001,339,1) As [AddOrDeleteFlag23]	-- 
		, SubString(M4.Col001,340,1) As [DelimiterF23]		-- *
		, SubString(M4.Col001,341,7) As [DiagnosisCode24]	--
		, SubString(M4.Col001,348,1) As [DelimiterD24]		-- *
		, SubString(M4.Col001,349,1) As [AddOrDeleteFlag24]	-- 
		, SubString(M4.Col001,350,1) As [DelimiterF24]		-- *
		, SubString(M4.Col001,351,7) As [DiagnosisCode25]	--
		, SubString(M4.Col001,358,1) As [DelimiterD25]		-- *
		, SubString(M4.Col001,359,1) As [AddOrDeleteFlag25]	-- 
		, SubString(M4.Col001,360,1) As [DelimiterF25]		-- *
		, SubString(M4.Col001,361,7) As [DiagnosisCode26]	--
		, SubString(M4.Col001,368,1) As [DelimiterD26]		-- *
		, SubString(M4.Col001,369,1) As [AddOrDeleteFlag26]	-- 
		, SubString(M4.Col001,370,1) As [DelimiterF26]		-- *
		, SubString(M4.Col001,371,7) As [DiagnosisCode27]	--
		, SubString(M4.Col001,378,1) As [DelimiterD27]		-- *
		, SubString(M4.Col001,379,1) As [AddOrDeleteFlag27]	-- 
		, SubString(M4.Col001,380,1) As [DelimiterF27]		-- *
		, SubString(M4.Col001,381,7) As [DiagnosisCode28]	--
		, SubString(M4.Col001,388,1) As [DelimiterD28]		-- *
		, SubString(M4.Col001,389,1) As [AddOrDeleteFlag28]	-- 
		, SubString(M4.Col001,390,1) As [DelimiterF28]		-- *
		, SubString(M4.Col001,391,7) As [DiagnosisCode29]	--
		, SubString(M4.Col001,398,1) As [DelimiterD29]		-- *
		, SubString(M4.Col001,399,1) As [AddOrDeleteFlag29]	-- 
		, SubString(M4.Col001,400,1) As [DelimiterF29]		-- *
		, SubString(M4.Col001,401,7) As [DiagnosisCode30]	--
		, SubString(M4.Col001,408,1) As [DelimiterD30]		-- *
		, SubString(M4.Col001,409,1) As [AddOrDeleteFlag30]	-- 
		, SubString(M4.Col001,410,1) As [DelimiterF30]		-- *
		, SubString(M4.Col001,411,7) As [DiagnosisCode31]	--
		, SubString(M4.Col001,418,1) As [DelimiterD31]		-- *
		, SubString(M4.Col001,419,1) As [AddOrDeleteFlag31]	-- 
		, SubString(M4.Col001,420,1) As [DelimiterF31]		-- *
		, SubString(M4.Col001,421,7) As [DiagnosisCode32]	--
		, SubString(M4.Col001,428,1) As [DelimiterD32]		-- *
		, SubString(M4.Col001,429,1) As [AddOrDeleteFlag32]	-- 
		, SubString(M4.Col001,430,1) As [DelimiterF32]		-- *
		, SubString(M4.Col001,431,7) As [DiagnosisCode33]	--
		, SubString(M4.Col001,438,1) As [DelimiterD33]		-- *
		, SubString(M4.Col001,439,1) As [AddOrDeleteFlag33]	-- 
		, SubString(M4.Col001,440,1) As [DelimiterF33]		-- *
		, SubString(M4.Col001,441,7) As [DiagnosisCode34]	--
		, SubString(M4.Col001,448,1) As [DelimiterD34]		-- *
		, SubString(M4.Col001,449,1) As [AddOrDeleteFlag34]	-- 
		, SubString(M4.Col001,450,1) As [DelimiterF34]		-- *
		, SubString(M4.Col001,451,7) As [DiagnosisCode35]	--
		, SubString(M4.Col001,458,1) As [DelimiterD35]		-- *
		, SubString(M4.Col001,459,1) As [AddOrDeleteFlag35]	-- 
		, SubString(M4.Col001,460,1) As [DelimiterF35]		-- *
		, SubString(M4.Col001,461,7) As [DiagnosisCode36]	--
		, SubString(M4.Col001,468,1) As [DelimiterD36]		-- *
		, SubString(M4.Col001,469,1) As [AddOrDeleteFlag36]	-- 
		, SubString(M4.Col001,470,1) As [DelimiterF36]		-- *
		, SubString(M4.Col001,471,7) As [DiagnosisCode37]	--
		, SubString(M4.Col001,478,1) As [DelimiterD37]		-- *
		, SubString(M4.Col001,479,1) As [AddOrDeleteFlag37]	-- 
		, SubString(M4.Col001,480,1) As [DelimiterF37]		-- *
		, SubString(M4.Col001,481,7) As [DiagnosisCode38]	--
		, SubString(M4.Col001,488,1) As [DelimiterD38]		-- *
		, SubString(M4.Col001,489,1) As [AddOrDeleteFlag38]	-- 
		, SubString(M4.Col001,490,1) As [DelimiterF38]		-- *
		, SubString(M4.Col001,491,10) As [Filler]		-- Spaces
		, @today As [DateImported]
		, @MAO004filename As [FileName]
From	[dbo].[MAO004In] As M4
Left	Outer Join [dbo].[MAO004_DTL] As MD
		On MD.[BeneficiaryHICN]=SubString(M4.Col001,17,12)
		And MD.[EncounterICN] = SubString(M4.Col001,30,20)
		And MD.[FileName]=@MAO004filename
Where	SubString(M4.Col001,1,1) = '1' -- Detail Record
And		MD.[RecordType] Is Null 

/*
 ## Note 1. Encounter Type Switch
	1 = Encounter
	2 = Void to an Encounter
	3 = Replacement to an Encounter
	4 = Chart Review Add
	5 = Void to a Chart Review
	6 = Replacement to a Chart Review
	7 = Chart Review Delete
	8 = Void to a Chart Review Delete
	9 = Replacement to a Chart Review Delete
 ## Note 2. Original Encounter Internal Control Number (ICN)
	This field on an Adjustment or Linked Chart Review record contains the ICN of the encounter data record to which 
	the adjustment or linked chart review record links. It will be blank on Original encounters 
	(and Unlinked Chart Reviews)
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
-- Trailer
Insert	Into [dbo].[MAO004_TRL]
Select	  SubString(M4.Col001,1,1) As [RecordType]		  	-- 9 = Trailer
		, SubString(M4.Col001,2,1) As [Delimiter01]			-- *
		, SubString(M4.Col001,3,7) As [ReportID]            -- MAO-004
		, SubString(M4.Col001,10,1) As [Delimiter02]		-- *
		, SubString(M4.Col001,11,5) As [MAContractID]       -- Medicare Advantage Contract ID
		, SubString(M4.Col001,16,1) As [Delimiter03]		-- *
		, SubString(M4.Col001,17,18) As [TotalNumberOfRecords]	--
		, SubString(M4.Col001,35,1) As [Delimiter04]		-- *
		, SubString(M4.Col001,36,465) As [Filler]			-- Spaces
		, @today As [DateImported]
		, @MAO004filename As [FileName]
From	[dbo].[MAO004In] As M4
Left	Outer Join [dbo].[MAO004_TRL] As MT
		On MT.[FileName] = @MAO004filename
Where	SubString(M4.Col001,1,1) = '9'
And		MT.[RecordType] Is Null

If OBJECT_ID('dbo.MAO004In') Is Not Null Drop Table [dbo].[MAO004In]

End
