--База данных для регистрации проиcшествий

--Необходимо создать базу данных для регистрации проиcшествий. 
--База данных должна содержать данные для регистрации сообщений о 
--проиcшествиях (регистрационный номер сообщения, дата регистрации,
--краткая фабула (тип проиcшествия); информацию о принятом по проиcшествию 
--решении (отказано в возбуждении дел, удовлетворено ходатайство о 
--возбуждении уголовного дела с указанием регистрационного номера заведенного
--дела, отправлено по территориальному признаку); информацию о лицах, 
--виновных или подозреваемых в совершении проиcшествия (регистрационный
--номер лица, фамилия, имя, отчество, адрес, количество судимостей),
--отношение конкретных лиц к конкретным проиcшествиям (виновник, потерпевший,
--подозреваемый, свидетель)

.open incidents.db
.mode box
--Создаем таблицы
create table type_of_incident(type_id integer primary key not null,
description text not null);
create table incident_reports(incident_id integer primary key not null,
date date not null, type_id integer, foreign key (type_id) references type_of_incident);
create table status(status_id integer primary key not null, status_name text not null);
create table department(department_id integer primary key not null, name text not null);
create table solution(solution_id integer primary key not null, incident_id integer,
status_id integer, case_number varchar(10) null, department_id integer null,
foreign key (incident_id) references incident_reports,
foreign key (status_id) references status,
foreign key (department_id) references department);
create table participants(participant_id integer primary key not null,
participant_name varchar(20) not null);
create table persons(person_id text primary key not null, last_name varchar(45) not null,
first_name varchar(20) not null, patronymic varchar(20) not null, address text,
previous_conviction integer check(previous_conviction>=0));
create table relation( relation_id integer primary key not null, incident_id integer,
person_id text, participant_id integer,
foreign key (incident_id) references incident_reports,
foreign key (person_id) references persons,
foreign key (participant_id) references participants);

--Проверяем результат создания таблиц
.table

--Наполняем таблицы данными
insert into type_of_incident(type_id, description) values(1, 'кража'), (2, 'убийство'), 
(3, 'взятка'), (4, 'разбой'), (5, 'изнасилование');
insert into incident_reports(incident_id, date, type_id) values(1, '2020-03-29', 1),
(2, '2020-04-03', 2), (3, '2021-05-25', 1), (4, '2022-02-15', 4), (5, '2022-03-27', 3);
insert into status(status_id, status_name) values(1, 'отказано в возбуждении дела'),
(2, 'удовлетворено ходатайство о возбуждении уголовного дела'), 
(3, 'отправлено по территориальному признаку');
insert into department(department_id, name) values(1, 'ОВД Витебского райисполкома'),
(2, 'ОВД Администрации Железнодорожного района г.Витебска'),
(3, 'ОВД Администрации Октябрьского района г.Витебска'),
(4, 'ОВД Администрации Первомайского района г.Витебска');
insert into solution(solution_id, incident_id, status_id, case_number, department_id) 
values(1, 1, 1, '', ''), (2, 2, 2, 'У1', ''), (3, 3, 2, 'К2', ''), (4, 4, 2, 'Р1', ''), (5, 5, 3, '', 3);
insert into participants(participant_id, participant_name) values(1, 'виновник'),
(2, 'потерпевший'), (3, 'подозреваемый'), (4, 'свидетель');
insert into persons(person_id, last_name, first_name, patronymic, address, previous_conviction)
values('MB1111', 'Иванов', 'Иван', 'Иванович', 'г.Витебск, ул.Чкалова, д.6, кв.5', 5),
('FR2222', 'Сидоров', 'Сидор', 'Сидорович', 'г.Витебск, Московский пр-т, д.7, кв.18', 1),
('CV3333', 'Петров', 'Петр', 'Петрович', 'г.Витебск, ул.Локомотивная, д.8, кв.3', 0),
('TR4444', 'Мартынова', 'Татьяна', 'Игоревна', 'г.Витебск, пр-т Строителей, д.9, кв.6', 1),
('PO5555', 'Петрова', 'Инна', 'Ивановна', 'г.Витебск, ул.Чкалова, д.16, кв.28', 2),
('DS6666', 'Иванов', 'Семен', 'Семенович', 'г.Витебск, ул.Чкалова, д.7, кв.55', 5),
('LK7777', 'Степанов', 'Иван', 'Семенович', 'г.Витебск, ул.Толстого, д.17, кв.155', 0);
insert into relation(relation_id, incident_id, person_id, participant_id) values
(1, 1, 'CV3333', 3), (2, 2, 'FR2222', 1), (3, 3, 'CV3333', 1), (4, 3, 'TR4444', 1),
(5, 4, 'MB1111', 3), (6, 4, 'PO5555', 3), (7, 4, 'DS6666', 3), (8, 5, 'LK7777', 3);


-- 1. Показать все данные из таблицы persons.
select * from persons;

-- 2. Из таблицы persons извлечь столбцы last_name, first_name. 
-- Выборку ограничить тремя строками.
select last_name, first_name from persons limit 3;

-- 3. Сложить все значения в столбце previous_conviction таблицы persons.
-- Полученному столбцу в результирующей выборке дать название sum.
select sum(previous_conviction) as sum from persons;

-- 4. Вывести данные о происшествиях, по которым отказано в возбуждении дела
-- или отправлено по территориальному признаку.
select * from solution where status_id in(1,3);

-- 5. Посчитать количество происшествий, произошедших в 2022 году, столбец 
-- назвать count_incidents.
select count(incident_id) as count_incidents from incident_reports
where date like '2022%';

-- 6. Вывести данные о происшествиях, которые произошли в первом полугодии 2021 года.
select * from incident_reports where date between '2021-01-01' and '2021.06.30';

-- 7. Получить список лиц (person_id, last_name, first_name), у которых 
-- количество судимостей выше среднего значения.
select person_id, last_name, first_name, previous_conviction from persons 
where previous_conviction > (select avg(previous_conviction) from persons);

-- 8. Сравнить количество судимостей каждого лица со средним значением.
select person_id, previous_conviction, (select avg(previous_conviction) from persons)
as avg_previous_conviction from persons;

-- 9. Получить только те записи лиц из таблицы persons, для которых дело перенаправлено
-- по территориальному признаку.
select p.person_id, p.last_name, p.first_name, p.patronymic
from persons as p
inner join relation on relation.person_id = p.person_id
inner join solution on solution.incident_id = relation.incident_id
where status_id = 3;

-- 10. Получить список лиц, виновных в происшествиях.
select * from persons
where person_id in (select person_id from relation
where participant_id = 1);

-- 11. Указать отношение к происшествию каждого лица, используя таблицы persons  и  relation.
select p.person_id, r.participant_id
from persons as p, relation as r
where p.person_id=r.person_id;

-- 12. Посчитать сколько времени прошло со дня происшествия до настоящего момента.
select (julianday('now') - julianday(date)) from incident_reports;

-- 13. Посчитать какая дата была через 3 дня после поступления сообщения о происшествии.
select date(date, '+3 days') from incident_reports;

-- 14. Посчитать сколько дел было открыто по сообщениям, поступившим в 2021 году.
-- Столбец назвать count.
select count(*) as count from solution as s
inner join incident_reports as i on s.incident_id = i.incident_id
where s.status_id = 2
and i.date like '2021%';

-- 15. Выввести уникальную информацию (описание) о типе происшествия из таблицы incident_reports.
select distinct t.description
from incident_reports as i 
inner join type_of_incident as t on t.type_id = i.type_id;

-- 16. Указать отношение к происшествию каждого лица, отразив из таблицы relation 
-- столбцы person_id, participant_id, из таблицы participants столбец participant_name,
-- при этом должны быть отражены все наименования категорий участников происшествия.
select r.person_id, r.participant_id, p.participant_name
from participants as p left join relation as r 
on r.participant_id = p.participant_id;

-- 17. Посчитать количество происшествий по типам, общее количество.
-- В результирующей выборке в двух столбцах добавить разделительные линии, в первом столбце 
-- под чертой добавить слово total, во втором столбце вывести общую сумму.
select type_id, count(*) from incident_reports group by type_id
union all select '_____','_____'
union all select 'total', count(*) from incident_reports;

-- 18. Из таблицы persons вывести идентификатор лица, фамилию, имя, отчество.
-- Отсортировать по фамилии в порядке возрастания. 
select person_id, last_name, first_name, patronymic
from persons order by 2;

-- 19. Для Петрова Петра Петровича (CV3333) получить количество происшествий,
-- в которых он зарегистрирован, столбец назвать count_incident.
select p.person_id, p.last_name, p.first_name, count (r.incident_id) as count_incident
from persons as p inner join relation as r
on p.person_id = r.person_id
where p.person_id = 'CV3333';

-- 20. Выбрать всех лиц, подозреваемых в совершении происшествия.
-- Отсортировать по фамилии.
select p.person_id, p.last_name, p.first_name
from persons as p inner join relation as r
on p.person_id = r.person_id
where r.participant_id = 3;



























