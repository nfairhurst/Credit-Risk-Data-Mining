# Mortgage Credit Risk Data Mining

## Project Overview

This project uses the Fannie Mae Single-Family Loan Performance Data to study mortgage credit risk through data mining processes.

The main goal is to identify meaningful patterns in mortgage risk and eventually analyze which borrower and loan characteristics are associated with delinquency.

## Dataset

**Source:** Fannie Mae Single-Family Loan Performance Data

**Current file:** `2026Q1.csv`

The raw dataset contains:

- 512,517 monthly loan-performance records
- 113 variables
- 266,753 unique mortgage loans

The dataset is longitudinal, meaning the same mortgage may appear in multiple rows because loan performance is reported monthly.

The raw dataset is kept separate from the working dataset so that the original data remain unchanged.

## Data Dictionary

Variable names and coded values are based on the official Fannie Mae Single-Family Loan Performance Dataset glossary and file layout.

https://capitalmarkets.fanniemae.com/resources/file/credit-risk/pdf/crt-file-layout-and-glossary.pdf

## Data Audit

The dataset was audited before preprocessing.

The audit included:

- dataset dimensions
- number of unique mortgage loans
- number of unique values in each variable
- missing-value counts
- missing-value percentages
- completely missing variables
- variables containing only one observed value
- exact duplicate records
- duplicate loan-month records
- numeric summary statistics
- potential outliers

The raw dataset contained 113 variables.

Several variables were completely missing or contained only one observed value in the 2026 Q1 dataset. These variables do not provide useful variation for data mining.

No exact duplicate rows were found in the initial audit.

Repeated loan identifiers were not treated as duplicates because the same mortgage is expected to appear in multiple monthly reporting periods.

## Outlier Analysis

Potential numeric outliers were identified using the 1.5 × IQR rule.

The general rule used was:

`Lower Bound = Q1 - 1.5 × IQR`

`Upper Bound = Q3 + 1.5 × IQR`

Values outside these bounds were flagged as potential outliers but not deleted.

## Preprocessing

A separate working copy was created so the original dataset remained unchanged.

The following preprocessing steps were completed:

- assigned variable names using the Fannie Mae data dictionary
- converted selected coded values into readable descriptions
- removed variables that were completely missing
- removed variables containing only one observed non-missing value
- checked for exact duplicate rows
- preserved repeated monthly records for the same mortgage
- identified potential outliers without automatically removing them

After this first preprocessing stage, the dataset was reduced from:

**113 variables → 46 variables**

The remaining variables contain actual variation and may be considered for later data mining analysis. 

## Planned Data Mining Methods

### Random Forest

Random Forest will be used to predict mortgage delinquency using borrower and loan characteristics.

The goal will be to determine both how well delinquency can be predicted and which variables appear most important for prediction.

### K-Means Clustering

K-means clustering will be used to identify natural groups of mortgages with similar financial and borrower characteristics.

This may reveal different mortgage risk profiles within the dataset.

### Association Rules or Anomaly Detection

Apriori association-rule mining is currently being considered to identify combinations of borrower, loan, and property characteristics that frequently occur together.

Numeric variables such as credit score, DTI, and LTV may be converted into categories for association-rule mining.

However, exploratory analysis may indicate that anomaly detection is more appropriate if delinquency-related patterns are too rare for useful association rules.

The final third mining method will be selected based on the results of the exploratory analysis.

## Exploratory Data Analysis

Exploratory data analysis was performed on both the monthly loan records and a one-row-per-loan version of the dataset.

The analysis examined:

- credit score
- debt-to-income ratio
- loan-to-value ratio
- original loan balance
- mortgage interest rate
- loan term
- loan purpose
- occupancy status
- property type
- origination channel
- delinquency status

The EDA also compared median borrower and loan characteristics between delinquent and non-delinquent loans.

[View the full EDA Report](https://github.com/nfairhurst/Credit-Risk-Data-Mining/blob/main/eda_report.md)

## Prepared Dataset and Method Plan

For the three data mining methods chosen, separate datasets will be created for each data mining method because the methods require different types of variables.

### Random Forest Dataset

The Random Forest dataset will use borrower, loan, property, and origination characteristics as predictor variables.

The response variable will be delinquency status:

- Delinquent
- Not Delinquent

Variables that directly describe later loan performance will not be used as predictor variables.

### K-Means Dataset

The K-means dataset will use selected numeric variables such as:

- credit score
- debt-to-income ratio
- loan-to-value ratio
- original loan balance
- mortgage interest rate
- original loan term

These variables will later be standardized before clustering.

Delinquency status will not be used to create the clusters.

### Anomaly Detection Dataset

The anomaly detection dataset will also use selected numeric borrower and loan characteristics.

The goal will be to identify loans with unusual combinations of characteristics.

The identified unusual loans can later be compared with delinquency status and other loan characteristics.

These datasets will be used separately when each data mining method is performed.
