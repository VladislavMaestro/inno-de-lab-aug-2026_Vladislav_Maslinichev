raw_user_record = " 10827 ; aLeXanDer_vLaDimiRov ; mInSk ; ACTIVE "

# Разделяем строку по точке с запятой и получаем список из четырех строк
user_data = raw_user_record.split(";")

# Убираем пробелы по краям каждого элемента
user_data = [item.strip() for item in user_data]

# префикс с помощью f-строки
user_id = f"UID-{user_data[0]}"

# заменяем подчеркивание пробелом, затем делаем первые буквы заглавными
user_name = user_data[1].replace("_", " ").title()
city = user_data[2].upper()
status = user_data[3].lower()

result = " | ".join([user_id, user_name, city, status])
print(f"Нормализованная запись: {result}")
