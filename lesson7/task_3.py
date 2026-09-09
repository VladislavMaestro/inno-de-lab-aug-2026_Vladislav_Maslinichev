db_config = {
    "connection": {
        "host": "production-db.internal",
        "port": 5432,
        "user": "postgres"
    }
}

# Получаем вложенный словарь и извлекаем параметры соединения.
connection = db_config["connection"]
host = connection["host"]
port = connection["port"]

# Если в настройках нет ssl_mode, используем значение verify-full.
ssl_settings = db_config.get("ssl_settings", {})
ssl_mode = ssl_settings.get("ssl_mode", "verify-full")

# Изменение пользователя и добавление параметра.
connection["user"] = "admin"
connection["max_connections"] = 100

print(f"SSL Mode: {ssl_mode}")
print("Параметры соединения:")

# Вывод элементов обновленного словаря через items()
for key, value in connection.items():
    print(f"* {key}: {value}")
