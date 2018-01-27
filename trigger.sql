SET client_encoding TO 'UTF-8';

DROP TABLE IF EXISTS product_price_log ;

CREATE TABLE product_price_log (
	changed_id INTEGER,
	changed_price DECIMAL(12,2),
	change_time TIMESTAMP WITH TIME ZONE DEFAULT current_timestamp
);

CREATE OR REPLACE RULE price_log AS 
	ON UPDATE TO product 
	WHERE old.price IS DISTINCT FROM new.price -- IS DISCTINCT FROM => true gdy zmiana z lub na NULL, a <> nie.
	DO ALSO INSERT INTO product_price_log
		VALUES (old.id, old.price, current_timestamp)
;