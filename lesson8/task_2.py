# time используется для измерения времени
# Any — значение может быть любого типа
# Callable — объект, который можно вызвать, например функция
import time
from typing import Any, Callable


PERFORMANCE_LOG_PREFIX = "[PERF_LOG]"
TIME_DECIMALS = 8


def performance_logger(func: Callable[..., Any]) -> Callable[..., Any]:
    """
    Используется для замера времени выполнения

    Args:
        func (Callable[..., Any]): Функция, время работы которой нужно измерить

    Returns:
        Callable[..., Any]: Функция, которая запускает исходную функцию,
            выводит ее имя и время работы, затем возвращает ее результат
    """

    # func - это функция, которую передали декоратору
    # функция wrapper будет запускаться вместо нее и добавлять измерение времени
    # *args собирает аргументы в кортеж
    # **kwargs собирает аргументы, переданные по имени, в словарь

    def wrapper(*args: Any, **kwargs: Any) -> Any:
        # запоминаем время перед вызовом функции
        start_time = time.perf_counter()

        # вызываем исходную функцию и сохраняем ее ответ
        result = func(*args, **kwargs)

        # вычисление времени работы, тк функция закончила работу, снова смотрим на таймер
        elapsed_time = time.perf_counter() - start_time

        print(f"{PERFORMANCE_LOG_PREFIX} Функция '{func.__name__}' выполнена за {elapsed_time:.{TIME_DECIMALS}f} сек.")

        return result

    return wrapper

# подключаем декоратор к функции сортировки, при каждом ее вызове будет измеряться и выводиться время работы
@performance_logger
def get_sorted_report(sales_data: list[dict[str, str | float]]) -> list[dict[str, str | float]]:
    """
    Сортирует категории по выручке от большей к меньшей

    Args:
        sales_data (list[dict[str, str | float]]): Список словарей,
        где category - название категории, а total_sales - сумма выручки

    Returns:
        list[dict[str, str | float]]: Новый список, отсортированный по убыванию
            total_sales
    """
    # sales_data - список словарей
    # item - один из этих словарей
    # lambda берет total_sales, чтобы сортировка сравнивала именно выручку
    # reverse=True ставит большие суммы перед меньшими
    # sorted() создает новый список, который возвращаем через return
    return sorted(sales_data, key=lambda item: item["total_sales"], reverse=True)


sales_data_1 = [
    {"category": "Action", "total_sales": 4311.85},
    {"category": "Animation", "total_sales": 4656.30},
    {"category": "Children", "total_sales": 3655.55}
]

sales_data_2 = [
    {"category": "Classics", "total_sales": 1200.10},
    {"category": "Comedy", "total_sales": 4000.00},
    {"category": "Documentary", "total_sales": 4000.00}
]

sales_data_3 = [
    {"category": "Drama", "total_sales": 500.00}
]

print("=== ТЕСТИРОВАНИЕ ПРОИЗВОДИТЕЛЬНОСТИ ===")

print("\n--- ТЕСТ 1 ---")
report = get_sorted_report(sales_data_1)
print("Топ категорий по выручке:")

position = 1
for item in report:
    print(f"{position}. {item['category']}: {item['total_sales']}")
    position += 1

print("\n--- ТЕСТ 2 ---")
report = get_sorted_report(sales_data_2)
print("Топ категорий по выручке:")

position = 1
for item in report:
    print(f"{position}. {item['category']}: {item['total_sales']}")
    position += 1

print("\n--- ТЕСТ 3 ---")
report = get_sorted_report(sales_data_3)
print("Топ категорий по выручке:")

position = 1
for item in report:
    print(f"{position}. {item['category']}: {item['total_sales']}")
    position += 1
