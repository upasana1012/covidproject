/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [portfolio project].[dbo].[NashvilleHousing]

select * 
from NashvilleHousing

/* Standardize Date Format*/

select [sale date converted], CONVERT(date, saledate)
from NashvilleHousing

alter table NashvilleHousing
add [sale date converted] date

update NashvilleHousing
set [sale date converted] = CONVERT(date, saledate)


/*Populating Property Address Data*/

select *
from NashvilleHousing
order by ParcelID 


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyaddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a
set propertyaddress = ISNULL(a.propertyaddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

/* Breaking Out Address into Individual Columns*/

Select
SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress)-1) as Address
,SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress)+1, LEN(Propertyaddress)) as Address
from NashvilleHousing

alter table NashvilleHousing
add [property split address] nvarchar(255)

update NashvilleHousing
set [property split address] = SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress)-1)

alter table NashvilleHousing
add [property split city] nvarchar(255)

update NashvilleHousing
set [property split city] = SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress)+1, LEN(Propertyaddress))


/*Change Y and N to Yes and No*/

select SoldAsVacant
      ,case when SoldAsVacant = 'y' then 'yes'
	   when SoldAsVacant = 'n' then 'no'
	   else SoldAsVacant
end
from NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'y' then 'yes'
	   when SoldAsVacant = 'n' then 'no'
	   else SoldAsVacant
end

select distinct(soldasvacant), COUNT(soldasvacant)
from NashvilleHousing
group by SoldAsVacant
order by COUNT(soldasvacant)

