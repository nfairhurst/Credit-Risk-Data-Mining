library(data.table)
library(ggplot2)

# Avoid scientific notation (Makes it easier to read plots!)
options(scipen = 999)

# Create plots folder
dir.create(
  "plots",
  showWarnings = FALSE
)

# Load working data
loan_working <- fread(
  "fannie_working_copy.csv"
)

# One row per loan (Multiple months in dataset)
loan_level <- loan_working[
  ,
  .SD[1],
  by = loan_identifier
]

# Dataset dimensions
dim(loan_working)
dim(loan_level)

# Summary statistics
summary(
  loan_level[, .(
    origination_classic_fico,
    dti,
    original_ltv,
    original_cltv,
    original_upb,
    original_interest_rate,
    original_loan_term
  )]
)

# Credit score distribution
ggplot(
  loan_level,
  aes(x = origination_classic_fico)
) +
  geom_histogram(
    bins = 30,
    na.rm = TRUE
  ) +
  labs(
    title = "Classic FICO Credit Score at Origination",
    x = "Credit Score",
    y = "Number of Loans"
  ) +
  theme_minimal()

ggsave(
  "plots/credit_score_distribution.png",
  width = 7,
  height = 5
)

# Debt-to-income distribution
ggplot(
  loan_level,
  aes(x = dti)
) +
  geom_histogram(
    bins = 30,
    na.rm = TRUE
  ) +
  labs(
    title = "Debt-to-Income Ratio",
    x = "Debt-to-Income Ratio",
    y = "Number of Loans"
  ) +
  theme_minimal()

ggsave(
  "plots/dti_distribution.png",
  width = 7,
  height = 5
)

# Loan-to-value distribution
ggplot(
  loan_level,
  aes(x = original_ltv)
) +
  geom_histogram(bins = 30) +
  labs(
    title = "Original Loan-to-Value Ratio",
    x = "Loan-to-Value Ratio",
    y = "Number of Loans"
  ) +
  theme_minimal()

ggsave(
  "plots/ltv_distribution.png",
  width = 7,
  height = 5
)

# Original loan balance distribution
ggplot(
  loan_level,
  aes(x = original_upb)
) +
  geom_histogram(bins = 30) +
  labs(
    title = "Original Unpaid Principal Balance",
    x = "Original Loan Balance",
    y = "Number of Loans"
  ) +
  theme_minimal()

ggsave(
  "plots/loan_balance_distribution.png",
  width = 7,
  height = 5
)

# Interest rate distribution
ggplot(
  loan_level,
  aes(x = original_interest_rate)
) +
  geom_histogram(bins = 30) +
  labs(
    title = "Original Mortgage Interest Rate",
    x = "Interest Rate",
    y = "Number of Loans"
  ) +
  theme_minimal()

ggsave(
  "plots/interest_rate_distribution.png",
  width = 7,
  height = 5
)

# Loan term groups
loan_level[, loan_term_group := fcase(
  original_loan_term <= 180,
  "15 Years or Less",
  
  original_loan_term > 180 &
    original_loan_term < 360,
  "More Than 15 Years, Less Than 30",
  
  original_loan_term == 360,
  "30 Years",
  
  default = "Other"
)]

# Loan term distribution
ggplot(
  loan_level,
  aes(x = loan_term_group)
) +
  geom_bar() +
  labs(
    title = "Original Loan Term",
    x = "Loan Term",
    y = "Number of Loans"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(
      angle = 20,
      hjust = 1
    )
  )

ggsave(
  "plots/loan_term_distribution.png",
  width = 7,
  height = 5
)

# Loan purpose
ggplot(
  loan_level,
  aes(x = loan_purpose)
) +
  geom_bar() +
  labs(
    title = "Loan Purpose",
    x = "Loan Purpose",
    y = "Number of Loans"
  ) +
  theme_minimal()

ggsave(
  "plots/loan_purpose.png",
  width = 7,
  height = 5
)

# Occupancy status
ggplot(
  loan_level,
  aes(x = occupancy_status)
) +
  geom_bar() +
  labs(
    title = "Occupancy Status",
    x = "Occupancy Status",
    y = "Number of Loans"
  ) +
  theme_minimal()

ggsave(
  "plots/occupancy_status.png",
  width = 7,
  height = 5
)

# Property type
ggplot(
  loan_level,
  aes(x = property_type)
) +
  geom_bar() +
  labs(
    title = "Property Type",
    x = "Property Type",
    y = "Number of Loans"
  ) +
  theme_minimal()

ggsave(
  "plots/property_type.png",
  width = 7,
  height = 5
)

# Readable channel names
loan_level[, channel := fcase(
  channel == "R", "Retail",
  channel == "C", "Correspondent",
  channel == "B", "Broker",
  default = channel
)]

# Origination channel
ggplot(
  loan_level,
  aes(x = channel)
) +
  geom_bar() +
  labs(
    title = "Origination Channel",
    x = "Channel",
    y = "Number of Loans"
  ) +
  theme_minimal()

ggsave(
  "plots/origination_channel.png",
  width = 7,
  height = 5
)

# Loan-level delinquency
loan_delinquency <- loan_working[
  ,
  .(
    origination_classic_fico =
      first(origination_classic_fico),
    
    dti =
      first(dti),
    
    original_ltv =
      first(original_ltv),
    
    original_upb =
      first(original_upb),
    
    original_interest_rate =
      first(original_interest_rate),
    
    delinquency_group = ifelse(
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

# Loan-level delinquency counts
loan_delinquency_counts <- loan_delinquency[
  ,
  .N,
  by = delinquency_group
]

loan_delinquency_counts[
  ,
  percent := N / sum(N) * 100
]

# Loan delinquency distribution
ggplot(
  loan_delinquency_counts,
  aes(
    x = delinquency_group,
    y = percent
  )
) +
  geom_col() +
  geom_text(
    aes(
      label = paste0(
        round(percent, 2),
        "%"
      )
    ),
    vjust = -0.5
  ) +
  labs(
    title = "Loan Delinquency Status",
    x = "Loan Status",
    y = "Percent of Loans"
  ) +
  scale_y_continuous(
    labels = function(x) paste0(x, "%"),
    limits = c(0, 105)
  ) +
  theme_minimal()

ggsave(
  "plots/delinquency_status.png",
  width = 7,
  height = 5
)

# Delinquency counts
table(
  loan_delinquency$delinquency_group
)

# Delinquency percentages
round(
  prop.table(
    table(
      loan_delinquency$delinquency_group
    )
  ) * 100,
  2
)

# Median characteristics by delinquency
delinquency_summary <- loan_delinquency[
  ,
  .(
    median_credit_score =
      median(
        origination_classic_fico,
        na.rm = TRUE
      ),
    
    median_dti =
      median(
        dti,
        na.rm = TRUE
      ),
    
    median_ltv =
      median(
        original_ltv,
        na.rm = TRUE
      ),
    
    median_loan_balance =
      median(
        original_upb,
        na.rm = TRUE
      ),
    
    median_interest_rate =
      median(
        original_interest_rate,
        na.rm = TRUE
      )
  ),
  by = delinquency_group
]

delinquency_summary

# Median credit score
ggplot(
  delinquency_summary,
  aes(
    x = delinquency_group,
    y = median_credit_score
  )
) +
  geom_col() +
  labs(
    title = "Median Credit Score by Loan Status",
    x = "Loan Status",
    y = "Median Classic FICO Credit Score"
  ) +
  theme_minimal()

ggsave(
  "plots/median_credit_score.png",
  width = 7,
  height = 5
)

# Median debt-to-income ratio
ggplot(
  delinquency_summary,
  aes(
    x = delinquency_group,
    y = median_dti
  )
) +
  geom_col() +
  labs(
    title = "Median Debt-to-Income Ratio by Loan Status",
    x = "Loan Status",
    y = "Median Debt-to-Income Ratio"
  ) +
  theme_minimal()

ggsave(
  "plots/median_dti.png",
  width = 7,
  height = 5
)

# Median loan-to-value ratio
ggplot(
  delinquency_summary,
  aes(
    x = delinquency_group,
    y = median_ltv
  )
) +
  geom_col() +
  labs(
    title = "Median Loan-to-Value Ratio by Loan Status",
    x = "Loan Status",
    y = "Median Loan-to-Value Ratio"
  ) +
  theme_minimal()

ggsave(
  "plots/median_ltv.png",
  width = 7,
  height = 5
)

# Median original loan balance
ggplot(
  delinquency_summary,
  aes(
    x = delinquency_group,
    y = median_loan_balance
  )
) +
  geom_col() +
  labs(
    title = "Median Original Loan Balance by Loan Status",
    x = "Loan Status",
    y = "Median Original Loan Balance"
  ) +
  theme_minimal()

ggsave(
  "plots/median_loan_balance.png",
  width = 7,
  height = 5
)

# Median interest rate
ggplot(
  delinquency_summary,
  aes(
    x = delinquency_group,
    y = median_interest_rate
  )
) +
  geom_col() +
  labs(
    title = "Median Mortgage Interest Rate by Loan Status",
    x = "Loan Status",
    y = "Median Original Mortgage Interest Rate"
  ) +
  theme_minimal()

ggsave(
  "plots/median_interest_rate.png",
  width = 7,
  height = 5
)

# Loan purpose counts
table(
  loan_level$loan_purpose
)

# Occupancy counts
table(
  loan_level$occupancy_status
)

# Property type counts
table(
  loan_level$property_type
)

# Channel counts
table(
  loan_level$channel
)

