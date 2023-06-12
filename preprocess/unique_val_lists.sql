-------------- Create unique values tables ----------------
SELECT * FROM bnvds.com_occsol_qsa2020 WHERE 1=1 AND substance IN ('(e)-5-decen-1-yl acetate','(e,z)-2,13-octadecadienyl acetate')
-- landcover
drop table if exists bnvds.unique_ocs_qsa_2020;
create table bnvds.unique_ocs_qsa_2020 as 
select distinct(t1.occ_sol)  from bnvds.com_occsol_qsa2020 t1
--where com_adm = '01001'
group by  occ_sol;

COMMENT ON TABLE bnvds.unique_ocs_qsa_2020 IS 'This table stores unique values of landcover per town. It is to be used in a application drop down list';

-- fonction
drop table if exists bnvds.unique_fonction_qsa_2020;
create table bnvds.unique_fonction_qsa_2020 as 
select distinct(t1.fonction)   from bnvds.com_occsol_qsa2020 t1
--where com_adm = '01001'
group by  fonction;

COMMENT ON TABLE bnvds.unique_fonction_qsa_2020 IS 'This table stores unique values of function (fongicide, herbicides..) per town. It is to be used in a application drop down list';

-- classification per town
drop table if exists bnvds.unique_classification_qsa_2020;
create table bnvds.unique_classification_qsa_2020 as 
select distinct(t1.classification)   from bnvds.com_occsol_qsa2020 t1
--where com_adm = '01001'
group by  classification;

COMMENT ON TABLE bnvds.unique_classification_qsa_2020 IS 'This table stores unique values of function (fongicide, herbicides..) per town. It is to be used in a application drop down list';


-- substance per town
drop table if exists bnvds.unique_substance_qsa_2020;
create table bnvds.unique_substance_qsa_2020 as 
select distinct(t1.substance)   from bnvds.com_occsol_qsa2020 t1
--where com_adm = '01001'
group by substance;

COMMENT ON TABLE bnvds.unique_substance_qsa_2020 IS 'This table stores unique values of function (fongicide, herbicides..) per town. It is to be used in a application drop down list';
