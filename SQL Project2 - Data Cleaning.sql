 -- Cleaning Data In SQL Queries

select * 
from [Portfolio Project]..NashvilleHousing

-- Standardize Data Format

select SaleDateConverted, CONVERT(date,SaleDate)
from [Portfolio Project]..NashvilleHousing

alter table NashvilleHousing
Add SaleDateConverted date;

update NashvilleHousing
set SaleDateConverted = CONVERT(date,SaleDate)

-- Populate Property Address Data

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Portfolio Project]..NashvilleHousing a
join [Portfolio Project]..NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

update a 
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Portfolio Project]..NashvilleHousing a
join [Portfolio Project]..NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

-- Breaking Out Address Into Individual Columns (Address, City, State)

select PropertyAddress
from [Portfolio Project]..NashvilleHousing

select 
SUBSTRING (PropertyAddress, 1, charindex(',', PropertyAddress) -1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
from [Portfolio Project]..NashvilleHousing

alter table NashvilleHousing
Add PropertySplitAddress nvarchar(250);

update NashvilleHousing
set PropertySplitAddress = SUBSTRING (PropertyAddress, 1, charindex(',', PropertyAddress) -1)

alter table NashvilleHousing
Add PropertySplitCity nvarchar(250);

update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

select * 
from [Portfolio Project]..NashvilleHousing

----------------------------------------------------------------------------------------------------------------
select OwnerAddress
from [Portfolio Project]..NashvilleHousing

select 
PARSENAME(replace(OwnerAddress, ',', '.') ,3)
,PARSENAME(replace(OwnerAddress, ',', '.') ,2)
,PARSENAME(replace(OwnerAddress, ',', '.') ,1)
from [Portfolio Project]..NashvilleHousing

alter table NashvilleHousing
Add OwnerSplitAddress nvarchar(250);

update NashvilleHousing
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress, ',', '.') ,3)

alter table NashvilleHousing
Add OwnerSplitCity nvarchar(250);

update NashvilleHousing
set OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',', '.') ,2)

alter table NashvilleHousing
Add OwnerSplitState nvarchar(250);

update NashvilleHousing
set OwnerSplitState = PARSENAME(replace(OwnerAddress, ',', '.') ,1)

select * 
from [Portfolio Project]..NashvilleHousing


-- Change Y & n To Yes & No In As "SoldAsVacant" field

update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end

select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
from [Portfolio Project]..NashvilleHousing

select distinct(SoldAsVacant), COUNT(SoldAsVacant)
from [Portfolio Project]..NashvilleHousing
group by SoldAsVacant
order by 1


-- Remove Duplicate

with RowNumCTE as (
select *,
ROW_NUMBER() over(
 partition by ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 order by 
			    UniqueID
			   ) row_num

from [Portfolio Project]..NashvilleHousing
)
select *
from RowNumCTE
where row_num > 1

-- Delete Unused Columns

select *
from [Portfolio Project]..NashvilleHousing

alter table [Portfolio Project]..NashvilleHousing
drop column PropertySplitState, TaxDistrict

alter table [Portfolio Project]..NashvilleHousing
drop column SaleDate

















