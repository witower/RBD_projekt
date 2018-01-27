SET
client_encoding TO 'UTF-8';

CREATE
	TABLE
		category(
			id SERIAL CONSTRAINT category_pk PRIMARY KEY,
			descr_id VARCHAR(64) UNIQUE NOT NULL,
			sort SMALLINT,
			name_singular VARCHAR(128) NOT NULL,
			name_plural VARCHAR(128) NOT NULL
		);

CREATE
	TABLE
		down(
			id SERIAL CONSTRAINT down_pk PRIMARY KEY,
			descr_id VARCHAR(64) UNIQUE NOT NULL,
			name TEXT NOT NULL,
			description TEXT,
			cost_per_kilo DECIMAL(
				12,
				2
			),
			resilience_declared SMALLINT NOT NULL
		);

CREATE
	TABLE
		size(
			id SERIAL CONSTRAINT size_pk PRIMARY KEY,
			--descr_id VARCHAR(64), --UNIQUE NOT NULL future,
			category_id INTEGER, -- tylko na potrzeby spójności listy nazw rozmiarów w kategorii (consider if redundant)
			name TEXT NOT NULL,
			sort INTEGER,
			CONSTRAINT fk_size__category_id FOREIGN KEY(category_id) REFERENCES category(id),
			CONSTRAINT unique_size_in_category UNIQUE (name,category_id)
		);

CREATE
	TABLE
		template(
			id SERIAL CONSTRAINT template_pk PRIMARY KEY,
			descr_id VARCHAR(64) UNIQUE NOT NULL,
			category_id INTEGER NOT NULL,
			CONSTRAINT fk_template__category_id FOREIGN KEY(category_id) REFERENCES category(id)
		);

CREATE
	TABLE
		template_size(
			id SERIAL CONSTRAINT template_size_pk PRIMARY KEY,
			size_id INTEGER NOT NULL,
			template_id INTEGER NOT NULL,
		VALUES TEXT NOT NULL,
		CONSTRAINT fk_template_size__size_id FOREIGN KEY(size_id) REFERENCES SIZE(id),
		CONSTRAINT fk_template_size__template_id FOREIGN KEY(template_id) REFERENCES template(id),
		CONSTRAINT unique_size_in_template UNIQUE (size_id,template_id)
		);

CREATE
	TABLE
		serie(
			id SERIAL CONSTRAINT serie_pk PRIMARY KEY,
			descr_id VARCHAR(64) UNIQUE NOT NULL, -- dodać wylicznie | problem UNIQUE
			NAME TEXT NOT NULL,
			sort INTEGER,
			construction TEXT,
			outer_fabric TEXT,
			inner_fabric TEXT,
			category_id INTEGER NOT NULL,
			template_id INTEGER,
			CONSTRAINT fk_serie__category_id FOREIGN KEY(category_id) REFERENCES category(id),
			CONSTRAINT fk_serie__template_id FOREIGN KEY(template_id) REFERENCES template(id),
			CONSTRAINT unique_serie_in_category UNIQUE (name, category_id)
		);

CREATE
	TABLE
		serie_model(
			id SERIAL CONSTRAINT serie_model_pk PRIMARY KEY,
			--descr_id VARCHAR(64), -- UNIQUE NOT NULL, -- dodać wylicznie | problem UNIQUE - może: vl200p850-93847598 czyli true id suffixed
			serie_id INTEGER NOT NULL,
			model SMALLINT,
			CONSTRAINT fk_serie_model__serie_id FOREIGN KEY(serie_id) REFERENCES serie(id),
			CONSTRAINT unique_model_in_serie UNIQUE (serie_id,model)
		);
-- po insercie powyzej, RULE (przy zalozeniu, ze wszystkie dane sa):
-- Tworzy kombinacje w SerieModelSize

CREATE
	TABLE
		serie_model_down(
			id SERIAL CONSTRAINT serie_model_down_pk PRIMARY KEY,
			--descr_id VARCHAR(64), -- UNIQUE NOT NULL, -- dodać wylicznie | problem UNIQUE - może: vl200p850-93847598 czyli true id suffixed
			serie_model_id INTEGER NOT NULL,
			down_id INTEGER NOT NULL,
			temperature_men SMALLINT,
			CONSTRAINT fk_serie_model_down__down_id FOREIGN KEY(down_id) REFERENCES down(id),
			CONSTRAINT fk_serie_model_down__serie_model_id FOREIGN KEY(serie_model_id) REFERENCES serie_model(id),
			CONSTRAINT unique_down_in_seriemodel UNIQUE (serie_model_id,down_id)
		);
-- po insercie powyzej, RULE (przy zalozeniu, ze wszystkie dane sa):
-- Tworzy kombinacje w Product

CREATE
	TABLE -- WAGI i ILOSCI KOMOR
		serie_model_size(
			id SERIAL CONSTRAINT serie_model_size_pk PRIMARY KEY,
			--descr_id VARCHAR(64), -- UNIQUE NOT NULL, -- dodać wylicznie | problem UNIQUE - jw.
			serie_model_id INTEGER NOT NULL,
			size_id INTEGER NOT NULL,
			weight_down INTEGER,
			weight_total INTEGER,
			down_chambers_qty TEXT,
			CONSTRAINT fk_serie_model_size__serie_model_id FOREIGN KEY(serie_model_id) REFERENCES serie_model(id),
			CONSTRAINT fk_serie_model_size__size_id FOREIGN KEY(size_id) REFERENCES SIZE(id),
			CONSTRAINT weights_reasonable CHECK(weight_down <= weight_total),
			CONSTRAINT unique_size_in_seriemodel UNIQUE (serie_model_id,size_id)
		); -- powyższa tabela ma być wstępnie uzupełniana RULE po INSERT na wiersz serie_model, gdy istnieją dane serie.template_id = template_size.template_id 

CREATE
	TABLE -- CENY i OBJETOSCI
		product(
			id SERIAL CONSTRAINT product_pk PRIMARY KEY,
			--descr_id VARCHAR(64),  -- UNIQUE NOT NULL, -- dodać wylicznie | problem UNIQUE - jw.
			serie_model_id INTEGER NOT NULL,
			size_id INTEGER NOT NULL,
			down_id INTEGER NOT NULL, --dla niepuchowych (future), moze byc 0.
			volume DECIMAL(
				12,
				2
			),
			price DECIMAL(
				12,
				2
			),
			product_creation_date TIMESTAMP WITH TIME ZONE DEFAULT current_timestamp,
			--price_last_modification_date TIMESTAMP WITH TIME ZONE DEFAULT current_timestamp,
			--serie_model_down_id INTEGER,-- NOT NULL,
			--serie_model_size_id INTEGER,-- NOT NULL,		
			CONSTRAINT fk_product__serie_model_id FOREIGN KEY(serie_model_id) REFERENCES serie_model(id),
			CONSTRAINT fk_product__down_id FOREIGN KEY(down_id) REFERENCES down(id),
			CONSTRAINT fk_product__size_id FOREIGN KEY(size_id) REFERENCES size(id),
			CONSTRAINT dates_reasonable CHECK(product_creation_date <= current_timestamp),
			CONSTRAINT unique_serie_model_size_down_in_product UNIQUE (serie_model_id,size_id,down_id)
		);


CREATE OR REPLACE VIEW serie_per_category AS
	SELECT category.name_plural AS category, count(category_id) AS "count"
		FROM serie
			RIGHT OUTER JOIN category
				ON serie.category_id = category.id
		GROUP BY category.id
		ORDER BY category.sort ASC;


--CREATE OR REPLACE VIEW serie_friendly_full AS
--	SELECT *
--		FROM serie S, category C
--		WHERE S.category_id = C.id;


CREATE OR REPLACE VIEW serie_friendly AS
	SELECT C.sort*1000+S.sort AS sort, concat(C.descr_id, '.', S.descr_id) AS code, S.name, C.name_singular AS category, construction, outer_fabric, inner_fabric, C.id AS "cid", S.id AS "sid"
		FROM serie S, category C
		WHERE S.category_id = C.id
		ORDER BY sort ASC;

--CREATE OR REPLACE VIEW serie_model_friendly AS
--	SELECT  AS model
--		FROM serie_model SM
--			INNER JOIN serie_friendly S
--				ON SM.serie_id = S.sid;
		
CREATE OR REPLACE VIEW serie_model_down_friendly AS
	SELECT concat(serie."name", ' ', serie_model.model) AS serie_model, down."name" AS down, temperature_men 
		FROM serie_model_down, serie_model, serie, down
		WHERE serie_model_id = serie_model.id 
			AND serie_model.serie_id = serie.id
			AND down_id = down.id
		ORDER BY sort;