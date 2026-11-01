library(data.table)

# Load data
loan_working <- fread(
  "fannie_working_copy.csv"
)

# Origination variable AKA Things we know about when first getting a loan
loan_variables <- c(
  "loan_identifier",
  "origination_classic_fico",
  "dti",
  "original_ltv",
  "original_cltv",
  "original_upb",
  "original_interest_rate",
  "original_loan_term",
  "number_of_borrowers",
  "first_time_home_buyer_indicator",
  "loan_purpose",
  "property_type",
  "number_of_units",
  "occupancy_status",
  "channel",
  "mortgage_insurance_percentage",
  "mortgage_insurance_type",
  "high_balance_loan_indicator",
  "property_valuation_method"
)

# Select variables
loan_profile <- loan_working[
  ,
  ..loan_variables
]

# One row per loan (no dupes)
loan_profile <- loan_profile[
  ,
  .SD[1],
  by = loan_identifier
]

# Delinquency response variable
loan_target <- loan_working[
  ,
  .(
    delinquency_status = ifelse(
      any(
        grepl(
          "delinquent",
          current_loan_delinquency_status,
          ignore.case = TRUE
        ),
        na.rm = TRUE
      ),
      "Delinquent",
      "Not Delinquent"
    )
  ),
  by = loan_identifier
]

# Random Forest dataset
random_forest_data <- merge(
  loan_profile,
  loan_target,
  by = "loan_identifier"
)

# K-Means dataset
kmeans_data <- loan_profile[
  ,
  .(
    loan_identifier,
    origination_classic_fico,
    dti,
    original_ltv,
    original_upb,
    original_interest_rate,
    original_loan_term
  )
]

# Anomaly Detection dataset
anomaly_data <- loan_profile[
  ,
  .(
    loan_identifier,
    origination_classic_fico,
    dti,
    original_ltv,
    original_upb,
    original_interest_rate,
    original_loan_term
  )
]

# Save datasets
fwrite(
  random_forest_data,
  "random_forest_data.csv"
)

fwrite(
  kmeans_data,
  "kmeans_data.csv"
)

fwrite(
  anomaly_data,
  "anomaly_data.csv"
)
