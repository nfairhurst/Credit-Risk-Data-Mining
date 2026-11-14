# Load the dataset
loans <- read.csv("kmeans_data.csv")

# Select the variables for clustering
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

# Standardize the variables
scaled_features <- scale(features)

# Elbow method: test K = 1 through 6
# Use a sample to make this faster!
set.seed(42)
sample_rows <- sample(nrow(scaled_features), 
                      min(5000, nrow(scaled_features)))
sample_data <- scaled_features[sample_rows, ]

sse <- numeric(6)

for (k in 1:6) {
  result <- kmeans(sample_data, centers = k, nstart = 10)
  sse[k] <- result$tot.withinss
}

plot(1:6, sse, type = "b", pch = 16,
     xlab = "Number of Clusters",
     ylab = "SSE",
     main = "Elbow Method")

# Run K-Means using 3 clusters
set.seed(42)
model <- kmeans(scaled_features, centers = 3, nstart = 10)

# Assign each mortgage to a cluster
loans$cluster <- model$cluster

# Count the loans in each cluster
table(loans$cluster)

# Find average characteristics of each cluster
cluster_summary <- aggregate(
  features,
  by = list(cluster = loans$cluster),
  FUN = mean
)

print(cluster_summary)

# Save the results
write.csv(loans, "kmeans_results.csv", row.names = FALSE)
write.csv(cluster_summary, "kmeans_summary.csv", row.names = FALSE)

# Visualize two dimensions of the clusters
plot(loans$origination_classic_fico[sample_rows],
     loans$dti[sample_rows],
     col = loans$cluster[sample_rows],
     pch = 16, cex = 0.5,
     xlab = "Credit Score",
     ylab = "DTI (%)",
     main = "Mortgage Clusters")
