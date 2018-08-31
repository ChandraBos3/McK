use eip
go



drop table #link

select dpo_material_code,DPO_Net_Rate,DPO_Basic_Rate Rate,mmatc_description,MMGRP_Description,MMAT_UOM_Code,UUOM_Description,job_code,(DPO_Qty - DPO_Cancelled_Qty) Volume,DPO_PO_Number, hpo_po_date, ((DPO_Qty - DPO_Cancelled_Qty)*DPO_Net_Rate) Value,MMAT_Material_Description, location, HPO_Currency_Code,HPO_last_Amendment_Number,  dpo_amendment_number
,HPO_BA_Code, vendor_description, p.sector_code, p.bu_code , p.SBG_Code, HPO_Warehouse_Code,HPO_DS_Code,HPO_PO_Basic_Value, HPO_PO_Net_Value, hpo_mr_number,hmr_mr_date,cast( null as varchar(15))currencydesc

 into #link
 from eip.sqlscm.SCM_H_Purchase_Orders   , eip.sqlscm.SCM_d_Purchase_Orders,
 lnt.dbo.job_master p,
  eip.sqlmas.GEN_M_Material_Groups c, eip.sqlmas.GEN_M_Materials , eip.sqlmas.GEN_M_Material_Classes ,eip.sqlmas.GEN_U_Unit_Of_Measurement , lnt.dbo.vendor_master j,eip.sqlscm.SCM_H_Material_Request


  

where hpo_po_number = dpo_po_number 

and mmat_material_code = DPO_Material_Code and mmat_mg_Code = c.MMGRP_MG_Code 
and MMGRP_Company_Code= mmat_company_code 
and MMATC_Class_Code = c.MMGRP_Class_Code 
and MMGRP_Company_Code=MMATC_Company_Code
and MMAT_Company_Code =1
and HPO_BA_CODE= j.vendor_code

and HPO_Company_Code=1 
and HPO_Job_Code= p.job_code 
and j.company_code = 'LE'
and p.company_code='LE'
and MMAT_UOM_Code = UUOM_UOM_Code
and hpo_po_date between '01-Apr-2017' and '31-Mar-2018'
and MMAT_Company_Code= MMATC_Company_Code    
and hpo_ds_code ='3'  
and dpo_isactive = 'y'
and hmr_mr_number = HPO_MR_Number
and HMR_Company_Code=1
and job_operating_group <>'I' 

Update a set currencydesc = left(b.MCUR_Short_Description,50)
from #link a, eip.sqlmas.GEN_M_Currencies b
where HpO_Currency_Code= b.MCUR_Currency_Code 

Update #link set MMATC_Description= replace(MMATC_Description,char(9),'-'),mmgrp_description=replace(mmgrp_description,char(9),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(9),'-')


Update #link set MMATC_Description= replace(MMATC_Description,char(10),'-'),mmgrp_description=replace(mmgrp_description,char(10),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(10),'-')

						
Update #link set MMATC_Description= replace(MMATC_Description,char(11),'-'),mmgrp_description=replace(mmgrp_description,char(11),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(11),'-')

Update #link set MMATC_Description= replace(MMATC_Description,char(12),'-'),mmgrp_description=replace(mmgrp_description,char(12),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(12),'-')
						
Update #link set MMATC_Description= replace(MMATC_Description,char(13),'-'),mmgrp_description=replace(mmgrp_description,char(13),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(13),'-')
						
Update #link set MMATC_Description= replace(MMATC_Description,char(14),'-'),mmgrp_description=replace(mmgrp_description,char(14),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(14),'-')

Update #link set MMATC_Description= replace(MMATC_Description,char(15),'-'),mmgrp_description=replace(mmgrp_description,char(15),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(15),'-')

Update #link set MMATC_Description= replace(MMATC_Description,'"','-'),mmgrp_description=replace(mmgrp_description,'"','-'),MMAT_Material_Description=replace(MMAT_Material_Description,'"','-')
--select * from #link

alter table #link add ICdesc varchar(100)
alter table #link add BUdesc varchar(100)
alter table #link add Jobdesc varchar(200)
alter table #link add Locdesc varchar(200)
alter table #link add city varchar (200)
alter table #link add state1 varchar (200)
alter table #link add sbgdesc varchar (200)


UPDATE a SET ICdesc = b.Sector_Description
from #link a, lnt.dbo.Sector_Master b
WHERE a.sector_code = b.Sector_Code 
AND b.Company_Code='LE'


UPDATE a SET BUdesc = b.bu_description
from #link a, lnt.dbo.business_unit_master b
WHERE a.bu_code = b.bu_code 
AND b.Company_Code='LE'

UPDATE a SET Jobdesc = b.job_description
from #link a, LNT.dbo.job_master b
WHERE a.job_code = b.job_code 
AND b.Company_Code='LE'

UPDATE a SET Locdesc  = b.region_description
from #link a, lnt.dbo.region_master b
WHERE a.location = b.region_code
and b. Company_Code='LE'

update a set city =UCITY_Name, state1=USTAT_Name
 from #link a, eip.SQLMAS.GEN_M_Address_Book, Eip.Sqlmas.Gen_M_Jobs,eip.sqlmas.GEN_U_States, Eip.Sqlmas.GEN_U_Cities
 where Mjob_AB_Code=MAB_AB_Code 
 and MAB_City_Code=UCITY_City_Code
 and UCITY_State_Code =USTAT_State_Code
 and job_code =mjob_job_code

UPDATE a SET sbgdesc = b.SBG_Description
from #link a, lnt.dbo.sbg_master b
WHERE a.sbg_code = b.sbg_code 


alter table #link add materialcategorycode VARCHAR (500)
alter table #link add PlanningCategory VARCHAR (500)


 Update a set materialcategorycode = d.LMMCLM_Material_Category_Code 
from #link a , epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping d
where Dpo_Material_Code=LMMCLM_Material_Code and LMMCLM_Company_Code=1 
and LMMCLM_Material_Category_Code<>'9999'
	

 Update a set materialcategorycode = d.LMMCLM_Material_Category_Code 
from #link a , epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping d
where Dpo_Material_Code=LMMCLM_Material_Code and LMMCLM_Company_Code=1 
and LMMCLM_Material_Category_Code='9999' and materialcategorycode is null
	

Update a set PlanningCategory = f.MMC_Description 
from #link a ,epm.sqlpmp.GEN_M_Material_Category f
where  materialcategorycode= f.MMC_Material_Category_Code and f.MMC_Company_Code=1 


select dpo_material_code,value,Rate,mmatc_description,MMGRP_Description,planningCategory,MMAT_Material_Description,currencydesc,UUOM_Description,ICdesc from #link 