# README

## Overview

### Purpose 

The purpose of this exercise is to demonstrate your approach to ETL-related tasks and general best practices with Python scripting. Reviewers are not looking for one specific solution but rather a conversation starter for how you approach problems. Please complete as many of the tasks as you can; if you are unable to complete a task in a reasonable timeframe, please note how you attempted to solve it.

### Prompt

Please develop a Python script to perform the tasks described below using `pandas`, `numpy`, and `datetime` libraries (or other Python libraries if preferred). These tasks include merging two datasets, performing some data transformations, and producing a single dataset in `.csv` format. All data in this exercise are synthetic.

- The `enrollments.csv` file includes a sample of class enrollments for Biology, Chemistry, and Physics courses at the University of Colorado Boulder. A student may be enrolled in more than one course in a given term (also known as a "semester"). The `enrollment_id` is a unique identifier for a student enrollment in a specific course in a specific term.

- The `students.csv` file contains a set of students and their attributes. The `student_id` is a unique identifier for an individual student. A student may have more than one major. 

- The `sample_results.csv` file has a small sample of data expected in the final dataset. Feel free to refer to this sample as you complete the tasks.

### Submission

When complete, please commit your Python script and your `results.csv` file to a publicly-available Github repository and share the repository link with your recruiter. Please ensure this repository is publicly available for the duration of the hiring process.

## Tasks

1. **Merging data**. Combine the `enrollments.csv` and `students.csv` datasets using `term_id` and `student_id` as keys. Note: there are students in the students dataset who may not appear in the enrollments dataset. There are also enrollment terms in the enrollments dataset that do not appear in the students dataset. For this task, please choose a join process that ensures each resulting row has a value for `term_id` and a `student_id`. 

2. **Filtering data**. Filter the dataset to only include students who have `credits_earned` greater than 90.

3. **Dates**. Create a new column called `age` which calculates the student’s current age based on the `date_of_birth` column. 

4. **String manipulation**. The `class_id` field is a string composed of four elements separated by a hyphen (“-”) delimiter. In order, these four elements represent a `course_subject`, a placeholder, a `course_number`, and a `course_section`. Split this field into four new columns by separating the elements on the hyphen delimiter. Drop the placeholder column.
* For example, a row with a `class_id` of “EBIO-1-1210-11” should have a: 
	* `course_subject` of “EBIO”
	* `course_number` of “1210”
	* `course_section` of “11”

5. **Aggregation**. It is possible for a student to pursue multiple majors. Please create a new column called `academic_plans` that concatenates a student’s majors into a single, semicolon-delimited string. After doing so, drop the initial `major` field.
* For example, a student with majors of “History” and “Philosophy” should have an `academic_plans` value of either “History;Philosophy” or “Philosophy;History.” Order does not matter, but majors should not be duplicated (e.g., "Mathematics;Mathematics").
* For example, a student with a single major of “Astronomy” should have an `academic_plans` value of “Astronomy”. No semicolon should be included.

6. **Export**. Create a function to export the final dataset as `results.csv`.