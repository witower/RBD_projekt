-- Wszystkie Kategorie || ORDER BY
SELECT * FROM category ORDER BY sort;


-- Wszystkie Rodzaje puchów
SELECT * FROM down;


-- Wszystkie Serie, w czytelnej formie || ZŁĄCZENIE BEZ "JOIN"
SELECT C.sort*1000+S.sort AS sort, concat(C.descr_id, '.', S.descr_id) AS code, S.name, C.name_singular AS category, construction, outer_fabric, inner_fabric
	FROM serie S, category C
	WHERE S.category_id = C.id
	ORDER BY sort ASC;
	-- istnieje na to widok, więc można tak:
	SELECT * FROM serie_friendly;


-- Wszystkie Rozmiary dla kategorii typu 'Śpiwór%' || INNER JOIN, LIKE, sort DESC
SELECT size.name, category.name_singular AS category
	FROM size
	INNER JOIN category 
		ON category_id = category.id
	WHERE category.name_singular LIKE 'Śpiwór%'
	ORDER BY category.sort, size.sort DESC;


-- Ile serii w kategoriach || GRUPOWANIE, FUNKCJA AGREGUJĄCA count(), HAVING
SELECT category.name_plural AS category, count(category_id) AS "count"
	FROM serie
	RIGHT OUTER JOIN category --dzięki temu pokażą się też kategorie bez serii
		ON serie.category_id = category.id
	GROUP BY category.id HAVING count(category_id) < 3 --wyświetli tylko te, które mają mniej niż 3 serie
	ORDER BY category.sort ASC;
	-- istnieje na to widok (podobny), więc można tak:
	SELECT * FROM serie_per_category; 


-- Znajdz rozmiary, ktore nie zostaly uzyte w zadnym szablonie rozmiarow(template_size)?.
--  || ZAGNIEŻDŻENIE skorelowane.
SELECT size.id, size.name, category.name_plural AS category 
	FROM "size", category
		WHERE category_id = category.id 
			AND size.id NOT IN (
				SELECT size_id FROM template_size
			);


-- Znajdz Produkty z ceną nieokreśloną || NULL
-- Przygotowanie wyniku
UPDATE product SET price = NULL
	WHERE id = 20;
SELECT * FROM product
	WHERE price IS NULL;


-- Znajdz Produkty z cena okreslona || IS NOT NULL
SELECT * FROM product
	WHERE price IS NOT NULL;


-- Wszystkie SerieModelSize w czytelnej formie || KOLUMNA Z WYNIKIEM OPERACJI ARYTMETYCZNEJ
SELECT 
	concat(serie.name, ' ', serie_model.model) AS serie_model, 
	size.name AS size, 
	weight_down,
	weight_down*100/weight_total AS down_to_total_weight_ratio,
	weight_total, 
	down_chambers_qty
	FROM serie_model_size, serie_model, serie, size
	WHERE serie_model_id = serie_model.id 
		AND serie_model.serie_id = serie.id
		AND size_id = size.id;


-- Produkty już nie nowe ||OPERACJE ARYTMETYCZNE NA DATACH oraz UPDATE
-- Przygotowanie wyniku
UPDATE product SET product_creation_date = current_timestamp - interval '30 days'
	WHERE id = 30;
SELECT * FROM product
	WHERE current_timestamp - product_creation_date >= interval '14 days';


-- Wszystkie SerieModelDown w czytelnej formie || BETWEEN
SELECT concat(S."name", ' ', SM.model) AS serie_model, D."name" AS down, temperature_men 
	FROM serie_model_down, serie_model SM, serie S, down D
	WHERE serie_model_id = SM.id
		AND SM.serie_id = S.id
		AND down_id = D.id
		AND temperature_men BETWEEN -30 AND -1;
	-- istnieje na to widok, więc można tak:
	SELECT * FROM serie_model_down_friendly;







/* Scenario:
 * 
 * 1. Tworzysz Kategorie i rozmiary. Chyba nie ma sensu tworzyc listy size_list *-* size i size_list 1-* category. Powielanie zestawów rozmiarów można zdziałać inaczej (skopiowania w tracie tworzenia nowej). Z kolei po co powiazanie Size *-1 Category? Aby zachowac spojnosc rozmiarow w kategorii. Tzn. nie każda seria będzie miała wszystkie, ale żadna nie będzie mogła mieć rozmiaru z innej kategorii.
 * 1a. Możesz już utworzyć template_size (Dodaj szablon) i rule tworzy wiersze wg listy rozmiarow kategorii. Jeśli dodasz do kategorii rozmiar, a template już istnieje to select wyświetli ci info o osieroconym rozmiarze.
 * 2. Tworzysz Serie. (albo atrybut "Produkty z wypełnieniem (make use of models and down kind variations)".
 * 2a Przypisujesz template_id do Serii (pozniej ulepszyc o brak tej koniecznosci).
 * 3. Przypisujesz do serii modele (to wywoluje rule po insercie). Na podstawie serie.template_id i serie_model.model dodaje wiersze w SerieModelSize. Co z insert_db.sql? Zeby sie nie dublowaly (!)
 * 3a Serie-modelom dodajemy puchy puchy (tabela SerieModelDown) unique!
 * Podział tabel na SerieModel i SerieModelDown, niby nie potrzebny... ale do czego potem dodawać SerieModelSize. Trzeba by było tworzyć jakąś kolumnę obliczeniową w SerieModelDown, który tworzyłaby klucz np. na podstawie klucza głównego i wartości modelu. Z drugiej strony to nie takie głupie, żeby model był szukany po id serii i wartosci kolumny model... skoro model nic soba nie wnosi. Dobra tutaj będzie prościej chyba opcja paranoic consistency ;) czyli dwie tabele
 * 4. Uruchamia sie RULE, ktore tworzy rekordy Product, po INSERT w SerieModelDown. Podstawa serie.template_id oraz serie_model_down. Poki brak ceny domyslnie not active chyba ze recznie zmienisz.
 * 
 * 
 * 
 * 
 * UPDATE bedzie na podstawie wgrania cen i objetosci itp. (tabela product)
 */

--^^ ZATWIERDZONE :)
---------------------------------------------------------------------------------------------------
-- TESTOWANE
--SELECT *
--	FROM product prod INNER JOIN (
	
		SELECT 
			concat(C.descr_id, '.', S.descr_id, '.', M.model, '.', W.size_id, '.', T.down_id, '-', P.price ) AS "code", *
			FROM category C, serie S, serie_model M, serie_model_down T, serie_model_size W, product P
			WHERE 
				S.category_id = C.id AND
				M.serie_id = S.id AND
				T.serie_model_id = M.id AND
				W.serie_model_id = M.id AND
				P.down_id = T.down_id AND
				P.size_id = W.size_id AND (
				P.serie_model_id = T.serie_model_id OR
				P.serie_model_id = W.serie_model_id)
		;
				
				
--	) foo ON prod.serie_model_id = foo. AND
--		prod.down_id = T.down_id AND
--		prod.size_id = W.size_id;


--
-- SELECT imie, nazwisko FROM klient 
--  WHERE nr IN (
--    SELECT klient_nr FROM zamowienie Z 
--    )
--      ORDER BY nazwisko
-- ;
--






SELECT serie."name" AS "serie", SM.model AS "model", SMS.descr_id AS "size", SMD.descr_id AS "down", temperature_men, weight_down, weight_total, down_chambers_qty 
	FROM 
		serie, serie_model_down SMD
		INNER JOIN serie_model_size SMS
			ON SMD.serie_model_id = SMS.serie_model_id
		INNER JOIN serie_model SM
			ON SM.id = SMD.serie_model_id
	WHERE SM.serie_id IN (
		SELECT id FROM serie)
;


-- SELECT * FROM serie_model; -- słownik dla _down i _size
-- SELECT * FROM template; łączy size z template
-- SELECT * FROM template_size;
