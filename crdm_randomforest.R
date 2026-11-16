library(ranger)

# Load data
loan_data <- read.csv("random_forest_data.csv")

# blank mortgage insurance field means no insurance recorded
loan_data$mortgage_insurance_percentage[
  is.na(loan_data$mortgage_insurance_percentage)] <- 0
loan_data$mortgage_insurance_type[
  is.na(loan_data$mortgage_insurance_type)] <- 0

# Remove rows with other missing values
loan_data <- na.omit(loan_data)

# Keep loan IDs, but do not use them to predict anything
loan_ids <- loan_data$loan_identifier
loan_data$loan_identifier <- NULL

# Quantitative vs categorical data
text_columns <- sapply(loan_data, is.character)
loan_data[text_columns] <- lapply(loan_data[text_columns], factor)
loan_data$mortgage_insurance_type <- factor(loan_data$mortgage_insurance_type)
loan_data$number_of_units <- factor(loan_data$number_of_units)

# Split the data for training and testing
set.seed(42)
train_rows <- sample(1:nrow(loan_data), size = round(0.8 * nrow(loan_data)))
train_data <- loan_data[train_rows, ]
test_data <- loan_data[-train_rows, ]

# Train with 100 trees
forest_model <- ranger(
  delinquency_status ~ .,
  data = train_data,
  num.trees = 100,
  probability = TRUE,
  importance = "impurity"
)

# Predict probability of delinquency
probabilities <- predict(forest_model, data = test_data)$predictions[, "Delinquent"]

# Label loans as delinquent if 2% prob
predictions <- ifelse(probabilities >= 0.02, "Delinquent", "Not Delinquent")

# Compare
actual <- test_data$delinquency_status
print(table(Actual = actual, Predicted = predictions))

# Check precision
correct_delinquent <- sum(predictions == "Delinquent" & actual == "Delinquent")
predicted_delinquent <- sum(predictions == "Delinquent")
actual_delinquent <- sum(actual == "Delinquent")

precision <- if (predicted_delinquent == 0) 0 else correct_delinquent / predicted_delinquent
recall <- if (actual_delinquent == 0) 0 else correct_delinquent / actual_delinquent

cat("Precision:", round(100 * precision, 2), "%\n")
cat("Recall:", round(100 * recall, 2), "%\n")
cat("Accuracy:", round(100 * mean(predictions == actual), 2), "%\n")

# See which variables the model used most
importance <- sort(forest_model$variable.importance, decreasing = TRUE)
print(importance)

# Save results
results <- data.frame(
  loan_identifier = loan_ids[-train_rows],
  actual = actual,
  predicted = predictions,
  probability = probabilities
)
write.csv(results, "random_forest_results.csv", row.names = FALSE)
write.csv(data.frame(variable = names(importance), importance = importance),
          "random_forest_importance.csv", row.names = FALSE)
