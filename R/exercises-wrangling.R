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

# 9.10 Filtering data by row ----------------------------------------------

# Filter for all female
nhanes_small %>%
    filter(sex == "female")

# Participants who are not female
nhanes_small %>%
    filter(sex != "female")

# Participants who have BMI equal to 25
nhanes_small %>%
    filter(bmi == 25)

# Participants who have BMI equal to or more than 25
nhanes_small %>%
    filter(bmi >= 25)

# Test for | (to make that AltGr + knappen nær delete)
# Test for &
TRUE & TRUE # gives a TRUE response back
TRUE & FALSE # Gives a FLASE response back
FALSE & FALSE # Gives a FLASE response back
TRUE|TRUE # gives a TRUE response back
TRUE|FALSE # gives a TRUE response back
FALSE|FALSE # Gives a FLASE response back

# When BMI is 25 AND sex is female
nhanes_small %>%
    filter(bmi == 25 & sex == "female")

# When BMI is 25 OR sex is female
nhanes_small %>%
    filter(bmi == 25 | sex == "female")


# 9.11 Arranging the rows of your data by column --------------------------
# Arranging data by age in ascending order
nhanes_small %>%
    arrange(age)

# arrange() also arranges parameters of type character alphabetically:
nhanes_small %>%
    arrange(sex)
# Arranging data by age in descending order
nhanes_small %>%
    arrange(desc(age))
# Arranging data by sex then age in ascending order
nhanes_small %>%
    arrange(sex, age)

# 9.12 Transform or add columns -------------------------------------------
# Using the mutate function

# Transform height from cm to m by multiplying with 100
nhanes_small %>%
    mutate(height = height / 100)
# Create a new column with ie. log-trans of height
nhanes_small %>%
    mutate(logged_height = log(height))
#Adding multiple transformations/modifications in one go
nhanes_small %>%
    mutate(height = height / 100,
           logged_height =log(height))
# logic conditions using if_else()
nhanes_small %>%
    mutate(highly_active = if_else(phys_active_days >= 5, "yes", "no"))

#To save it all in a new dataset remember <-
nhanes_update <- nhanes_small %>%
    mutate(height = height / 100,
           logged_height = log(height),
           highly_active = if_else(phys_active_days >= 5, "Yes", "No"))

# 9.13 Exercise: Piping, filtering, and mutating --------------------------
# 1. BMI between 20 and 40 with diabetes
nhanes_small %>%
    # Format should follow: variable >= number or character
    filter(___ >= ___ & ___ <= ___ & ___ == ___)
#Solution
nhanes_small %>%
    filter(bmi >= 20 & bmi <=40 & diabetes=="Yes")


# Pipe the data into mutate function and:
#nhanes_modified <- nhanes_small %>% # Specifying dataset
#    mutate(
        # 2. Calculate mean arterial pressure
#        ___ = ___,
        # 3. Create young_child variable using a condition
#        ___ = if_else(___, "Yes", "No")
#    )

#Solution
nhanes_modified <- nhanes_small %>% # dataset
    mutate(
        mean_arterial_pressure = ((2 * bp_dia_ave) + bp_sys_ave) / 3,
        young_child = if_else(age < 6, "Yes", "No")
    )


# 9.15 Calculating summary statistics -------------------------------------
#Calculating the maximum
nhanes_small %>%
    summarise(max_bmi = max(bmi)) #doesn't work bc of NAs
#Now without NAs
nhanes_small %>%
    summarise(max_bmi = max(bmi, na.rm = TRUE))
#Adding more summary stats
nhanes_small %>%
    summarise(max_bmi = max(bmi, na.rm = TRUE),
              min_bmi = min(bmi, na.rm = TRUE))

# 9.16 Exercise: Calculate some basic statistics --------------------------
# 1. weight and age
nhanes_small %>%
    summarise(mean_weight = mean(weight, na.rm = TRUE),
              mean_age = mean(age, na.rm = TRUE))

# 2. max and min of height
nhanes_small %>%
    summarise(max_height = max(height, na.rm = TRUE),
              min_height = min(height, na.rm = TRUE))

# 3. median of age and phys_active_days
nhanes_small %>%
    summarise(median_age = median(age, na.rm = TRUE),
              median_phys_activve_days = median(phys_active_days, na.rm = TRUE))

# 9.17 Summary statistics by a group --------------------------------------
# Now doing the same thing BUT by group
nhanes_small %>%
    group_by(diabetes) %>%
    summarise(mean_age = mean(age, na.rm = TRUE),
              mean_bmi = mean(bmi, na.rm = TRUE))

nhanes_small %>%
    # Recall ! means "NOT", so !is.na means "is not missing"
    filter(!is.na(diabetes)) %>%
    group_by(diabetes) %>%
    summarise(mean_age = mean(age, na.rm = TRUE),
              mean_bmi = mean(bmi, na.rm = TRUE))

# Grouping by both diabetes AND sex
nhanes_small %>%
    filter(!is.na(diabetes)) %>%
    group_by(diabetes, sex) %>%
    summarise(mean_age = mean(age, na.rm = TRUE),
              mean_bmi = mean(bmi, na.rm = TRUE))
# Since we are grouping by diabetes,
# it’s good practice to end the grouping with ungroup().
nhanes_small %>%
    filter(!is.na(diabetes)) %>%
    group_by(diabetes, sex) %>%
    summarise(mean_age = mean(age, na.rm = TRUE),
              mean_bmi = mean(bmi, na.rm = TRUE)) %>%
    ungroup()
# Saving datasets as files
usethis::use_data(nhanes_small, overwrite = TRUE)

# 9.18 Exercise: Answer some statistical questions with group by a --------

# 1. What is the mean, max, and min differences in age
# between females and males with or without diabetes?

nhanes_small %>%
    filter(!is.na(diabetes)) %>%
    group_by(diabetes, sex) %>%
    summarise(mean_age = mean(age, na.rm = TRUE),
              max_age = max(age, na.rm = TRUE),
              min_age = min(age, na.rm = TRUE)) %>%
    ungroup()


# 2. What is the mean, max, and min differences in height
# and weight between females and males with or without
# diabetes?
nhanes_small %>%
    filter(!is.na(diabetes)) %>%
    group_by(diabetes, sex) %>%
    summarise(mean_height = mean(height, na.rm = TRUE),
              max_height = max(height, na.rm = TRUE),
              min_height = min(height, na.rm = TRUE)) %>%
    ungroup()

# Saving datasets as files
usethis::use_data(nhanes_small, overwrite = TRUE)
