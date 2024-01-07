

Select *
From PortforlioProject.dbo.Nashville



-- Standardizing the Date Format
Select SaleDateConverted,CONVERT(Date,SaleDate)
From PortforlioProject.dbo.Nashville

Alter Table PortforlioProject.dbo.Nashville
add SaleDateConverted date;


Update PortforlioProject.dbo.Nashville
SET SaleDateConverted = CONVERT(Date,SaleDate)

 --------------------------------------------------------------------------------------------------------------------------

-- Populating Property Address data

Select *
From PortforlioProject.dbo.Nashville
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortforlioProject.dbo.Nashville as a
JOIN PortforlioProject.dbo.Nashville as b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortforlioProject.dbo.Nashville as a
JOIN PortforlioProject.dbo.Nashville as b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select OwnerAddress
From PortforlioProject.dbo.Nashville


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortforlioProject.dbo.Nashville



ALTER Table PortforlioProject.dbo.Nashville
Add OwnerSplitAddress Nvarchar(255);

Update PortforlioProject.dbo.Nashville
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE PortforlioProject.dbo.Nashville
Add OwnerSplitCity Nvarchar(255);

Update PortforlioProject.dbo.Nashville
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE PortforlioProject.dbo.Nashville
Add OwnerSplitState Nvarchar(255);

Update PortforlioProject.dbo.Nashville
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From PortforlioProject.dbo.Nashville


--------------------------------------------------------------------------------------------------------------------------


-- Changing Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortforlioProject.dbo.Nashville
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortforlioProject.dbo.Nashville


Update PortforlioProject.dbo.Nashville
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END



-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Removing Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				
				 SalePrice,
				 SaleDateConverted,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortforlioProject.dbo.Nashville

)
Delete
From RowNumCTE
Where row_num > 1




Select *
From PortforlioProject.dbo.Nashville




---------------------------------------------------------------------------------------------------------

-- Deleting Unused Columns



Select *
From PortforlioProject.dbo.Nashville


ALTER TABLE PortforlioProject.dbo.Nashville
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate











