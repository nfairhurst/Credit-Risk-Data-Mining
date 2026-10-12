library(data.table)
# =================================
# WARNING VERY COOL PROJECT AHEAD!
# =================================

loan_master <- fread(
  "2026Q1.csv",
  sep = "|",
  header = FALSE,
  fill = TRUE,
  na.strings = c("", "NA")
)

# Data dictionary -> columns
col_names <- c(
  "reference_pool_id",
  "loan_identifier",
  "monthly_reporting_period",
  "channel",
  "seller_name",
  "servicer_name",
  "master_servicer",
  "original_interest_rate",
  "current_interest_rate",
  "original_upb",
  "upb_at_issuance",
  "current_actual_upb",
  "original_loan_term",
  "origination_date",
  "first_payment_date",
  "loan_age",
  "remaining_months_to_legal_maturity",
  "remaining_months_to_maturity",
  "maturity_date",
  "original_ltv",
  "original_cltv",
  "number_of_borrowers",
  "dti",
  "borrower_credit_score_at_origination",
  "co_borrower_credit_score_at_origination",
  "first_time_home_buyer_indicator",
  "loan_purpose",
  "property_type",
  "number_of_units",
  "occupancy_status",
  "property_state",
  "msa_msda",
  "zip_code_short",
  "mortgage_insurance_percentage",
  "amortization_type",
  "prepayment_penalty_indicator",
  "interest_only_loan_indicator",
  "interest_only_first_pi_payment_date",
  "months_to_amortization",
  "current_loan_delinquency_status",
  "loan_payment_history",
  "modification_flag",
  "mortgage_insurance_cancellation_indicator",
  "zero_balance_code",
  "zero_balance_effective_date",
  "upb_at_time_of_removal",
  "repurchase_date",
  "scheduled_principal_current",
  "total_principal_current",
  "unscheduled_principal_current",
  "last_paid_installment_date",
  "foreclosure_date",
  "disposition_date",
  "foreclosure_costs",
  "property_preservation_and_repair_costs",
  "asset_recovery_costs",
  "miscellaneous_holding_expenses_and_credits",
  "associated_taxes_for_holding_property",
  "net_sales_proceeds",
  "credit_enhancement_proceeds",
  "repurchase_make_whole_proceeds",
  "other_foreclosure_proceeds",
  "modification_related_non_interest_bearing_upb",
  "principal_forgiveness_amount",
  "original_list_start_date",
  "original_list_price",
  "current_list_start_date",
  "current_list_price",
  "borrower_credit_score_at_issuance",
  "co_borrower_credit_score_at_issuance",
  "borrower_credit_score_current",
  "co_borrower_credit_score_current",
  "mortgage_insurance_type",
  "servicing_activity_indicator",
  "current_period_modification_loss_amount",
  "cumulative_modification_loss_amount",
  "current_period_credit_event_net_gain_or_loss",
  "cumulative_credit_event_net_gain_or_loss",
  "special_eligibility_program",
  "foreclosure_principal_write_off_amount",
  "relocation_mortgage_indicator",
  "zero_balance_code_change_date",
  "loan_holdback_indicator",
  "loan_holdback_effective_date",
  "delinquent_accrued_interest",
  "property_valuation_method",
  "high_balance_loan_indicator",
  "arm_initial_fixed_rate_period_le_5yr_indicator",
  "arm_product_type",
  "initial_fixed_rate_period",
  "interest_rate_adjustment_frequency",
  "next_interest_rate_adjustment_date",
  "next_payment_change_date",
  "index",
  "arm_cap_structure",
  "initial_interest_rate_cap_up_percent",
  "periodic_interest_rate_cap_up_percent",
  "lifetime_interest_rate_cap_up_percent",
  "mortgage_margin",
  "arm_balloon_indicator",
  "arm_plan_number",
  "borrower_assistance_plan",
  "high_ltv_refinance_option_indicator",
  "deal_name",
  "repurchase_make_whole_proceeds_flag",
  "alternative_delinquency_resolution",
  "alternative_delinquency_resolution_count",
  "total_deferral_amount",
  "payment_deferral_modification_event_indicator",
  "interest_bearing_upb",
  "origination_classic_fico",
  "issuance_classic_fico",
  "current_classic_fico"
)

stopifnot(
  ncol(loan_master) == length(col_names)
)

setnames(
  loan_master,
  col_names
)

# CREATE WORKING COPY
loan_working <- copy(
  loan_master
)


# Readable codes
loan_working[, loan_purpose := fcase(
  loan_purpose == "P", "Purchase",
  loan_purpose == "R", "Refinance",
  loan_purpose == "C", "Cash-Out Refinance",
  loan_purpose == "U", "Refinance - Not Specified",
  default = loan_purpose
)]

loan_working[, property_type := fcase(
  property_type == "SF", "Single-Family Home",
  property_type == "CO", "Condominium",
  property_type == "CP", "Co-operative",
  property_type == "PU", "Planned Urban Development",
  property_type == "MH", "Manufactured Home",
  default = property_type
)]

loan_working[, occupancy_status := fcase(
  occupancy_status == "P", "Principal Residence",
  occupancy_status == "S", "Second Home",
  occupancy_status == "I", "Investment Property",
  occupancy_status == "U", "Unknown",
  default = occupancy_status
)]

loan_working[, current_loan_delinquency_status := fcase(
  current_loan_delinquency_status == 0, "Current",
  current_loan_delinquency_status == 1, "30-59 days delinquent",
  current_loan_delinquency_status == 2, "60-89 days delinquent",
  current_loan_delinquency_status == 3, "90-119 days delinquent",
  current_loan_delinquency_status == 4, "120-149 days delinquent",
  current_loan_delinquency_status == 5, "150-179 days delinquent",
  current_loan_delinquency_status == 6, "180-209 days delinquent",
  default = as.character(current_loan_delinquency_status)
)]

# Dataset dimensions
dim(loan_working)

# Unique loans
uniqueN(
  loan_working$loan_identifier
)

# Create audit table
data_audit <- data.table(
  variable = names(loan_working),
  
  data_type = sapply(
    loan_working,
    function(x) class(x)[1]
  ),
  
  unique_values = sapply(
    loan_working,
    uniqueN
  ),
  
  missing_count = sapply(
    loan_working,
    function(x) sum(is.na(x))
  ),
  
  missing_percent = round(
    sapply(
      loan_working,
      function(x) mean(is.na(x)) * 100
    ),
    2
  )
)

data_audit

# Completely missing columns
all_missing_columns <- names(loan_working)[
  colSums(!is.na(loan_working)) == 0
]

all_missing_columns

# Columns with one non-missing value
constant_columns <- names(loan_working)[
  sapply(
    loan_working,
    function(x) uniqueN(na.omit(x))
  ) <= 1
]

constant_columns

# Exact duplicate rows
sum(
  duplicated(loan_working)
)

# Duplicate records for same loan and month
sum(
  duplicated(
    loan_working,
    by = c(
      "loan_identifier",
      "monthly_reporting_period"
    )
  )
)

# Summary statistics
summary(
  loan_working
)

# Outliers
outlier_variables <- c(
  "original_interest_rate",
  "current_interest_rate",
  "original_upb",
  "current_actual_upb",
  "original_loan_term",
  "loan_age",
  "original_ltv",
  "original_cltv",
  "dti",
  "borrower_credit_score_at_origination",
  "origination_classic_fico"
)

outlier_variables <- intersect(
  outlier_variables,
  names(loan_working)
)

outlier_counts <- sapply(
  loan_working[, ..outlier_variables],
  function(x) {
    
    q1 <- quantile(
      x,
      0.25,
      na.rm = TRUE
    )
    
    q3 <- quantile(
      x,
      0.75,
      na.rm = TRUE
    )
    
    iqr <- q3 - q1
    
    sum(
      x < q1 - 1.5 * iqr |
        x > q3 + 1.5 * iqr,
      na.rm = TRUE
    )
  }
)

outlier_counts

# Remove completely empty columns
loan_working <- loan_working[
  ,
  !all_missing_columns,
  with = FALSE
]

# Recalculate constant columns
constant_columns <- names(loan_working)[
  sapply(
    loan_working,
    function(x) uniqueN(na.omit(x))
  ) <= 1
]

# Remove constant columns
loan_working <- loan_working[
  ,
  !constant_columns,
  with = FALSE
]

# Remove exact duplicate rows
loan_working <- unique(
  loan_working
)

# Results
dim(
  loan_working
)

sum(
  duplicated(loan_working)
)

# Check remaining
round(
  colMeans(
    is.na(loan_working)
  ) * 100,
  2
)

# Save to working
fwrite(
  data_audit,
  "fannie_data_audit.csv"
)

fwrite(
  loan_working,
  "fannie_working_copy.csv"
)
