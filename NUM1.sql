CREATE TABLE st.gueg_BOOK_INFO (
    book_id VARCHAR(255) NOT NULL,
    category VARCHAR(255) NULL,
    title VARCHAR(255) NULL,
    author VARCHAR(255) NULL,
    price DECIMAL(10, 2) NULL,
    PRIMARY KEY (book_id)
);


INSERT INTO st.gueg_BOOK_INFO (book_id, category, title, author, price)
SELECT 
    ROW_NUMBER() OVER () AS book_id,
    (matches.category)[1] AS category,
    (matches.title)[1] AS title,
    (matches.author)[1] AS author,
    CAST(TRIM(BOTH ' ' FROM REPLACE(REGEXP_REPLACE((matches.price)[1], '[^0-9.]', '', 'g'), '₽', '')) AS DECIMAL(10, 2)) AS price
FROM DE.HTML_DATA,
LATERAL (
    SELECT 
        regexp_matches(value, '<h1>(.*?)</h1>') AS category,
        regexp_matches(value, 'class="title">(.*?)</div>') AS title,
        regexp_matches(value, 'class="author">(.*?)</p>') AS author,
        regexp_matches(value, 'class="price">([^<]+)') AS price
) AS matches
WHERE (matches.category)[1] IS NOT NULL;
