INSERT INTO QB1O_BOOK_INFO (book_id, category, title, author, price)
SELECT 
    id AS book_id,
    SUBSTRING_INDEX(SUBSTRING_INDEX(html_content, '<h1>', -1), '</h1>', 1) AS category,
    SUBSTRING_INDEX(SUBSTRING_INDEX(html_content, 'class="title">', -1), '</', 1) AS title,
    SUBSTRING_INDEX(SUBSTRING_INDEX(html_content, 'class="author">', -1), '</', 1) AS author,
    REPLACE(REPLACE(SUBSTRING_INDEX(SUBSTRING_INDEX(html_content, 'class="price">', -1), '</', 1), '$', ''), ',', '') AS price
FROM 
    DE.HTML_DATA;
