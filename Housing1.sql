create database housing;
use housing;


create table Nashville_Housing (

UniqueID int,
ParcelID varchar(25),
LandUse varchar(30),
PropertyAddress  varchar(50),
SaleDate date,
SalePrice bigint,
LegalReference varchar(50),
SoldAsVacant varchar(10),
OwnerName varchar(150),
OwnerAddress  varchar(100),
Acreage varchar(10),
TaxDistrict varchar(100),
LandValue int,
BuildingValue int,
TotalValue int,
YearBuilt int,
Bedrooms int,
FullBath int,
HalfBath int
);

alter table Nashville_Housing
modify LandValue varchar(50);

alter table Nashville_Housing
modify BuildingValue varchar(50);

alter table Nashville_Housing
modify TotalValue varchar(50);

alter table Nashville_Housing
modify YearBuilt varchar(50);

alter table Nashville_Housing
modify Bedrooms varchar(50);
alter table Nashville_Housing
modify FullBath varchar(50);
alter table Nashville_Housing
modify HalfBath varchar(50);

alter table Nashville_Housing
modify SalePrice varchar(50);


select * from housing.Nashville_Housing;

select count(*) from housing.Nashville_Housing;

select * from  housing.Nashville_Housing
-- where PropertyAddress is null;
order by ParcelID;

select * from housing.Nashville_Housing
where PropertyAddress is null;
 
SELECT LEFT(PropertyAddress, 
            LOCATE(',', PropertyAddress) - 1) AS address,
            substring(PropertyAddress, 
            LOCATE(',', PropertyAddress) +1) AS city
            from housing.Nashville_Housing;

alter table Nashville_Housing
add PropertySplitAddress varchar(200);

alter table Nashville_Housing
add PropertySplitCity varchar(200);

update  Nashville_Housing
set PropertySplitAddress = LEFT(PropertyAddress, 
            LOCATE(',', PropertyAddress) - 1);
 
 update  Nashville_Housing
set PropertySplitCity = substring(PropertyAddress, 
            LOCATE(',', PropertyAddress) +1);

select OwnerAddress from Nashville_Housing;



SELECT
  SUBSTRING_INDEX(OwnerAddress, ',', 1) AS part1,
  SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1) AS part2,
  SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 3), ',', -1) AS part3
FROM Nashville_Housing;


alter table Nashville_Housing
add OwnerSplitAddress varchar(200);

alter table Nashville_Housing
add OwnerSplitCity varchar(200);

alter table Nashville_Housing
add OwnerSplitState varchar(200);


update  Nashville_Housing
set  OwnerSplitAddress= SUBSTRING_INDEX(OwnerAddress, ',', 1);

update  Nashville_Housing
set  OwnerSplitCity = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1);

update Nashville_Housing
set OwnerSplitState =SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 3), ',', -1);

select * from  Nashville_Housing;

select distinct(SoldAsVacant) , count(SoldAsVacant)
from Nashville_Housing
group by SoldAsVacant
order by 2;

select SoldAsVacant,
case
when SoldAsVacant= 'N' Then 'No'
else SoldAsVacant
end 
from Nashville_Housing;

update Nashville_Housing
set SoldAsVacant =case
when SoldAsVacant= 'N' Then 'No'
else SoldAsVacant
end ;

with ROWNUMCTE AS (
select *,
row_number() over (
partition by ParcelID, PropertyAddress,SalePrice,SaleDate,LegalReference order by UniqueID) as row_no
from Nashville_Housing
)
delete
from ROWNUMCTE
where row_no > 1;

select * from Nashville_Housing;

alter table Nashville_Housing
drop column OwnerAddress;
alter table Nashville_Housing
drop column TaxDistrict;
alter table Nashville_Housing
drop column PropertyAddress;

