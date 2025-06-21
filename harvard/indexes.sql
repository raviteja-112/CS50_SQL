CREATE INDEX "idx_enrollments_student_course_id" ON "enrollments"('student_id','course_id');
CREATE INDEX "idx_courses_department_title_number_semester" ON "courses"('department', 'number', 'semester');
CREATE INDEX "idx_satisfies_requirement_course" ON "satisfies"('requirement_id', 'course_id');
CREATE INDEX "idx_requirements_id_name" ON "requirements"('id')
