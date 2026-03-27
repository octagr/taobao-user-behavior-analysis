CREATE TABLE user_features AS
SELECT
    user_id,

    -- 行为频次
    COUNT(*) FILTER (WHERE behavior_type = 'pv')   AS pv_count,
    COUNT(*) FILTER (WHERE behavior_type = 'fav')  AS fav_count,
    COUNT(*) FILTER (WHERE behavior_type = 'cart') AS cart_count,
    COUNT(*) FILTER (WHERE behavior_type = 'buy')  AS buy_count,
    COUNT(*)                                        AS total_count,

    -- 行为比例
    COUNT(*) FILTER (WHERE behavior_type = 'pv')::float   / COUNT(*) AS pv_ratio,
    COUNT(*) FILTER (WHERE behavior_type = 'fav')::float  / COUNT(*) AS fav_ratio,
    COUNT(*) FILTER (WHERE behavior_type = 'cart')::float / COUNT(*) AS cart_ratio,
    COUNT(*) FILTER (WHERE behavior_type = 'buy')::float  / COUNT(*) AS buy_ratio,

    -- 转化漏斗特征
    COUNT(*) FILTER (WHERE behavior_type = 'cart')::float /
        NULLIF(COUNT(*) FILTER (WHERE behavior_type = 'pv'), 0)   AS cart_per_pv,
    COUNT(*) FILTER (WHERE behavior_type = 'buy')::float /
        NULLIF(COUNT(*) FILTER (WHERE behavior_type = 'cart'), 0) AS buy_per_cart,
    COUNT(*) FILTER (WHERE behavior_type = 'buy')::float /
        NULLIF(COUNT(*) FILTER (WHERE behavior_type = 'pv'), 0)   AS buy_per_pv,
    COUNT(*) FILTER (WHERE behavior_type = 'buy')::float /
        NULLIF(COUNT(*) FILTER (WHERE behavior_type = 'fav'), 0)  AS buy_per_fav,

    -- 活跃天数
    COUNT(DISTINCT DATE(datetime)) AS active_days,

    -- 时间段行为占比
    COUNT(*) FILTER (WHERE EXTRACT(HOUR FROM datetime) BETWEEN 6  AND 11)::float / COUNT(*) AS morning_ratio,
    COUNT(*) FILTER (WHERE EXTRACT(HOUR FROM datetime) BETWEEN 12 AND 17)::float / COUNT(*) AS afternoon_ratio,
    COUNT(*) FILTER (WHERE EXTRACT(HOUR FROM datetime) BETWEEN 18 AND 23)::float / COUNT(*) AS evening_ratio,
    COUNT(*) FILTER (WHERE EXTRACT(HOUR FROM datetime) BETWEEN 0  AND 5)::float  / COUNT(*) AS midnight_ratio,

    -- 漏斗深度
    MAX(CASE behavior_type
        WHEN 'pv'   THEN 1
        WHEN 'fav'  THEN 2
        WHEN 'cart' THEN 3
        WHEN 'buy'  THEN 4
    END) AS funnel_depth
FROM userbehavior
GROUP BY user_id;