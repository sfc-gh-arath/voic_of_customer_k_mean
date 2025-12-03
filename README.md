# Voice of Customer Topic k-Neighbourhood Modelling with AI_EMBED V2

A Snowflake-native solution for automatically clustering and labeling customer feedback using Snowflake Cortex AI capabilities, K-Means clustering, and intelligent topic labeling.

---

## 📋 Overview

This notebook implements an end-to-end Voice of Customer (VoC) analysis pipeline that:

1. **Extracts keywords** from customer reviews using Claude-4-Sonnet
2. **Generates embeddings** with Snowflake Arctic Embed model
3. **Clusters keywords** using K-Means with automatic K selection via silhouette scoring
4. **Labels clusters** using LLM-powered intelligent naming
5. **Performs sentiment analysis** at the aspect level
6. **Visualizes results** through an interactive Streamlit dashboard

---

## 🏗️ Architecture

```
┌─────────────────────┐     ┌──────────────────────┐     ┌─────────────────────┐
│   Product Reviews   │────▶│  Keyword Extraction  │────▶│  Snowflake Arctic   │
│   (PRODUCT_SURVEY)  │     │  (Claude-4-Sonnet)   │     │  Embed Embeddings   │
└─────────────────────┘     └──────────────────────┘     └─────────────────────┘
                                                                    │
                                                                    ▼
┌─────────────────────┐     ┌──────────────────────┐     ┌─────────────────────┐
│  Streamlit Dashboard│◀────│  Sentiment Analysis  │◀────│   K-Means Cluster   │
│   (Visualization)   │     │   (AI_SENTIMENT)     │     │   + LLM Labeling    │
└─────────────────────┘     └──────────────────────┘     └─────────────────────┘
```

---

## 🚀 Key Features

### 1. Intelligent Keyword Extraction
- Uses **Claude-4-Sonnet** via `AI_COMPLETE` to extract 1-6 product aspects per review
- Structured JSON output with schema validation
- Filters for concise, meaningful keywords (2-4 words)

### 2. Snowflake-Native Embeddings
- **Model**: `snowflake-arctic-embed-m-v1.5`
- Generates 768-dimensional embeddings for each unique keyword
- Deduplication ensures efficient embedding generation

### 3. Automatic K-Selection Clustering
- **Algorithm**: K-Means with L2 normalization (spherical clustering)
- **Dimensionality Reduction**: Optional PCA (10-100 components)
- **K Selection**: Silhouette score optimization over configurable range (default: K=6-10)
- **Singleton Handling**: Automatically merges single-member clusters into nearest neighbors (cosine similarity ≥ 0.75)

### 4. LLM-Powered Cluster Labeling
- Uses **Snowflake Llama 3.3 70B** for generating concise topic labels
- Context-aware prompts tailored for product feedback categorization
- Clean 1-3 word noun phrases for each cluster

### 5. Multi-Modal Classification Alternative
- **AI_CLASSIFY**: Alternative approach using predefined category labels
- Supports multi-label classification with custom descriptions
- Few-shot examples for improved accuracy

### 6. Aspect-Based Sentiment Analysis
- **AI_SENTIMENT**: Analyzes sentiment per topic/aspect
- Generates sentiment scores: Positive (1.0), Neutral (0.5), Negative (0.0)
- Quarterly trend analysis capabilities

---

## 📊 Output Tables

| Table Name | Description |
|------------|-------------|
| `SURVEY_KEY_TOPICS` | Source reviews with extracted keywords (JSON) |
| `SURVEY_KEYWORDS_EXPLODED` | One row per survey-keyword pair |
| `KEYWORD_EMBEDDINGS` | Unique keywords with their embedding vectors |
| `KEYWORD_CLUSTERS` | Keywords mapped to cluster IDs and labels |
| `CLUSTER_DICTIONARY` | Cluster metadata: ID, label, examples, size |
| `SURVEY_CLUSTER_OUTPUT` | Final survey-to-cluster-labels mapping |
| `SURVEY_CLUSTER_OUTPUT_ALT` | Alternative AI_CLASSIFY-based classification |
| `SENTIMENT_OUTPUT` | Aspect-level sentiment results |

---

## ⚙️ Configuration Parameters

```python
# Embedding Configuration
EMBED_MODEL      = "snowflake-arctic-embed-m-v1.5"
EMBED_BATCH_SIZE = 256

# Clustering Configuration
USE_PCA              = True
PCA_COMPONENTS       = 100        # Automatically capped by n-1
HDBSCAN_METRIC       = "euclidean"
MIN_SIM_TO_MERGE     = 0.75       # Cosine threshold for singleton merging

# K-Selection Range
K_MIN = 6
K_MAX = 10

# Labeling Configuration
LABEL_MODEL       = "snowflake-llama-3.3-70b"
MAX_LABEL_LEN     = 60
LABEL_TOP_K_WORDS = 12
```

---

## 📦 Prerequisites

### Snowflake Features Required
- **Snowflake Cortex** enabled on your account
- Access to the following Cortex functions:
  - `AI_COMPLETE` (Claude-4-Sonnet, Llama 3.3 70B)
  - `AI_EMBED` (Arctic Embed)
  - `AI_CLASSIFY`
  - `AI_SENTIMENT`
  - `AI_FILTER`

### Python Dependencies
```
numpy
pandas
scikit-learn
streamlit
snowflake-snowpark-python
```

---

## 🔧 Usage

### Step 1: Prepare Source Data
Ensure your survey data exists in a table with columns:
- `SURVEY_ID`: Unique identifier
- `REVIEW_TEXT`: Customer feedback text

### Step 2: Extract Keywords
```sql
-- Generates SURVEY_KEY_TOPICS table with extracted keywords
SELECT survey_id, review_text,
AI_COMPLETE(
  MODEL => 'CLAUDE-4-SONNET',
  PROMPT => 'Extract 1-6 concise product aspects...',
  response_format => {'type': 'json', ...}
) as KEYWORDS
FROM PRODUCT_SURVEY;
```

### Step 3: Run Clustering Pipeline
Execute cells 6-14 in sequence to:
1. Explode keywords
2. Generate embeddings
3. Perform clustering
4. Label clusters
5. Create output mappings

### Step 4: Analyze Sentiment
```sql
CREATE TABLE SENTIMENT_OUTPUT AS
SELECT SURVEY_ID, REVIEW_TEXT, CLUSTER_LABELS,
AI_SENTIMENT(REVIEW_TEXT, CLUSTER_LABELS) AS SENTIMENT
FROM SURVEY_CLUSTER_OUTPUT;
```

### Step 5: Launch Dashboard
The notebook includes an embedded Streamlit app for:
- Overall sentiment scores by product
- Top positive/negative labels per product
- Per-category quarterly trend analysis

---

## 📈 Sample Workflow

```
1. Load 10,000 product reviews
      ↓
2. Extract ~25,000 keyword phrases (avg 2.5 per review)
      ↓
3. Deduplicate to ~3,500 unique keywords
      ↓
4. Generate embeddings (768-dim vectors)
      ↓
5. PCA reduction to 100 dimensions
      ↓
6. K-Means clustering (K=8 auto-selected)
      ↓
7. Merge 12 singletons into nearest clusters
      ↓
8. Label 8 clusters: "Fit Quality", "Material Feel", etc.
      ↓
9. Map all surveys to their topic clusters
      ↓
10. Sentiment analysis per aspect + visualization
```

---

## 🎯 Use Cases

- **Product Development**: Identify top feature requests and pain points
- **Quality Assurance**: Track recurring quality issues by category
- **Marketing**: Understand what customers love about products
- **Customer Success**: Monitor sentiment trends over time
- **Competitive Analysis**: Compare topic distributions across product lines

---

## 📌 Notes & Tips

1. **Clustering Tuning**: Adjust `K_MIN` and `K_MAX` based on expected topic granularity
2. **Singleton Threshold**: Lower `MIN_SIM_TO_MERGE` to be more aggressive in merging small clusters
3. **PCA Components**: Increase for larger datasets with more semantic diversity
4. **Label Quality**: Customize the labeling prompt for domain-specific terminology
5. **Performance**: For >100K keywords, consider batch processing embeddings

---

## 📄 License

Internal use only. Requires valid Snowflake Cortex license.

---

## 👥 Authors

Created for Voice of Customer analysis using Snowflake Cortex AI capabilities.

