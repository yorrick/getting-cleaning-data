library(dplyr)
library(data.table)

CURRENT_PATH <- getSrcDirectory(function(x) {x})

# File paths to data
DATASETS <- list(
    list(
        data = "UCI HAR Dataset/test/X_test.txt",
        labels = "UCI HAR Dataset/test/y_test.txt"),
    list(
        data = "UCI HAR Dataset/train/X_train.txt",
        labels = "UCI HAR Dataset/train/y_train.txt")
)

FEATURES_FILES = "UCI HAR Dataset/features.txt"

# List of activities names
ACTIVITIES = c(
    "WALKING", 
    "WALKING_UPSTAIRS", 
    "WALKING_DOWNSTAIRS", 
    "SITTING", 
    "STANDING", 
    "LAYING"
)


# loads a data set into memory
load_set <- function(dataset_path, labels_path) {
    ds <- read.table(dataset_path) %>% tbl_df
    labels <- read.table(labels_path)
    
    ds %>% mutate(activity = labels[["V1"]])
}

# Merges the training and the test sets to create one data set
load_all_data <- function() {
    data <- list()
    
    for (i in 1:length(DATASETS)) {
        dataset <- DATASETS[[i]]
        data[[i]] <- load_set(dataset$data, dataset$labels)
    }
    
    rbindlist(data) %>% tbl_df
}

# Load interesting features indexes (e.g. mean and standard deviation)
interesting_feature_indexes <- function() {
    features <- read.table(FEATURES_FILES, stringsAsFactors = FALSE)
    mean_features = grepl("mean", features$V2, ignore.case = TRUE)
    std_features = grepl("std", features$V2, ignore.case = TRUE)
    
    features[mean_features | std_features, ]
}

# Generates the tidy dataset
generate_tidy_dataset <- function(
    output_path = file.path(CURRENT_PATH, "./tidy_dataset.txt")
) {
    all_data = load_all_data()
    features = interesting_feature_indexes()
    
    dataset = all_data %>% 
        # Extracts only the measurements on the mean and standard deviation 
        # for each measurement 
        select(c(features$V1, activity)) %>%
        # Uses descriptive activity names to name the activities in the data set
        mutate(activity = as.factor(ACTIVITIES[activity]))
    
    # Appropriately labels the data set with descriptive variable names.
    names(dataset) <- c(features$V2, "activity")
    
    # From the data set in step 4, creates a second, independent tidy data 
    # set with the average of each variable for each activity and each subject.
    write.table(dataset, output_path, row.name=FALSE)
    
    dataset
}
