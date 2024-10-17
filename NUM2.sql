CREATE TABLE ST.gueg_LOG (
    DT DATE,
    LINK VARCHAR(50),
    USER_AGENT VARCHAR(200),
    REGION VARCHAR(30)
);

CREATE TABLE ST.gueg_LOG_REPORT (
    REGION VARCHAR(30),
    BROWSER VARCHAR(10)
);

INSERT INTO ST.gueg_LOG (DT, LINK, USER_AGENT, REGION)
SELECT 
    TO_DATE(REGEXP_SUBSTR(log.data, '\d{8}'), 'YYYYMMDD') AS DT,
    REGEXP_SUBSTR(log.data, '(http[^ \t]*)') AS LINK,
    TRIM(CONCAT(
        REGEXP_SUBSTR(log.data, '(\d+)\s+(\d+)\s+(Safari/[^ ]*)'),
        ' ',
        REGEXP_SUBSTR(log.data, '\(.*\)')
    )) AS USER_AGENT,
    TRIM(REGEXP_SUBSTR(ip.data, '\t(.*)')) AS REGION
FROM DE.log log
JOIN DE.ip ip ON REGEXP_SUBSTR(log.data, '^[^\t ]+') = REGEXP_SUBSTR(ip.data, '^[^\t]+');

INSERT INTO ST.gueg_LOG_REPORT (REGION, BROWSER)
SELECT 
    REGION,
    MIN(BROWSER) AS BROWSER
FROM (
    SELECT 
        REGION,
        CASE 
            WHEN USER_AGENT LIKE '%Firefox%' THEN 'Firefox'
            WHEN USER_AGENT LIKE '%Chrome%' THEN 'Chrome'
            WHEN USER_AGENT LIKE '%Safari%' THEN 'Safari'
            WHEN USER_AGENT LIKE '%Opera%' THEN 'Opera'
            ELSE 'Other'
        END AS BROWSER
    FROM 
        ST.gueg_LOG
) subquery
GROUP BY REGION
ORDER BY REGION;
