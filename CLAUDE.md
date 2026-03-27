# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

这是基于淘宝用户行为数据的电商数据分析与推荐系统项目，包含数据清洗、用户画像聚类、漏斗转化分析、时间行为分析及三阶段商品推荐系统。

## 项目结构

```
notebook/                     # Jupyter 分析笔记本
├── data_cleaning.ipynb               # 数据清洗（处理缺失值、重复值、异常值，时间范围过滤）
├── User_behavior_clustering_analysis.ipynb  # 用户画像与 KMeans 聚类（6类用户）
├── Funnel_Conversion_Analysis.ipynb  # 转化漏斗分析
├── Temporal_Behavior_Analysis.ipynb  # 时间行为分析（小时/星期维度）
├── Category_Conversion_Rate.ipynb    # 品类转化率分析
├── product_recommendation_step1.ipynb # 推荐系统：数据准备与矩阵构建
├── product_recommendation_step2.ipynb # 推荐系统：关联规则挖掘（FP-Growth）
└── product_recommendation_step3.ipynb # 推荐系统：协同过滤模型（User-CF + ALS）与评估

UserBehavior.csv                # 原始数据（约 1 亿条记录）
UserBehavior_cleaning.csv       # 清洗后数据
User_features.csv               # 用户特征表（98万用户 × 19特征）
user_cluster_labels.csv         # 用户聚类标签（6类）
```

## 数据处理流程

### 1. 数据清洗 (data_cleaning.ipynb)
- 过滤时间范围：2017-11-25 至 2017-12-03
- 过滤 PV 次数：1 < pv_count < 1000
- 处理行为类型：pv, cart, fav, buy
- 输出：UserBehavior_cleaning.csv（约 8687 万条）

### 2. 用户聚类 (User_behavior_clustering_analysis.ipynb)
**6 类用户画像：**
| 簇 | 名称 | 特征描述 |
|---|---|---|
| 0 | 纯浏览型 | PV占比96%，购买转化极低 |
| 1 | 高价值活跃型 | PV高、购买率高、转化漏斗深 |
| 2 | 收藏研究型 | 收藏占比高（12%），购买较少 |
| 3 | 加车犹豫型 | 加购占比高（21%），购买转化中等 |
| 4 | 冲动直购型 | 购买/PV转化率高达20% |
| 5 | 普通活跃型 | 最大人群，各项指标均衡 |

**特征工程：**
- 频次特征：log1p 变换
- 比例特征：pv_ratio, fav_ratio, cart_ratio, buy_ratio
- 转化率：cart_per_pv, buy_per_cart, buy_per_pv, buy_per_fav
- 时间特征：morning_ratio, afternoon_ratio, evening_ratio, midnight_ratio

### 3. 推荐系统数据准备 (product_recommendation_step1.ipynb)
**核心数据结构：**
- `user_item_matrix.npz`: 稀疏矩阵 (982,731 用户 × 8,244 品类)，值为 log1p(score)
- `buy_mask_matrix.npz`: 0/1 矩阵，标记已购买品类
- `artifacts_small.pkl`: 包含索引映射、测试集、事务集

**行为权重：** pv=1, fav=2, cart=3, buy=5
**过滤阈值：** MIN_USER_CAT=2, MIN_CAT_USER=5

### 4. 关联规则 (product_recommendation_step2.ipynb)
- Category 级：FP-Growth，min_support=0.002，Lift≥1, Confidence≥0.1 → 43 条规则
- Item 级：放弃（购买过于分散，平均每商品仅出现 6.49 次）
- 分簇规则：每簇单独挖掘规则

### 5. 协同过滤 (product_recommendation_step3.ipynb)
- User-Based CF：簇内计算相似度，簇5用热门替代
- ALS (implicit): factors=64, iterations=20, alpha=40

## 关键技术细节

### 内存优化
- 指定 dtype：user_id=int32, category_id=int32, buy_count=int16, cluster=int8
- 使用 chunksize 分块读取大文件
- 稀疏矩阵：csr_matrix 存储用户-品类交互

### 数据加载模式
```python
# 大文件分块读取
for chunk in pd.read_csv(path, chunksize=5_000_000, dtype=dtypes):
    ...

# 稀疏矩阵加载
from scipy.sparse import load_npz
matrix = load_npz('user_item_matrix.npz')
```

### 评估指标
- Precision@K, Recall@K, NDCG@K
- 测试集构造：每个用户最后一次购买作为 ground truth

## 数据规模汇总

| 数据 | 规模 |
|---|---|
| 原始行为记录 | ~1 亿条 |
| 清洗后记录 | ~8687 万条 |
| 用户数 | 983,847 |
| 品类数 | 9,377 → 过滤后 8,244 |
| 用户-品类交互 | 21,693,100 条 |
| 购买记录 | 1,750,826 条 |
| 矩阵密度 | 0.27% |

## 关键洞察

### 漏斗转化
- PV → 加购/收藏：15.59% 流失率
- 加购/收藏 → 购买：33.58% 流失率（最大流失节点）
- 收藏→购买转化率：70.61%
- 加购→购买转化率：36.84%

### 时间行为
- 流量峰值：周六下午 13 时
- 购买转化率最高：周一
- 凌晨 2-4 时转化率最高（静默时段）