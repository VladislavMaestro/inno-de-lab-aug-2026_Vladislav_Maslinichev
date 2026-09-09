requested_roles = ["guest", "developer", "guest", "admin", "developer", "guest"]
required_admin_roles = {"admin", "security_officer", "audit_manager"}

# преобразуем список во множество для хранения уникальных значений
unique_roles = set(requested_roles)

# находим роли, которые есть и у пользователя, и среди обязательных
# '&' оставляет только общие элементы двух множеств
common_roles = unique_roles & required_admin_roles

# находим роли, которых не хватает пользователю - из множества обязательных ролей вычитаем запрошенные
# admin уже есть, поэтому останутся security_officer и audit_manager
missing_roles = required_admin_roles - unique_roles

# проверяем наличие роли security_officer в дедуплицированном множестве запрошенных ролей
# True, если роль есть во множестве
# False, если нет
has_security_officer = "security_officer" in unique_roles

print(f"Уникальные запрошенные роли: {unique_roles}")
print(f"Общие административные роли: {common_roles}")
print(f"Недостающие административные роли: {missing_roles}")
print(f"Наличие роли security_officer в запросе: {has_security_officer}")
