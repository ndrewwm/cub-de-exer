"""Merging enrollment and student data."""

import pandas as pd
import datetime as dt

def clean_and_merge(students, enrollments, results_path):
    """Apply cleaning procedures, and merge a student and enrollment file.

    :param students: DataFrame - a students dataframe to be cleaned/merged
    :param enrollments: DataFrame - an enrollment dataframe to be cleaned/merged
    :param results_path: str - path pointing to where the results should be written to
    :return: None
    """

    # 1. retain students only if they've earned enough credits
    students = students[students['credits_earned'] > 90]

    # 2. calculate each student's age
    students['date_of_birth'] = pd.to_datetime(students['date_of_birth'])

    students['age'] = (dt.datetime.now() - students['date_of_birth'])
    students['age'] = students['age'].dt.days / 365.25
    students = students.astype({'age': int})

    # 3a. for students with 2 majors, collapse each major into
    # a single field ('academic plan'), at the term-level
    majors = students[['term_id', 'student_id', 'major']].drop_duplicates()
    majors = majors.groupby(['term_id', 'student_id'])['major'].apply(';'.join).reset_index()

    # 3b. drop the original 'major' column, deduplicate, and merge in the new field
    students = students.drop(['major'], axis = 1).drop_duplicates()
    students = students.merge(majors, how = 'left', on = ['term_id', 'student_id'])
    students = students.rename(columns = {'major': 'academic_plans'})

    # 4. split the class_id field into its segments, dropping the placeholder and original column
    enrollments[['course_subject', 'ph', 'course_number', 'course_section']] = enrollments['class_id'].str.split('-', 3, expand = True)

    enroll = enrollments.drop(['ph', 'class_id'], axis = 1)

    # 5. merge the two cleaned dataframes (only keeping records which have matches in both
    # files), then write the results to the specified path
    results = enroll.merge(students, how = 'inner', on = ['term_id', 'student_id'])
    results.to_csv(results_path, index = False)

    return None

students_base = pd.read_csv('students.csv')
enrollments_base = pd.read_csv('enrollments.csv')

clean_and_merge(students_base, enrollments_base, 'results.csv')
