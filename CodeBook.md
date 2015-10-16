# Steps

This documentation contains the steps to reproduce to generate the tidy dataset.

## Download & unzip raw data

Data is store [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

To download and extract it, please run (on *nix)

```
wget https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
unzip getdata%2Fprojectfiles%2FUCI HAR Dataset.zip
rm getdata%2Fprojectfiles%2FUCI HAR Dataset.zip
```

## Generate the dataset

Source the script named ```run_analysis.R```, then run

```
generate_tidy_dataset()
```

By default, a file named ```tidy_dataset.txt``` of about 10Mb will be generated
in the current directory.

## Details

The script works like this:

1. Data from testing and training dataset is loaded as a data frame. 
For each set we load labels and data text files.
2. Mean and standard deviation features are then select in the data.
3. Descriptive names are then assigned to activities, and to columns.
4. Dataset is then written in a text file.


