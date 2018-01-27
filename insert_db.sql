SET client_encoding TO 'UTF-8';
-- Multiple row INSERT VALUES

-- Category
INSERT INTO category (descr_id,sort,name_singular,name_plural) VALUES 
	('spi',1,'Śpiwór puchowy','Śpiwory puchowe'),
	('kur',2,'Kurtka puchowa','Kurtki puchowe'),
	('kam',3,'Kamizelka puchowa','Kamizelki puchowe'),
	('spo',4,'Spodnie puchowe','Spodnie puchowe'),
	('bot',5,'Botki puchowe','Botki puchowe'),
	('rek',6,'Rękawice puchowe','Rękawice puchowe'),
	('odd',99,'Inny','Inne');


-- Down
INSERT INTO down (descr_id,name,description,cost_per_kilo,resilience_declared)	values
	('p850','850 cuin','100% nowy polski puch gęsi biały, o proporcjach 95/5 i sprężystości 850 cuin.',1200,850),
	('p750','750 cuin','100% nowy polski puch gęsi biały, o proporcjach 90/10 i sprężystości 750 cuin.',900,750),
	('p600','600 cuin','100% nowy polski puch kaczy biały, o proporcjach 85/15 i sprężystości 600 cuin.',350,600);


-- Size
INSERT INTO size (category_id,name,sort) VALUES 
	(1,'S/R',1),
	(1,'M/R',2),
	(1,'L/R',3),
	(2,'S',1),
	(2,'M',2),
	(2,'L',3),
	(1,'XXXL/W', 99);

	
-- Template
INSERT INTO template (descr_id,category_id) VALUES 
	('VL.sz',1),
	('CM.sz',1),
	('PRT.sz',2),
	('ARC.sz',2) ;


INSERT INTO template_size (size_id,template_id,values) VALUES 
	(1,1,'175/205	|	78/65/52'),
	(2,1,'190/220	|	78/65/52'),
	(3,1,'205/235	|	78/65/52'),
	(1,2,'175/205	|	78/70/58'),
	(2,2,'190/220	|	78/70/58'),
	(3,2,'205/235	|	78/70/58'),
	(4,3,'66'),
	(5,3,'70'),
	(6,3,'74'),
	(4,4,'76'),
	(5,4,'80'),
	(6,4,'84');

-- Serie
INSERT INTO serie (descr_id,name,sort,category_id, construction, outer_fabric, inner_fabric, template_id) VALUES 
	('vl','Voyager Light',1,1, 'H', 'Microlight', 'Quantum',1),
	('ev','Everest',18,1, 'HH', 'Microlight', 'Microlight',1),
	('prv','Proton Vario',1,2, 'H', 'Quantum', 'Quantum',3) ,
	('ast','Asterion',15,2, 'H extra shell', 'Endurance', 'Microlight',4);


-- SerieModel
INSERT INTO serie_model (serie_id,model) VALUES 
	(1,200),
	(1,300),
	(2,900),
	(2,1100),
	(3,250),
	(3,300),
	(4,400),
	(4,500);
	
-- SerieModelDown - Śpiwory
INSERT INTO serie_model_down (serie_model_id,down_id,temperature_men) VALUES 
	(1,	2,	5),
	(2,	2,	0),
	(1,	1,	4),
	(2,	1,	-2),
	(3,	2,	-29),
	(4,	2,	-37),
	(3,	1,	-34),
	(4,	1,	-44);

	
-- SerieModelDown - Kurtki
INSERT INTO serie_model_down (serie_model_id,down_id) VALUES 
	(5,1),
	(6,1),
	(5,2),
	(6,2),
	(7,1),
	(8,1),
	(7,2),
	(8,2) ;


-- SerieModelSize
INSERT INTO serie_model_size (serie_model_id,size_id,weight_down,weight_total,down_chambers_qty) VALUES 
	(1, 	1, 	189, 	660, 	'28'),
	(1, 	2, 	206, 	700, 	'30'),
	(1, 	3, 	217, 	740, 	'32'),
	(2, 	1, 	279, 	750, 	'28'),
	(2, 	2, 	306, 	800, 	'30'),
	(2, 	3, 	323, 	840, 	'32'),
	(3, 	1, 	850, 	1630, 	'43'),
	(3, 	2, 	921, 	1730, 	'45'),
	(3, 	3, 	968, 	1830, 	'47'),
	(4, 	1, 	1031, 	1810, 	'43'),
	(4, 	2, 	1124, 	1930, 	'45'),
	(4, 	3, 	1174, 	2040, 	'47'),
	(5, 	4, 	231, 	735, 	'112'),
	(5, 	5, 	249, 	795, 	'112'),
	(5, 	6, 	266, 	850, 	'112'),
	(6, 	4, 	282, 	809, 	'112'),
	(6, 	5, 	300, 	869, 	'112'),
	(6, 	6, 	317, 	924, 	'112'),
	(7, 	4, 	430, 	1100, 	'35+9'),
	(7, 	5, 	455, 	1180, 	'35+9'),
	(7, 	6, 	475, 	1220, 	'35+9'),
	(8, 	4, 	548, 	1220, 	'35+9'),
	(8, 	5, 	573, 	1300, 	'35+9'),
	(8, 	6, 	593, 	1340, 	'35+9');

-- Product
INSERT INTO product (serie_model_id,size_id,down_id,volume,price) VALUES 
	(1,  	1, 	2, 	4.2, 	764), 
	(1,  	1, 	1, 	5.0, 	882), 
	(1,  	2, 	2, 	5.0, 	794), 
	(1,  	2, 	1, 	5.9, 	920), 
	(1,  	3, 	2, 	5.0, 	817), 
	(1,  	3, 	1, 	5.9, 	937), 
	(2,  	1, 	2, 	5.0, 	845), 
	(2,  	1, 	1, 	5.9, 	998), 
	(2,  	2, 	2, 	5.9, 	884), 
	(2,  	2, 	1, 	6.9, 	1049), 
	(2,  	3, 	2, 	5.9, 	917), 
	(2,  	3, 	1, 	6.9, 	1087), 
	(3,  	1, 	2, 	16.3, 	1833), 
	(3,  	1, 	1, 	18.2, 	2257), 
	(3,  	2, 	2, 	18.2, 	1931), 
	(3,  	2, 	1, 	20.7, 	2387), 
	(3,  	3, 	2, 	20.7, 	2016), 
	(3,  	3, 	1, 	22.9, 	2495), 
	(4,  	1, 	2, 	18.2, 	2014), 
	(4,  	1, 	1, 	20.7, 	2519), 
	(4,  	2, 	2, 	20.7, 	2134), 
	(4,  	2, 	1, 	22.9, 	2679), 
	(4,  	3, 	2, 	22.9, 	2236), 
	(4,  	3, 	1, 	27.1, 	2806), 
	(5,  	4, 	2, 	NULL, 	1458), 
	(5,  	4, 	1, 	NULL, 	1603), 
	(5,  	5, 	2, 	NULL, 	1511), 
	(5,  	5, 	1, 	NULL, 	1665), 
	(5,  	6, 	2, 	NULL, 	1577), 
	(5,  	6, 	1, 	NULL, 	1734), 
	(6,  	4, 	2, 	NULL, 	1552), 
	(6,  	4, 	1, 	NULL, 	1727), 
	(6,  	5, 	2, 	NULL, 	1609), 
	(6,  	5, 	1, 	NULL, 	1793), 
	(6,  	6, 	2, 	NULL, 	1678), 
	(6,  	6, 	1, 	NULL, 	1868), 
	(7,  	4, 	2, 	NULL, 	1941), 
	(7,  	4, 	1, 	NULL, 	2208), 
	(7,  	5, 	2, 	NULL, 	2004), 
	(7,  	5, 	1, 	NULL, 	2282), 
	(7,  	6, 	2, 	NULL, 	2064), 
	(7,  	6, 	1, 	NULL, 	2353), 
	(8,  	4, 	2, 	NULL, 	2063), 
	(8,  	4, 	1, 	NULL, 	2381), 
	(8,  	5, 	2, 	NULL, 	2126), 
	(8,  	5, 	1, 	NULL, 	2457), 
	(8,  	6, 	2, 	NULL, 	2186), 
	(8,  	6, 	1, 	NULL, 	2528);

