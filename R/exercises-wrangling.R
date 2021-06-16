# Load the packages
source(here::here("R/package-loading.R"))

# Check column names
colnames(NHANES)

# Look at contents
str(NHANES)
glimpse(NHANES)

# See summary
summary(NHANES)

# Look over the dataset documentation
?NHANES

# Select one column by its name, without quotes
select(NHANES, Age)
# Select two or more columns by name, without quotes
select(NHANES, Age, Weight, BMI)
# To *exclude* a column, use minus (-)
select(NHANES, -HeadCirc)
# All columns starting with letters "BP" (blood pressure)
select(NHANES, starts_with("BP"))
# All columns ending in letters "Day"
select(NHANES, ends_with("Day"))
# All columns containing letters "Age"
select(NHANES, contains("Age"))

# Save the selected columns as a new data frame
# Recall the style guide for naming objects
nhanes_small <- select(NHANES, Age, Gender, Height,
                       Weight, BMI, Diabetes, DiabetesAge,
                       PhysActiveDays, PhysActive, TotChol,
                       BPSysAve, BPDiaAve, SmokeNow, Poverty)

# View the new data frame
nhanes_small

# Rename all columns to snake case
nhanes_small <- rename_with(nhanes_small, snakecase::to_snake_case)

# Have a look at the data frame
nhanes_small

rename(nhanes_small, sex = gender)
nhanes_small <- rename(nhanes_small, sex = gender)
# View data frame
nhanes_small

# Learning to use pipes ---------------------------------------------------
# These two ways are the same, with or without pipes
# Make the pipes using Ctrl-Shift-M
colnames(nhanes_small)
nhanes_small %>%
    colnames()

nhanes_small %>%
    select(phys_active) %>%
    rename(physically_active = phys_active)

#New exercise - try out for oneself
nhanes_small %>%
    select(tot_chol, bp_sys_ave, poverty)

nhanes_small %>%
    rename(diabetes_diagnosis_age = diabetes_age)

#Rewrite this to use pipes
#select(nhanes_small, bmi, contains("age"))
nhanes_small %>%
    select(bmi, contains("age"))
#New rewrite
# physical_activity <- select(nhanes_small, phys_active_days, phys_active)
#rename(physical_activity, days_phys_active = phys_active_days)

nhanes_small %>%
    select(phys_active_days,phys_active) %>%
    rename(days_phys_active = phys_active_days)

