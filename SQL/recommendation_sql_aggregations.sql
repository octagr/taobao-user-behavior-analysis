-- ============================================================
-- 商品推荐分析 - PostgreSQL 数据聚合脚本
-- 导出后以 CSV 格式供 notebook 读取
-- ============================================================


-- ────────────────────────────────────────────────────────────
-- 1. 用户-品类行为聚合表（user_category_agg）
--    用途：构建 user × category 行为权重矩阵（CF主矩阵）
--    导出：\copy (...) TO 'user_category_agg.csv' WITH CSV HEADER
-- ────────────────────────────────────────────────────────────
\copy (
    SELECT
        user_id,
        category_id,
        COUNT(CASE WHEN behavior_type = 'pv'   THEN 1 END)::SMALLINT  AS pv_count,
        COUNT(CASE WHEN behavior_type = 'fav'  THEN 1 END)::SMALLINT  AS fav_count,
        COUNT(CASE WHEN behavior_type = 'cart' THEN 1 END)::SMALLINT  AS cart_count,
        COUNT(CASE WHEN behavior_type = 'buy'  THEN 1 END)::SMALLINT  AS buy_count
    FROM userbehavior_cleaning
    GROUP BY user_id, category_id
) TO 'user_category_agg.csv' WITH CSV HEADER;


-- ────────────────────────────────────────────────────────────
-- 2. 高频商品购买聚合表（item_buy_agg）
--    用途：关联规则 item 级事务集（只保留有购买行为的商品）
--    说明：buy_count 是该 user 对该 item 的购买次数
--          item 全局热度过滤在 Python 侧完成（ITEM_BUY_THRESHOLD）
--    导出：\copy (...) TO 'item_buy_agg.csv' WITH CSV HEADER
-- ────────────────────────────────────────────────────────────
\copy (
    SELECT
        user_id,
        item_id,
        category_id,
        COUNT(*)::SMALLINT AS buy_count
    FROM userbehavior_cleaning
    WHERE behavior_type = 'buy'
    GROUP BY user_id, item_id, category_id
) TO 'item_buy_agg.csv' WITH CSV HEADER;


-- ────────────────────────────────────────────────────────────
-- 3. （可选）只导出 buy 行为的原始记录（替代读全量 CSV）
--    用途：Step 1.5 训练/测试集时间切分，只需 buy 行为
--    如果 UserBehavior_cleaning.csv 太大不便读取，可用此代替
--    导出：\copy (...) TO 'buy_records.csv' WITH CSV HEADER
-- ────────────────────────────────────────────────────────────
\copy (
    SELECT
        user_id,
        item_id,
        category_id,
        behavior_type,
        datetime
    FROM userbehavior_cleaning
    WHERE behavior_type = 'buy'
    ORDER BY user_id, datetime
) TO 'buy_records.csv' WITH CSV HEADER;


-- ────────────────────────────────────────────────────────────
-- 4. （参考）品类热度统计（用于两阶段推荐的第二阶段：品类内选商品）
--    用途：在 CF 推荐出目标品类后，从该品类中按热度选 Top-N 商品
--    导出：\copy (...) TO 'category_item_popularity.csv' WITH CSV HEADER
-- ────────────────────────────────────────────────────────────
\copy (
    SELECT
        category_id,
        item_id,
        COUNT(CASE WHEN behavior_type = 'buy'  THEN 1 END) AS buy_cnt,
        COUNT(CASE WHEN behavior_type = 'cart' THEN 1 END) AS cart_cnt,
        COUNT(CASE WHEN behavior_type = 'pv'   THEN 1 END) AS pv_cnt,
        COUNT(DISTINCT user_id)                             AS unique_users,
        -- 综合热度分（可按需调整权重）
        COUNT(CASE WHEN behavior_type = 'buy'  THEN 1 END) * 5 +
        COUNT(CASE WHEN behavior_type = 'cart' THEN 1 END) * 3 +
        COUNT(CASE WHEN behavior_type = 'pv'   THEN 1 END) * 1 AS popularity_score
    FROM userbehavior_cleaning
    GROUP BY category_id, item_id
    ORDER BY category_id, popularity_score DESC
) TO 'category_item_popularity.csv' WITH CSV HEADER;
