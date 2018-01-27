SET
client_encoding TO 'UTF-8';

-- Wyczyść log || DELETE
DELETE FROM product_price_log
;

-- Wszystkie ceny produktów z puchu o id=1
SELECT * FROM product
	WHERE down_id=1 AND price IS NOT NULL
;
SELECT * FROM product_price_log
;

-- Podnieść cenę produktów z puchu o id=1 o 5%
UPDATE product SET price=price*1.05 
	WHERE down_id = 1 AND price IS NOT NULL
;

-- Sprawdz efekt
SELECT * FROM product
	WHERE down_id=1 AND price IS NOT NULL
;
SELECT * FROM product_price_log
;