# 淘宝用户行为数据分析与推荐系统
# Taobao User Behavior Data Analysis and Recommendation System

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![License: Data](https://img.shields.io/badge/Data%20License-Tianchi-blue.svg)](DATA_LICENSE)

## 项目简介 / Project Overview

本项目基于阿里云天池平台的淘宝用户行为数据集，通过数据挖掘技术深入分析用户行为模式，构建用户画像体系，并设计一套高效的电商推荐系统。

This project analyzes Taobao user behavior data from Alibaba Cloud Tianchi platform. Through data mining techniques, we analyze user behavior patterns, construct user portrait systems, and design an efficient e-commerce recommendation system.

## 数据来源 / Data Source

| 项目 / Item | 内容 / Content |
|------------|----------------|
| **数据平台 / Platform** | 阿里云天池 Tianchi |
| **数据集 / Dataset** | User Behavior Data from Taobao |
| **数据链接 / Data Link** | https://tianchi.aliyun.com/dataset/dataDetail?dataId=649 |
| **数据时间范围 / Data Period** | 2017-11-25 至 2017-12-03 |
| **数据许可 / Data License** | 天池平台协议，仅供学习研究 / Tianchi Terms, Educational Use Only |

> **注意 / Note**: 原始数据集不在 GitHub 仓库中，请从天池平台下载 / Raw dataset is not in this repo, download from Tianchi platform

## 项目结构 / Project Structure

```
userbehavior/
├── SQL/                                    # PostgreSQL SQL 脚本 / SQL Scripts
│   ├── creat_table_user_features.sql       # 用户聚合特征表 / User Aggregated Feature Table
│   └── recommendation_sql_aggregations.sql # 推荐指标聚合表 / Recommendation Metric Aggregation
│
├── notebook/                               # Jupyter 分析笔记本 / Jupyter Notebooks
│   ├── data_cleaning.ipynb                 # 数据清洗 / Data Cleaning
│   ├── User_behavior_clustering_analysis.ipynb  # 用户画像与聚类 / User Portrait & Clustering
│   ├── Funnel_Conversion_Analysis.ipynb     # 转化漏斗分析 / Funnel Conversion Analysis
│   ├── Temporal_Behavior_Analysis.ipynb     # 时间行为分析 / Temporal Behavior Analysis
│   ├── Category_Conversion_Rate.ipynb      # 品类转化率分析 / Category Conversion Rate
│   ├── product_recommendation_step1.ipynb   # 推荐系统：数据准备 / Recommendation: Data Prep
│   ├── product_recommendation_step2.ipynb   # 推荐系统：关联规则 / Recommendation: Association Rules
│   ├── product_recommendation_step3.ipynb   # 推荐系统：协同过滤 / Recommendation: CF
│   └── product_recommendation_step4.ipynb   # 推荐系统：模型评估 / Recommendation: Evaluation
│
├── *.png                                   # 分析可视化图表 / Analysis Visualizations
├── README.md                               # 项目说明文档 / Project Documentation
├── 数据分析报告.md                          # 完整分析报告 / Complete Analysis Report
├── LICENSE                                 # MIT 代码许可证 / MIT Code License
├── DATA_LICENSE                            # 数据集使用声明 / Dataset Usage Declaration
└── CLAUDE.md                               # 项目指导文档 / Project Guidance
```

## 技术栈 / Tech Stack

| 类别 / Category | 技术 / Technology |
|----------------|-------------------|
| 编程语言 / Language | Python 3.x |
| 数据处理 / Data Processing | pandas, numpy |
| 机器学习 / Machine Learning | scikit-learn |
| 推荐系统 / Recommendation | implicit (ALS), mlxtend (FP-Growth) |
| 可视化 / Visualization | matplotlib |
| 稀疏矩阵 / Sparse Matrix | scipy.sparse |

## 环境配置 / Environment Setup

### 方式一：pip 安装 / Option 1: pip install

```bash
pip install pandas numpy scikit-learn implicit mlxtend matplotlib scipy jupyter
```

### 方式二：requirements.txt / Option 2: requirements.txt

项目包含 `requirements.txt` 文件，可直接安装：

```bash
pip install -r requirements.txt
```

## 数据准备 / Data Preparation

### 获取数据集 / Get the Dataset

1. 访问 [阿里云天池](https://tianchi.aliyun.com/dataset/dataDetail?dataId=649) / Visit Tianchi
2. 下载原始数据集 / Download the raw dataset
3. 将文件重命名为 `UserBehavior.csv` / Rename to `UserBehavior.csv`
4. 放置在项目根目录 / Place in project root

### 数据清洗 / Data Cleaning

```bash
cd notebook
jupyter notebook
# 运行 data_cleaning.ipynb / Run data_cleaning.ipynb
```

清洗后生成 `UserBehavior_cleaning.csv`

## 分析流程 / Analysis Pipeline

| 步骤 / Step | 文件 / File | 说明 / Description |
|------------|-------------|-------------------|
| 1 | `data_cleaning.ipynb` | 数据清洗，过滤时间范围和异常值 / Data cleaning, filter date range and outliers |
| 2 | `User_behavior_clustering_analysis.ipynb` | 用户画像与KMeans聚类（6类用户）/ User portrait & KMeans clustering |
| 3 | `Funnel_Conversion_Analysis.ipynb` | 用户口径和次数口径漏斗分析 / User and count-based funnel analysis |
| 4 | `Temporal_Behavior_Analysis.ipynb` | 小时和星期维度时间行为分析 / Hourly and weekly temporal analysis |
| 5 | `Category_Conversion_Rate.ipynb` | 品类转化率和GMV分析 / Category CVR and GMV analysis |
| 6 | `product_recommendation_step1.ipynb` | 推荐系统数据准备 / Recommendation data preparation |
| 7 | `product_recommendation_step2.ipynb` | FP-Growth关联规则挖掘 / FP-Growth association rules |
| 8 | `product_recommendation_step3.ipynb` | ALS和User-CF协同过滤建模 / ALS and User-CF collaborative filtering |
| 9 | `product_recommendation_step4.ipynb` | 模型评估与对比 / Model evaluation and comparison |

## 核心功能 / Core Features

### 1. 用户画像聚类 / User Portrait Clustering

基于18维特征的用户聚类分析，识别6类用户群体：

| 用户类型 / User Type | 占比 / Ratio | 核心特征 / Key Features |
|---------------------|-------------|------------------------|
| 纯浏览型 / Pure Browsing | 21.9% | PV占比96%，购买转化极低 / PV 96%, low conversion |
| 高价值活跃型 / High-Value Active | 6.6% | 全环节活跃，转化率最高 / Fully active, highest conversion |
| 收藏研究型 / Research-Oriented | 15.0% | 收藏占比12% / Favoriting ratio 12% |
| 加车犹豫型 / Cart-Hesitant | 11.7% | 加购占比21% / Cart ratio 21% |
| 冲动直购型 / Impulse Buyer | 6.8% | 购买/PV转化率20% / Purchase/PV rate 20% |
| 普通活跃型 / Normal Active | 38.1% | 最大群体，指标均衡 / Largest group, balanced |

### 2. 转化漏斗分析 / Conversion Funnel Analysis

- **用户口径**：独立用户的转化情况 / Unique user conversion
- **次数口径**：行为频次的转化情况 / Behavior count conversion
- **关键流失**：加购/收藏→购买（流失率33.58%）/ Key loss: Cart/Fav→Buy (33.58%)

### 3. 时间行为分析 / Temporal Behavior Analysis

| 维度 / Dimension | 流量峰值 / Traffic Peak | 转化率峰值 / CVR Peak |
|-----------------|------------------------|----------------------|
| 小时 / Hour | 13时 / 13:00 | 凌晨2-4时 / 02:00-04:00 |
| 星期 / Weekday | 周六 / Saturday | 周一 / Monday |

### 4. 推荐系统 / Recommendation System

| 模块 / Module | 算法 / Algorithm | 结果 / Result |
|--------------|-----------------|---------------|
| 关联规则 / Association Rules | FP-Growth | 43条强关联规则 / 43 strong rules |
| 协同过滤 / Collaborative Filtering | User-CF + ALS | ALS表现最优 / ALS performs best |
| 推荐策略 / Strategy | 两阶段 / Two-stage | 品类级→商品级 / Category→Item |

**评估结果 (Precision@10) / Evaluation Results**:

| 模型 / Model | Precision@10 | Recall@10 | NDCG@10 |
|-------------|-------------|----------|---------|
| 热门基准 / Popular Baseline | 1.03% | 10.31% | 0.0518 |
| User-CF | 1.30% | 13.04% | 0.0737 |
| **ALS** | **1.97%** | **19.68%** | **0.0912** |

## 可视化图表 / Visualizations

分析生成的可视化图表文件：

| 图表 / Chart | 文件 / File | 说明 / Description |
|-------------|-------------|-------------------|
| 用户特征热力图 | `cluster_heatmap.png` | 6类用户18维特征对比 / 6 user types × 18 features |
| 用户行为雷达图 | `cluster_radar.png` | 各簇用户行为模式 / Cluster behavior patterns |
| 用户规模分布 | `cluster_distribution.png` | 各簇用户数量占比 / Cluster user distribution |
| 转化漏斗图 | `conversion_funnel.png` | 双口径漏斗转化 / Dual funnel conversion |
| 时间行为图 | `time_behavior_analysis.png` | 时间维度行为分布 / Temporal behavior distribution |
| 品类分析图 | `product_category_analysis.png` | 品类GMV与转化率 / Category GMV and CVR |

![用户聚类分布](cluster_distribution.png)
![用户特征热力图](cluster_heatmap.png)
![转化漏斗分析](conversion_funnel.png)
![时间行为分析](time_behavior_analysis.png)
![品类分析](product_category_analysis.png)

## 分析报告 / Analysis Report

完整的数据分析报告请查看：

- [数据分析报告.md](数据分析报告.md) (中文 / Chinese)

报告包含以下章节：

- 用户画像与聚类分析 / User Portrait & Clustering (6类用户 / 6 user types)
- 转化漏斗分析 / Conversion Funnel Analysis (双口径 / Dual perspectives)
- 时间行为分析 / Temporal Behavior Analysis (小时+星期 / Hour + Weekday)
- 品类转化率分析 / Category Conversion Rate Analysis
- 推荐系统设计 / Recommendation System Design (四步流水线 / 4-step pipeline)
- 综合结论与业务建议 / Conclusions & Business Recommendations
- **数据字典与方法论** / Data Dictionary & Methodology
- **局限性与注意事项** / Limitations & Caveats

## 可复现性 / Reproducibility

### 环境要求 / Requirements

- Python 3.8+
- 8GB+ RAM (推荐 / Recommended)
- 10GB+ 磁盘空间 / Disk space

### 复现步骤 / Reproduce

1. 克隆仓库 / Clone repository
2. 下载数据集 / Download dataset
3. 安装依赖 / Install dependencies: `pip install -r requirements.txt`
4. 按顺序运行 notebook / Run notebooks in order

详细说明请参阅 [数据分析报告.md](数据分析报告.md) 中的"复现指南"部分。

## 许可证 / License

| 文件 / File | 类型 / Type | 说明 / Description |
|------------|-----------|-------------------|
| `LICENSE` | MIT | 代码许可证 / Code License |
| `DATA_LICENSE` | Tianchi | 数据集使用声明 / Dataset Usage Declaration |

## 项目局限性 / Project Limitations

1. **数据时间范围有限**：数据集仅覆盖9天（2017-11-25至2017-12-03），可能无法反映长期用户行为模式
   Limited data period (9 days) may not reflect long-term behavior patterns

2. **双十二影响**：数据涵盖双十二预热期，用户行为可能受促销活动影响
   Data includes Double-12 pre-heating period, behaviors may be promotion-influenced

3. **品类粒度**：分析基于品类级别，商品级别的推荐效果可能不同
   Analysis is at category level, item-level recommendations may differ

4. **数据脱敏**：原始数据已脱敏，某些分析（如价格敏感度）可能受限
   Data is anonymized, some analyses (e.g., price sensitivity) may be limited

## 联系方式 / Contact

如有问题或建议，欢迎提交 Issue 或 Pull Request。

For questions or suggestions, feel free to open an Issue or Pull Request.

---

**数据来源 / Data Source**: 阿里云天池 Tianchi Platform  
**数据链接 / Data Link**: https://tianchi.aliyun.com/dataset/dataDetail?dataId=649  
**许可证 / License**: [LICENSE](LICENSE) | [DATA_LICENSE](DATA_LICENSE)
