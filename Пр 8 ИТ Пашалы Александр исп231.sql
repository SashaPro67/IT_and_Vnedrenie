
-- Страница 1
-- Список всех студентов с названиями групп

SELECT 
    s.student_id,
    s.last_name || ' ' || s.first_name || ' ' || COALESCE(s.middle_name, '') AS ФИО,
    g.group_name AS группа,
    g.specialty AS специальность
FROM students s
JOIN groups g ON s.group_id = g.group_id
ORDER BY g.group_name, s.last_name;


SELECT 
    g.group_name AS группа,
    COUNT(s.student_id) AS количество_студентов
FROM groups g
LEFT JOIN students s ON g.group_id = s.group_id
GROUP BY g.group_id, g.group_name
ORDER BY количество_студентов DESC;

-- Расписание занятий

SELECT 
    l.lesson_date AS дата,
    g.group_name AS группа,
    d.discipline_name AS дисциплина,
    t.last_name || ' ' || t.first_name AS преподаватель,
    l.lesson_type AS вид_занятия
FROM lessons l
JOIN groups g ON l.group_id = g.group_id
JOIN disciplines d ON l.discipline_id = d.discipline_id
JOIN teachers t ON l.teacher_id = t.teacher_id
ORDER BY l.lesson_date, g.group_name;


SELECT 
    t.last_name || ' ' || t.first_name AS преподаватель,
    t.department AS кафедра,
    COUNT(l.lesson_id) AS количество_занятий
FROM teachers t
LEFT JOIN lessons l ON t.teacher_id = l.teacher_id
GROUP BY t.teacher_id, t.last_name, t.first_name, t.department
ORDER BY количество_занятий DESC;


-- Студенты после 2007 года

SELECT 
    last_name || ' ' || first_name AS ФИО,
    birth_date AS дата_рождения
FROM students
WHERE birth_date > '2007-01-01'
ORDER BY birth_date;


SELECT 
    discipline_name AS дисциплина,
    hours AS часы
FROM disciplines
WHERE hours > 72
ORDER BY hours DESC;


-- Группы с более чем одним студентом

SELECT 
    g.group_name AS группа,
    COUNT(s.student_id) AS студентов
FROM groups g
JOIN students s ON g.group_id = s.group_id
GROUP BY g.group_id, g.group_name
HAVING COUNT(s.student_id) > 1
ORDER BY студентов DESC;


SELECT 
    ROUND(AVG(занятий), 2) AS среднее_количество_занятий
FROM (
    SELECT 
        teacher_id,
        COUNT(lesson_id) AS занятий
    FROM lessons
    GROUP BY teacher_id
) AS subquery;


-- Список специальностей

SELECT DISTINCT
    specialty AS специальность
FROM groups
ORDER BY specialty;


SELECT 
    last_name || ' ' || first_name AS ФИО,
    (SELECT group_name FROM groups WHERE group_id = s.group_id) AS группа
FROM students s
ORDER BY last_name;


-- Средний балл студентов

SELECT 
    s.last_name || ' ' || s.first_name AS студент,
    ROUND(AVG(g.grade), 2) AS средний_балл
FROM grades g
JOIN students s ON g.student_id = s.student_id
GROUP BY s.student_id, s.last_name, s.first_name
ORDER BY средний_балл DESC;


SELECT 
    d.discipline_name AS дисциплина,
    ROUND(AVG(g.grade), 2) AS средний_балл,
    COUNT(g.grade_id) AS количество_оценок
FROM grades g
JOIN disciplines d ON g.discipline_id = d.discipline_id
GROUP BY