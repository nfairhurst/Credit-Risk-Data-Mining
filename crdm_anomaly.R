library(isotree)

# Load the dataset
loans <- read.csv("anomaly_data.csv")

# Select the variables for anomaly detection
features <- loans[, c(
  "origination_classic_fico",
  "dti",
  "original_ltv",
  "original_upb",
  "original_interest_rate",
  "original_loan_term"
)]

# Remove missing values
keep <- complete.cases(features)
loans <- loans[keep, ]
features <- features[keep, ]

# Run Isolation Forest
set.seed(356)
model <- isolation.forest(features, ntrees = 100)

# Give each loan an anomaly score
loans$anomaly_score <- predict(model, features, type = "score")

# Top 1% most unusual loans
cutoff <- quantile(loans$anomaly_score, 0.99)
loans$anomaly <- ifelse(loans$anomaly_score >= cutoff,
                        "Anomaly", "Normal")

# Count number of anomalies
print(table(loans$anomaly))

# Compare average mortgage characteristics between groups
anomaly_summary <- aggregate(
  features,
  by = list(group = loans$anomaly),
  FUN = mean
)
print(anomaly_summary)

# Save the results
write.csv(loans, "anomaly_results.csv", row.names = FALSE)
write.csv(anomaly_summary, "anomaly_summary.csv", row.names = FALSE)
write.csv(loans[loans$anomaly == "Anomaly", ],
          "flagged_anomalies.csv", row.names = FALSE)

# Plot the distribution of anomaly scores
hist(loans$anomaly_score,
     main = "Mortgage Anomaly Scores",
     xlab = "Anomaly Score")
abline(v = cutoff, col = "red", lwd = 2)

# Visualize two dimensions of the data using a sample
set.seed(42)
sample_rows <- sample(nrow(loans), min(5000, nrow(loans)))
plot(loans$origination_classic_fico[sample_rows],
     loans$dti[sample_rows],
     col = ifelse(loans$anomaly[sample_rows] == "Anomaly",
                  "red", "gray"),
     pch = 16, cex = 0.5,
     xlab = "Credit Score",
     ylab = "DTI (%)",
     main = "Unusual Mortgage Profiles")
