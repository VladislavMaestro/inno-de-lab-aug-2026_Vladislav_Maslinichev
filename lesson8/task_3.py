from typing import Any


DEFAULT_RETURN_INDEX_BASE = 10.0


def calculate_overdue_fine(film_title: str, days_overdue: Any, fine_rate: float) -> tuple[float, float] | None:
    """
    Рассчитывает штраф за просрочку и индекс возврата фильма

    Если вместо числа передали неподходящие данные или количество дней
    равно нулю, выводит сообщение об ошибке. В конце всегда сообщает,
    что проверка завершена.

    Args:
        film_title (str): Название фильма
        days_overdue (Any): Количество дней просрочки (число, строка или другой тип данных)
        fine_rate (float): Размер штрафа за один день просрочки в долларах

    Returns:
        tuple[float, float] | None: Штраф и индекс возврата, если расчет
            прошел успешно, если ошибка - возвращает None.
    """
    try:
        # Пробуем преобразовать дни в число:
        # "5" преобразуется в 5.0
        # "пять" вызовет ошибку
        # если передать список, то тоже ошибка
        numeric_days = float(days_overdue)

        # Умножаем количество дней на штраф за один день
        total_fine = numeric_days * fine_rate

        # Делим DEFAULT_RETURN_INDEX_BASE на количество дней, если дней 0 - ошибка ZeroDivisionError
        return_index = DEFAULT_RETURN_INDEX_BASE / numeric_days

    # обработка ошибок:
    # неподходящий тип
    # невозможно преобразовать в число
    # деление на ноль
    except TypeError as error:
        print(f"[ОШИБКА ТИПА] Некорректный тип данных для '{film_title}': {error}")

    except ValueError as error:
        print(f"[ОШИБКА ЗНАЧЕНИЯ] Невозможно преобразовать дни в число для '{film_title}': {error}")

    except ZeroDivisionError as error:
        print(f"[ОШИБКА ДЕЛЕНИЯ НА НОЛЬ] Возврат без просрочки для '{film_title}': {error}")

    else:
        print(f"Фильм: '{film_title}' | Итоговый штраф: {total_fine}$ | Индекс: {return_index}")
        return total_fine, return_index

    finally:
        print("--- Проверка транзакции возврата завершена ---")

    # если код обработал ошибку, возвращаем None
    return None


print("=== ПРОВЕРКА ВОЗВРАТОВ ===")
print()
calculate_overdue_fine("Matrix", 5, 1.5)
print()
calculate_overdue_fine("Inception", "пять", 2.0)
print()
calculate_overdue_fine("Avatar", 0, 2.5)
print()
calculate_overdue_fine("Interstellar", [3,], 3.0)
