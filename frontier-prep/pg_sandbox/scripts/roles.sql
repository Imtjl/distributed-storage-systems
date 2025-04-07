create role student3 with login createrole nosuperuser password '1234';

create role groups_editors;
grant update on studs.Groups to groups_editors;

create role exams_editors;
grant update on studs.Exams to exams_editors;

grant groups_editors to student1, student2, student3;
grant exams_editors to student1, student2;
