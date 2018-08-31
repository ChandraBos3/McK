use eip
GO

drop table #billlist

select d.sector_code,d.Sector_Description, HWO_Job_Code, c.job_description, HWO_WO_Number, DWO_Item_Code,
cast(null as varchar(15)) workcategorycode,cast(null as varchar(500)) workCategory, 
cast(null as varchar(500)) itemdesc,HWO_Currency_Code, cast( null as varchar(15))currencydesc, DWO_WO_Qty, DWO_Item_Rate, DWO_Item_Value,dwo_uom_code,
HWO_Last_Amendment_Number,HWO_WOT_Code,MWOTP_Description, HWO_BA_Code,vendor_description,location, c.SBG_Code,  HWO_WO_Date
,HWO_DS_Code, DWO_Markup_Code, DWO_Version,UUOM_Description
into #billlist
from  lnt.dbo.job_master c, lnt.dbo.sector_master d, eip.sqlwom.WOM_H_Work_Orders, eip.SQLWOM.WOM_D_Work_Orders,lnt.dbo.vendor_master j, eip.SQLMAS.GEN_M_WO_Types ,eip.sqlmas.GEN_U_Unit_Of_Measurement
WHERE HWO_WO_Number = DWO_WO_Number
and HWO_WO_Date between '01-Apr-2017' and '31-Mar-2018'
and HWO_Job_Code= c.job_code
and c.Sector_Code = d.Sector_Code and c.company_code='LE' and c.company_code = d.Company_Code and hwo_ba_code = j.vendor_code 
and HWO_DS_CODE =3
and j.company_code = 'LE'
and hwo_company_code  = '1'
and HWO_WOT_code = MWOTP_WOT_Code
and job_operating_group <>'I'
and dwo_UOM_Code = UUOM_UOM_Code 



Update a set workcategorycode = MSR_Resource_Group_Code,itemdesc = left(MSR_standardized_Description,500)
from #billlist a, EPM.SQLPMP.Gen_M_Standard_Resource
where MSR_Resource_Code= DWO_Item_Code  AND MSR_Resource_Type_Code='scpl'


Update a set workcategorycode = MJITC_Item_Group_Code,itemdesc = left(MJITC_Item_Description,500)
from #billlist a, eip.sqlwom.wom_m_job_item_codes
where A.HWO_Job_Code = MJITC_Job_Code
and MJITC_Item_Code= a.DWO_Item_Code
and MJITC_Company_Code=1 AND WORKCATEGORYCODE IS NULL

Update a set workCategory = b.MIGRP_Description
from #billlist a, EIP.SQLMAS.GEN_M_ITEM_GROUPS B
where workcategorycode= b.MIGRP_Item_Group_Code



Update a set currencydesc = left(b.MCUR_Short_Description,50)
from #billlist a, eip.sqlmas.GEN_M_Currencies b
where HWO_Currency_Code= b.MCUR_Currency_Code 





Update #billlist set itemdesc = replace(itemdesc , char(9),'-')

Update #billlist set itemdesc = replace(itemdesc , char(10),'-')

Update #billlist set itemdesc = replace(itemdesc , char(11),'-')

Update #billlist set itemdesc = replace(itemdesc , char(12),'-')

Update #billlist set itemdesc = replace(itemdesc , char(13),'-')

Update #billlist set itemdesc = replace(itemdesc , char(14),'-')

Update #billlist set itemdesc=replace (itemdesc , '''','f')
Update #billlist set itemdesc=replace (itemdesc , '"','i')

alter table #billlist add BUdesc varchar(100)
alter table #billlist add sbgdesc varchar (200)
alter table #billlist add Locdesc varchar(100)
alter table #billlist add city varchar (200)
alter table #billlist add state1 varchar (200)

uPDATE a SET  BUdesc= d.bu_description
FROM #billlist a, lnt.dbo.business_unit_master d, LNT.DBO.JOB_MASTER c
WHERE hwo_Job_Code= c.job_code
AND c.BU_CODE = d.bu_code


UPDATE a SET sbgdesc = b.SBG_Description
from #billlist a, lnt.dbo.sbg_master b
WHERE a.sbg_code = b.sbg_code 





UPDATE a SET Locdesc  = b.region_description
from #billlist a, lnt.dbo.region_master b
WHERE a.location = b.region_code
and b. Company_Code='LE'


update a set city =UCITY_Name, state1=USTAT_Name
 from #billlist a, eip.SQLMAS.GEN_M_Address_Book, Eip.Sqlmas.Gen_M_Jobs,eip.sqlmas.GEN_U_States, Eip.Sqlmas.GEN_U_Cities
 where Mjob_AB_Code=MAB_AB_Code 
 and MAB_City_Code=UCITY_City_Code
 and UCITY_State_Code =USTAT_State_Code
 and HWO_Job_Code =mjob_job_code


select workCategory,itemdesc, DWO_Item_Rate, UUOM_Description,currencydesc,city,state1,Sector_description from #billlist 






