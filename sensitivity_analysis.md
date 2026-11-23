# Sensitivity Analysis

Sensitivity analysis was performed to see how changing model settings affected the results of the three data mining methods.

## K-Means Clustering

K-means was tested using different numbers of clusters: K = 2, 3, 4, and 5.

The same six standardized mortgage variables were used for each test.

### Results

| Number of Clusters (K) | SSE |
|---|---:|
| 2 | 1,299,777 |
| 3 | 1,093,427 |
| 4 | 943,193 |
| 5 | 842,851 |

SSE decreased as the number of clusters increased, but the improvements became smaller.

K = 3 was kept because it produced three mortgage groups that were easy to interpret.

## Anomaly Detection

Isolation Forest was tested using different percentages of loans flagged as anomalies.

The thresholds tested were the top 0.5%, 1%, and 2% of anomaly scores.

### Results

| Anomaly Threshold | Loans Flagged |
|---|---:|
| Top 0.5% | 1,332 |
| Top 1% | 2,663 |
| Top 2% | 5,326 |

Increasing the percentage increased the number of mortgages identified as anomalies.

The original 1% cutoff was kept because it identifies a small group of unusual mortgages without flagging too many loans.

## Random Forest

Two sensitivity tests were performed for Random Forest:

- Changing the prediction probability threshold
- Giving delinquent loans more weight during training

### Prediction Thresholds

The original model used a 2% probability threshold to classify mortgages as delinquent.

Thresholds of 1%, 2%, 5%, and 10% were compared.

| Threshold | Precision | Recall |
|---|---:|---:|
| 1% | 1.02% | 35.84% |
| 2% | 1.22% | 17.14% |
| 5% | 2.37% | 4.94% |
| 10% | 7.06% | 1.56% |

Lower thresholds increased recall but decreased precision.

Higher thresholds improved precision but caused the model to miss more delinquent loans.

This shows a trade-off between identifying more delinquent mortgages and reducing false positives.

### Class Weighting

A second Random Forest model was trained with delinquent loans given 10 times more weight.

Both models were compared using the same 2% prediction threshold.

| Metric | Original Model | Weighted Model |
|---|---:|---:|
| Precision | 1.22% | 1.28% |
| Recall | 17.14% | 17.66% |
| Correctly Identified Delinquent Loans | 66 | 68 |
| False Positives | 5,340 | 5,255 |

Class weighting slightly improved precision and recall.

However, the weighted model still missed most delinquent loans. Class weighting alone did not improve prediction performance.

