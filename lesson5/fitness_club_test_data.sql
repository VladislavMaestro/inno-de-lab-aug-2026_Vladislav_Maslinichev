SET search_path TO fitness_dwh;

TRUNCATE TABLE
    fact_registration,
    dim_status,
    dim_trainer,
    dim_group_class,
    dim_client,
    dim_time,
    dim_date
RESTART IDENTITY CASCADE;

INSERT INTO dim_date (
    date_sk, full_date, day_of_week_number, day_name, week_number,
    month_number, month_name, quarter_number, year_number, is_weekend
)
VALUES
    (20260105, DATE '2026-01-05', 1, 'Понедельник', 2, 1, 'Январь', 1, 2026, false),
    (20260110, DATE '2026-01-10', 6, 'Суббота',     2, 1, 'Январь', 1, 2026, true),
    (20260202, DATE '2026-02-02', 1, 'Понедельник', 6, 2, 'Февраль', 1, 2026, false),
    (20260208, DATE '2026-02-08', 7, 'Воскресенье', 6, 2, 'Февраль', 1, 2026, true),
    (20260303, DATE '2026-03-03', 2, 'Вторник',    10, 3, 'Март', 1, 2026, false),
    (20260312, DATE '2026-03-12', 4, 'Четверг',    11, 3, 'Март', 1, 2026, false);

INSERT INTO dim_time (time_sk, full_time, hour_number, minute_number, day_part)
VALUES
    (900,  TIME '09:00', 9,  0,  'утро'),
    (1000, TIME '10:00', 10, 0,  'утро'),
    (1800, TIME '18:00', 18, 0,  'вечер');

INSERT INTO dim_client (
    client_source_id, first_name, last_name, phone, membership_start_date
)
VALUES
    (1, 'Анна',    'Иванова',   '+79990000001', DATE '2025-09-01'),
    (2, 'Михаил',  'Петров',    '+79990000002', DATE '2025-10-15'),
    (3, 'Елена',   'Смирнова',  '+79990000003', DATE '2025-11-03');

INSERT INTO dim_trainer (
    trainer_source_id, first_name, last_name, specialization, phone
)
VALUES
    (201, 'Ольга',  'Волкова',  'Йога и растяжка',       '+79991110001'),
    (202, 'Игорь',  'Морозов',  'Функциональный тренинг', '+79991110002'),
    (203, 'Дарья',  'Орлова',   'Пилатес',                '+79991110003');

INSERT INTO dim_group_class (
    group_class_source_id, class_name, description, capacity
)
VALUES
    (101, 'Йога',      'Утренняя йога',                    20),
    (102, 'Кроссфит',  'Функциональная тренировка',        15),
    (103, 'Йога',      'Вечерняя йога',                    20),
    (104, 'Пилатес',   'Тренировка на мышцы корпуса',      18);

INSERT INTO dim_status (status_source_name, status_name, is_final)
VALUES
    ('planned',   'Запланировано', false),
    ('attended',  'Посещено',      true),
    ('cancelled', 'Отменено',       true);

INSERT INTO fact_registration (
    registration_source_id,
    registration_date_sk,
    registration_time_sk,
    class_date_sk,
    class_time_sk,
    client_sk,
    group_class_sk,
    trainer_sk,
    status_sk,
    registration_ts,
    class_ts,
    registration_count,
    attended_count,
    cancelled_count,
    days_before_class
)
SELECT
    v.registration_source_id,
    v.registration_date_sk,
    v.registration_time_sk,
    v.class_date_sk,
    v.class_time_sk,
    c.client_sk,
    gc.group_class_sk,
    tr.trainer_sk,
    st.status_sk,
    v.registration_ts,
    v.class_ts,
    1,
    v.attended_count,
    v.cancelled_count,
    v.days_before_class
FROM (
    VALUES
        (1001, 20260105, 1000, 20260110,  900, 1, 101, 201, 'attended',  TIMESTAMP '2026-01-05 10:00', TIMESTAMP '2026-01-10 09:00', 1, 0,  5),
        (1002, 20260105, 1000, 20260110,  900, 2, 101, 201, 'cancelled', TIMESTAMP '2026-01-05 10:15', TIMESTAMP '2026-01-10 09:00', 0, 1, 5),
        (1003, 20260202, 1000, 20260208, 1800, 1, 102, 202, 'attended',  TIMESTAMP '2026-02-02 10:00', TIMESTAMP '2026-02-08 18:00', 1, 0, 6),
        (1004, 20260202, 1000, 20260208, 1800, 3, 102, 202, 'attended',  TIMESTAMP '2026-02-02 10:20', TIMESTAMP '2026-02-08 18:00', 1, 0, 6),
        (1005, 20260303, 1000, 20260312, 1800, 2, 103, 201, 'attended',  TIMESTAMP '2026-03-03 10:00', TIMESTAMP '2026-03-12 18:00', 1, 0, 9),
        (1006, 20260303, 1000, 20260312, 1800, 3, 104, 203, 'planned',   TIMESTAMP '2026-03-03 10:20', TIMESTAMP '2026-03-12 18:00', 0, 0, 9)
) AS v (
    registration_source_id,
    registration_date_sk,
    registration_time_sk,
    class_date_sk,
    class_time_sk,
    client_source_id,
    group_class_source_id,
    trainer_source_id,
    status_source_name,
    registration_ts,
    class_ts,
    attended_count,
    cancelled_count,
    days_before_class
)
JOIN dim_client c
    ON c.client_source_id = v.client_source_id
JOIN dim_group_class gc
    ON gc.group_class_source_id = v.group_class_source_id
JOIN dim_trainer tr
    ON tr.trainer_source_id = v.trainer_source_id
JOIN dim_status st
    ON st.status_source_name = v.status_source_name;

SELECT COUNT(*) AS registration_rows
FROM fact_registration;
