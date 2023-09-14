
SELECT *
FROM `Produksi Minyak Nabati` pmn
-----------------------------------------------------------------------------------------------

SELECT 
	Year,
	Area,
	Item,
	SUM(Value)
FROM `Produksi Minyak Nabati` 
GROUP BY Year, Area, Item
HAVING Year >= 2000;

-----------------------------------------------------------------------------------------------

SELECT *
FROM `Penggunaan Lahan Minyak Nabati`

-----------------------------------------------------------------------------------------------
-- Mengubah data Penggunaan Lahan Menjadi Long Data


WITH long_lahan as
	(SELECT 
		Year, Entity, Code,'Palm fruit oil' as Item, `Palm fruit oil`  as Value FROM `Penggunaan Lahan Minyak Nabati`
	UNION ALL
	SELECT 
		Year, Entity, Code,'Soybeans', Soybeans FROM `Penggunaan Lahan Minyak Nabati`
	UNION ALL
	SELECT 
		Year, Entity, Code,'Sunflower seed', `Sunflower seed`  FROM `Penggunaan Lahan Minyak Nabati`
	UNION ALL
	SELECT 
		Year, Entity, Code,'Rapeseed', Rapeseed  FROM `Penggunaan Lahan Minyak Nabati`
	UNION ALL
	SELECT 
		Year, Entity, Code,'Seed cotton', `Seed cotton` FROM `Penggunaan Lahan Minyak Nabati`
	UNION ALL
	SELECT 
		Year, Entity, Code,'Groundnuts', Groundnuts  FROM `Penggunaan Lahan Minyak Nabati`
	UNION ALL
	SELECT 
		Year, Entity, Code,'Coconuts', Coconuts  FROM `Penggunaan Lahan Minyak Nabati`
	UNION ALL
	SELECT 
		Year, Entity, Code,'Olives', Olives  FROM `Penggunaan Lahan Minyak Nabati`
	UNION ALL
	SELECT 
		Year, Entity, Code,'Sesame seed', `Sesame seed`  FROM `Penggunaan Lahan Minyak Nabati`
	UNION ALL
	SELECT 
		Year, Entity, Code,'Castor oil seed', `Castor oil seed`  FROM `Penggunaan Lahan Minyak Nabati`
	UNION ALL
	SELECT 
		Year, Entity, Code,'Safflower seed', `Safflower seed`  FROM `Penggunaan Lahan Minyak Nabati`
	UNION ALL
	SELECT 
		Year, Entity, Code,'Linseed', Linseed  FROM `Penggunaan Lahan Minyak Nabati`
	UNION ALL
	SELECT 
		Year, Entity, Code,'Tung nuts', `Tung nuts`  FROM `Penggunaan Lahan Minyak Nabati`
	UNION ALL
	SELECT 
		Year, Entity, Code,'Karite nuts', `Karite nuts`  FROM `Penggunaan Lahan Minyak Nabati`)

SELECT Year, Entity, Code, Item, Value
FROM long_lahan
WHERE Year >= 2000; -- eksport sebagai table


-----------------------------------------------------------------------------------------------
-- Grouping Data Penggunaan Lahan (long)

SELECT `Year` , Entity , Code , Item , SUM(Value) 
FROM `Penggunaan Lahan Minyak Nabati (long)`
GROUP BY Year, Entity, Code,Item

-----------------------------------------------------------------------------------------------
-- Melihat data unik

SELECT DISTINCT(Item)
FROM `Produksi Minyak Nabati` pmn; 

SELECT DISTINCT(Item)
FROM `Penggunaan Lahan Minyak Nabati (long)` plmnl 

-- nama item pada masing masing dataset berbeda

-----------------------------------------------------------------------------------------------
-- Standarisasi nama item

UPDATE `Penggunaan Lahan Minyak Nabati (long)` 
SET Item = CASE WHEN Item = 'Seed cotton' THEN 'Cottonseed oil' ELSE Item END
UPDATE `Penggunaan Lahan Minyak Nabati (long)`  
SET Item = CASE WHEN Item = 'Linseed' THEN 'Linseed oil' ELSE Item END
UPDATE `Penggunaan Lahan Minyak Nabati (long)`  
SET Item = CASE WHEN Item = 'Sesame seed' THEN 'Sesame oil' ELSE Item END
UPDATE `Penggunaan Lahan Minyak Nabati (long)` 
SET Item = CASE WHEN Item = 'Olives' THEN 'Olive oil' ELSE Item END
UPDATE `Penggunaan Lahan Minyak Nabati (long)` 
SET Item = CASE WHEN Item = 'Sunflower seed' THEN 'Sunflower-seed oil' ELSE Item END
,Item = CASE WHEN Item = 'Groundnuts' THEN 'Groundnut oil' ELSE Item END
,Item = CASE WHEN Item = 'Palm fruit oil' THEN 'Palm oil' ELSE Item END
,Item = CASE WHEN Item = 'Soybeans' THEN 'Soybean oil' ELSE Item END
,Item = CASE WHEN Item = 'Rapeseed' THEN 'Rapeseed oil' ELSE Item END
,Item = CASE WHEN Item = 'Safflower seed' THEN 'Safflower-seed oil' ELSE Item END
,Item = CASE WHEN Item = 'Coconuts' THEN 'Coconut oil' ELSE Item END


UPDATE `Produksi Minyak Nabati`  
SET Item = CASE WHEN Item = 'Oil of linseed' THEN 'Linseed oil' ELSE Item END
UPDATE `Produksi Minyak Nabati`  
SET Item = CASE WHEN Item = 'Oil of sesame seed' THEN 'Sesame oil' ELSE Item END
UPDATE `Produksi Minyak Nabati`  
SET Item = CASE WHEN Item = 'Sunflower-seed oil, crude' THEN 'Sunflower-seed oil' ELSE Item END
,Item = CASE WHEN Item = 'Soya bean oil' THEN 'Soybean oil' ELSE Item END
,Item = CASE WHEN Item = 'Rapeseed or canola oil, crude' THEN 'Rapeseed oil' ELSE Item END
,Item = CASE WHEN Item = 'Safflower-seed oil, crude' THEN 'Safflower-seed oil' ELSE Item END


-----------------------------------------------------------------------------------------------
-- Join Data

SELECT p.Year, Area, l.Code, p.Item, Produksi_t, Luas_ha
FROM 
	(SELECT 
		Year,
		Area,
		Item,
		SUM(Value) as Produksi_t
	FROM `Produksi Minyak Nabati` 
	GROUP BY Year, Area, Item
	HAVING Year >= 2000) as p
JOIN 
	(SELECT `Year` , Entity , Code , Item , SUM(Value) as Luas_ha
	FROM `Penggunaan Lahan Minyak Nabati (long)`
	GROUP BY Year, Entity, Code,Item) as l
ON p.Year = l.Year AND p.Area = l.Entity AND p.Item = l.Item

-----------------------------------------------------------------------------------------------
-- Membuat table baru dari join data

CREATE TABLE `Luas join produksi minyak nabati` AS
SELECT p.Year, Area, l.Code, p.Item, Produksi_t, Luas_ha
FROM 
	(SELECT 
		Year,
		Area,
		Item,
		SUM(Value) as Produksi_t
	FROM `Produksi Minyak Nabati` 
	GROUP BY Year, Area, Item
	HAVING Year >= 2000) as p
JOIN 
	(SELECT `Year` , Entity , Code , Item , SUM(Value) as Luas_ha
	FROM `Penggunaan Lahan Minyak Nabati (long)`
	GROUP BY Year, Entity, Code,Item) as l
ON p.Year = l.Year AND p.Area = l.Entity AND p.Item = l.Item

-----------------------------------------------------------------------------------------------
-- Mengatasi nilai Null


SELECT *
FROM `Luas join produksi minyak nabati` ljpmn 


UPDATE `Luas join produksi minyak nabati`
SET Luas_ha = CASE WHEN Luas_ha is null then 0 Else Luas_ha END





