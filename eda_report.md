# Exploratory Data Analysis

## Overview

Exploratory data analysis was performed to better understand the main borrower, loan, and delinquency characteristics in the 2026 Q1 Fannie Mae dataset.

The working dataset contains 512,517 monthly records representing 266,753 unique mortgage loans.

Because some loans appear in multiple monthly records, a one-row-per-loan version of the dataset was used for most borrower and origination characteristics.

## Summary Statistics

The main numeric variables examined were:

- Classic FICO credit score at origination
- debt-to-income ratio
- original loan-to-value ratio
- original combined loan-to-value ratio
- original unpaid principal balance
- original mortgage interest rate
- original loan term

Some important summary values were:

- Median FICO score: 765
- Median debt-to-income ratio: 38%
- Median loan-to-value ratio: 79%
- Median original loan balance: $315,000
- Median mortgage interest rate: 6.10%
- Most loans had a 360-month (30-year) term

## Credit Score

![Credit Score Distribution](credit_score_distribution.png)

Credit scores are generally concentrated toward the higher end of the range.

The median credit score is 765.

## Debt-to-Income Ratio

![Debt-to-Income Ratio](dti_distribution.png)

Debt-to-income ratios are mostly centered around the upper 30% range.

The median debt-to-income ratio is 38%.

## Loan-to-Value Ratio

![Loan-to-Value Ratio](ltv_distribution.png)

The median original loan-to-value ratio is 79%.

## Original Loan Balance

![Original Loan Balance](loan_balance_distribution.png)

Original loan balances are right-skewed, with some loans much larger than the average.

The median original loan balance is $315,000.

## Mortgage Interest Rate

![Mortgage Interest Rate](interest_rate_distribution.png)

Mortgage interest rates are mostly concentrated around 6%.

The median interest rate is about 6.10%.

## Loan Term

![Loan Term](loan_term_distribution.png)

Most mortgages in the dataset have a 30-year loan term.

## Loan Purpose

![Loan Purpose](loan_purpose.png)

Purchase loans are the most common loan purpose in the dataset.

## Occupancy Status

![Occupancy Status](occupancy_status.png)

Most loans are for principal residences.

## Property Type

![Property Type](property_type.png)

Single-family homes are the most common property type.

## Origination Channel

![Origination Channel](origination_channel.png)

Retail loans are the most common origination channel, followed by correspondent and broker loans.

## Delinquency Status

Loans were divided into two groups:

- Delinquent
- Not Delinquent

A loan was considered delinquent if it had at least one delinquent monthly record during the observed period.

![Loan Delinquency Status](delinquency_status.png)

There were 1,830 delinquent loans and 264,923 non-delinquent loans.

Only about 0.69% of loans were delinquent, showing that delinquency is very rare in the current dataset.

## Delinquency Comparisons

### Credit Score

![Median Credit Score](median_credit_score.png)

The median credit score was 765 for non-delinquent loans and 742 for delinquent loans.

Delinquent loans had lower credit scores on average.

### Debt-to-Income Ratio

![Median Debt-to-Income Ratio](median_dti.png)

The median debt-to-income ratio was 38% for non-delinquent loans and 41% for delinquent loans.

Delinquent loans had somewhat higher debt-to-income ratios.

### Loan-to-Value Ratio

![Median Loan-to-Value Ratio](median_ltv.png)

The median loan-to-value ratio was 79% for non-delinquent loans and 77% for delinquent loans.

There was not a large difference between the two groups.

### Original Loan Balance

![Median Original Loan Balance](median_loan_balance.png)

The median original loan balance was $315,000 for non-delinquent loans and $300,000 for delinquent loans.

### Mortgage Interest Rate

![Median Mortgage Interest Rate](median_interest_rate.png)

The median mortgage interest rates were very similar between the two groups.

## Main Findings

The EDA shows that credit score and debt-to-income ratio have the clearest differences between delinquent and non-delinquent loans.

The most important finding is that delinquency is very rare in the 2026 Q1 dataset.

Because only about 0.69% of loans were delinquent, this may affect the usefulness of some data mining methods.

## Revised Mining Direction

Random Forest and K-means clustering still appear appropriate for the project.

Anomaly detection may be a better choice for the third data mining method because it is designed to identify unusual loan observations or risk profiles. Since delinquent loans are rare in the current dataset, anomaly detection may provide more useful results than Apriori association-rule mining.

An older loan dataset may be used later if a longer history is needed for delinquency prediction.
