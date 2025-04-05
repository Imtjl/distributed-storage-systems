create database edu;
\c education

create schema studs;

create table studs.groups (
    group_id serial primary key,
    group_name varchar(50) not null,
    department varchar(100)
);

create table studs.exams (
    exam_id serial primary key,
    exam_name varchar(60) not null,
    exam_date date,
    max_score integer default 100
);

insert into studs.groups (group_name, department)
values
    ('nerds', 'cs'),
    ('nerds2', 'cs'),
    ('happiness', 'ftmi'),
    ('depression', 'swe');
    

insert into studs.exams (exam_name, exam_date, max_score)
values
    ('Distributed Storage Systems', '2025-04-07', 100),
    ('Systems of Automatic Design', '2025-04-09', 100);
