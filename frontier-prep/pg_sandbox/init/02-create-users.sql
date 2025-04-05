\c edu

create user student1
with
  password 'st1';

create user student2
with
  password 'st2';

grant connect on database edu to student1,
student2;

grant usage on schema studs to student1,
student2;

grant
select
  on all tables in schema studs to student1,
  student2;
