CREATE SCHEMA IF NOT EXISTS fitness_dwh;
SET search_path TO fitness_dwh;

CREATE TABLE dim_date (
    date_sk             integer PRIMARY KEY,
    full_date           date NOT NULL UNIQUE,
    day_of_week_number  smallint NOT NULL CHECK (day_of_week_number BETWEEN 1 AND 7),
    day_name            varchar(12) NOT NULL,
    week_number         smallint NOT NULL CHECK (week_number BETWEEN 1 AND 53),
    month_number        smallint NOT NULL CHECK (month_number BETWEEN 1 AND 12),
    month_name          varchar(12) NOT NULL,
    quarter_number      smallint NOT NULL CHECK (quarter_number BETWEEN 1 AND 4),
    year_number         smallint NOT NULL,
    is_weekend          boolean NOT NULL
);

CREATE TABLE dim_time (
    time_sk             integer PRIMARY KEY,
    full_time           time NOT NULL UNIQUE,
    hour_number         smallint NOT NULL CHECK (hour_number BETWEEN 0 AND 23),
    minute_number       smallint NOT NULL CHECK (minute_number BETWEEN 0 AND 59),
    day_part            varchar(12) NOT NULL
);

CREATE TABLE dim_client (
    client_sk           bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    client_source_id    integer NOT NULL UNIQUE,
    first_name          varchar(100) NOT NULL,
    last_name           varchar(100) NOT NULL,
    phone               varchar(20),
    membership_start_date date
);

CREATE TABLE dim_group_class (
    group_class_sk        integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    group_class_source_id integer NOT NULL UNIQUE,
    class_name            varchar(100) NOT NULL,
    description           text,
    capacity              integer NOT NULL CHECK (capacity > 0)
);

CREATE TABLE dim_trainer (
    trainer_sk          integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    trainer_source_id   integer NOT NULL UNIQUE,
    first_name          varchar(100) NOT NULL,
    last_name           varchar(100) NOT NULL,
    specialization      varchar(255),
    phone               varchar(20)
);

CREATE TABLE dim_status (
    status_sk           smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    status_source_name  varchar(20) NOT NULL UNIQUE,
    status_name         varchar(50) NOT NULL,
    is_final            boolean NOT NULL
);

CREATE TABLE fact_registration (
    registration_sk        bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    registration_source_id integer NOT NULL UNIQUE,
    registration_date_sk   integer NOT NULL REFERENCES dim_date(date_sk),
    registration_time_sk   integer NOT NULL REFERENCES dim_time(time_sk),
    class_date_sk          integer NOT NULL REFERENCES dim_date(date_sk),
    class_time_sk          integer NOT NULL REFERENCES dim_time(time_sk),
    client_sk              bigint NOT NULL REFERENCES dim_client(client_sk),
    group_class_sk         integer NOT NULL REFERENCES dim_group_class(group_class_sk),
    trainer_sk             integer NOT NULL REFERENCES dim_trainer(trainer_sk),
    status_sk              smallint NOT NULL REFERENCES dim_status(status_sk),
    registration_ts        timestamp NOT NULL,
    class_ts               timestamp NOT NULL,
    registration_count     smallint NOT NULL DEFAULT 1
        CHECK (registration_count = 1),
    attended_count         smallint NOT NULL DEFAULT 0
        CHECK (attended_count IN (0, 1)),
    cancelled_count        smallint NOT NULL DEFAULT 0
        CHECK (cancelled_count IN (0, 1)),
    days_before_class      integer NOT NULL
        CHECK (days_before_class >= 0),
    CHECK (class_ts >= registration_ts),
    CHECK (attended_count + cancelled_count <= 1)
);

CREATE INDEX ix_fact_registration_date
    ON fact_registration(registration_date_sk);
CREATE INDEX ix_fact_registration_class_date
    ON fact_registration(class_date_sk);
CREATE INDEX ix_fact_registration_client
    ON fact_registration(client_sk);
CREATE INDEX ix_fact_registration_class
    ON fact_registration(group_class_sk);

-- количество регистраций по месяцам
SELECT
    d.year_number,
    d.month_number,
    SUM(f.registration_count) AS registrations,
    COUNT(DISTINCT f.client_sk) AS unique_clients
FROM fact_registration f
JOIN dim_date d ON d.date_sk = f.registration_date_sk
GROUP BY d.year_number, d.month_number
ORDER BY d.year_number, d.month_number;

--  популярные групповые занятия
SELECT
    gc.class_name,
    SUM(f.registration_count) AS registrations,
    SUM(f.attended_count) AS attended,
    ROUND(
        100.0 * SUM(f.attended_count) / NULLIF(SUM(f.registration_count), 0),
        2
    ) AS attendance_rate_pct
FROM fact_registration f
JOIN dim_group_class gc ON gc.group_class_sk = f.group_class_sk
GROUP BY gc.class_name
ORDER BY registrations DESC;

--  нагрузка тренеров
SELECT
    tr.first_name,
    tr.last_name,
    tr.specialization,
    COUNT(DISTINCT f.group_class_sk) AS group_classes,
    SUM(f.registration_count) AS registrations,
    COUNT(DISTINCT f.client_sk) AS unique_clients
FROM fact_registration f
JOIN dim_trainer tr ON tr.trainer_sk = f.trainer_sk
GROUP BY tr.trainer_sk, tr.first_name, tr.last_name, tr.specialization
ORDER BY group_classes DESC, registrations DESC;

