# 淘宝用户行为数据分析与推荐系统

## 项目简介

本项目基于阿里云天池平台的淘宝用户行为数据集，通过数据挖掘技术深入分析用户行为模式，构建用户画像体系，并设计一套高效的电商推荐系统。

## 数据来源

- **数据平台**：阿里云天池（Tianchi）
- **数据集名称**：淘宝用户行为数据（User Behavior Data from Taobao）- **Dataset Name**: User Behavior Data from Taobao
- **数据链接**：https://tianchi.aliyun.com/dataset/dataDetail?dataId=649- **Data Link**: https://tianchi.aliyun.com/dataset/dataDetail?dataId=649
- **数据时间范围**：2017-11-25 至 2017-12-03
- **使用许可**：本数据集遵循阿里云天池平台的数据使用协议，仅供学习研究和学术交流使用，不得用于商业用途。

**注意**：原始数据集不在GitHub仓库中，请从天池平台下载。

## 项目结构

```
userbehavior
├── SQL/                                # PostgreSQL pgAdmin4├── SQL/                               # PostgreSQL pgAdmin4
|   ├── creat_table_user_features.sql   # 用户聚合特征表│   ├── creat_table_user_features.sql        # User Aggregated Feature Table
|   ├── recommendation_sql_aggregations.sql  # 推荐指标聚合表│   ├── recommendation_sql_aggregations.sql  # Recommendation Metric Aggregation Table
├── notebook/                           # Jupyter 分析笔记本├── notebook/                           # Jupyter analysis notebooks
│   ├── data_cleaning.ipynb              # 数据清洗│   ├── data_cleaning.ipynb              # Data cleaning
│   ├── User_behavior_clustering_analysis.ipynb  # 用户画像与聚类│   ├── User_behavior_clustering_analysis.ipynb  # User portrait and clustering analysis
│   ├── Funnel_Conversion_Analysis.ipynb  # 转化漏斗分析│   ├── Funnel_Conversion_Analysis.ipynb  # Funnel Conversion Analysis
│   ├── Temporal_Behavior_Analysis.ipynb  # 时间行为分析│   ├── Temporal_Behavior_Analysis.ipynb  # Temporal Behavior Analysis
│   ├── Category_Conversion_Rate.ipynb    # 品类转化率分析│   ├── Category_Conversion_Rate.ipynb    # Category Conversion Rate Analysis
│   ├── product_recommendation_step1.ipynb # 推荐系统：数据准备│   ├── product_recommendation_step1.ipynb # Recommendation System: Data Preparation
│   ├── product_recommendation_step2.ipynb # 推荐系统：关联规则│   ├── product_recommendation_step2.ipynb # Recommendation System: Association Rules
│   └── product_recommendation_step3.ipynb # 推荐系统：协同过滤│   └── product_recommendation_step3.ipynb # Recommendation System: Collaborative Filtering
├── 数据分析报告.md                      # 完整分析报告         ├── DataAnalysisReport.md       #Complete analytical report
├── CLAUDE.md                           # 项目指导文档        ├── CLAUDE.md                   # Project guidance document           
    └── README.md                       # 项目说明文档        └── README.md                   # Project description document
```

## 技术栈

- Python 3.x
- 数据处理：pandas, numpy
- 机器学习：scikit-learn
- 推荐系统：implicit (ALS), mlxtend (FP-Growth)
- 可视化：matplotlib
- 稀疏矩阵：scipy.sparse

## 数据准备

1. 从[阿里云天池](https://tianchi.aliyun.com/dataset/dataDetail?dataId=649)下载原始数据集
2. 将下载的数据文件命名为 `UserBehavior.csv` 并放在项目根目录下
3. 运行 `notebook/data_cleaning.ipynb` 进行数据清洗，生成 `UserBehavior_cleaning.csv`

## 核心功能

### 1. 用户画像聚类

- 6类用户画像：纯浏览型、高价值活跃型、收藏研究型、加车犹豫型、冲动直购型、普通活跃型
- 基于频次、比例、转化率、时间分布等18维特征

### 2. 转化漏斗分析

- 用户口径和次数口径双维度分析
- 识别关键流失节点：加购/收藏→购买（流失率33.58%）

### 3. 时间行为分析

- 小时维度：流量峰值13时，转化率峰值凌晨2-4时
- 星期维度：流量峰值周六，转化率峰值周一

### 4. 推荐系统

- **关联规则**：FP-Growth挖掘品类间关联，43条强关联规则
- **协同过滤**：User-Based CF（簇内相似度）+ ALS矩阵分解
- **两阶段策略**：ALS推荐品类 → 品类内按热度推荐商品
- **评估结果**：ALS Precision@10 = 1.97%，优于User-CF和热门基准

## 运行说明

### 环境配置

```bash
# 安装依赖
pip install pandas numpy scikit-learn implicit mlxtend matplotlib scipy jupyter
```

### 数据分析流程

1. 数据清洗：运行 `notebook/data_cleaning.ipynb`
2. 用户聚类：运行 `notebook/User_behavior_clustering_analysis.ipynb`
3. 漏斗分析：运行 `notebook/Funnel_Conversion_Analysis.ipynb`
4. 时间分析：运行 `notebook/Temporal_Behavior_Analysis.ipynb`
5. 品类分析：运行 `notebook/Category_Conversion_Rate.ipynb`
6. 推荐系统：
   - 数据准备：运行 `notebook/product_recommendation_step1.ipynb`
   - 关联规则：运行 `notebook/product_recommendation_step2.ipynb`
   - 协同过滤：运行 `notebook/product_recommendation_step3.ipynb`

## 分析报告

完整的数据分析报告请查看：[数据分析报告.md](数据分析报告.md)

报告包含以下内容：
- 用户画像与聚类分析（6类用户）
- 转化漏斗分析（用户口径+次数口径）
- 时间行为分析（小时+星期）
- 品类转化率分析
- 推荐系统设计（四步流水线）
- 综合结论与业务建议

## 许可声明

本项目的代码和分析结果仅供学习和研究使用。

**数据许可**：
- 原始数据集遵循阿里云天池平台的数据使用协议
- 不得用于商业用途
- 不得重新分发原始数据集

**代码许可**：
- 本项目代码可自由使用和学习

## 联系方式

如有问题或建议，欢迎提交Issue。

---

**数据来源**：阿里云天池（Tianchi）平台
**数据链接**：https://tianchi.aliyun.com/dataset/dataDetail?dataId=649
