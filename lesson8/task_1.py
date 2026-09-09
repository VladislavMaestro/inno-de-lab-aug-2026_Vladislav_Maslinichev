# Лимит общий для всех партий, поэтому объявляем его вне функции.
MAX_RENTAL_BATCH_LIMIT = 150.0


def calculate_rental_batch(quantity: int, rental_rate: float, discount: float = 0.0) -> tuple[float, bool]:
    """
    функция рассчитывает стоимость партии со скидкой и проверяет лимит

    Args:
        quantity (int): Количество дисков в партии
        rental_rate (float): Цена аренды одного диска в долларах
        discount (float): Скидка в долях единицы (0.1 равняется 10%)
            Если скидку не передать, используется 0.0

    Returns:
        tuple[float, bool]: Итоговая сумма, округленная до двух знаков + результат проверки лимита, где
         True означает превышение 150.0
    """
    # Считаем стоимость всех дисков, затем учитываем скидку
    final_sum = round(quantity * rental_rate * (1 - discount), 2)

    # Считаем, что если сумма равна 150, то превышения еще нет, поэтому используем >, а не >=
    is_limit_exceeded = final_sum > MAX_RENTAL_BATCH_LIMIT

    # Возвращаем кортеж данных
    return final_sum, is_limit_exceeded


print("=== ОТЧЕТ ПО ПАРТИЯМ АРЕНДЫ ===")

final_sum, is_limit_exceeded = calculate_rental_batch(30, 2.99)
print(f"Партия 1 (Academy Dinosaur): Сумма {final_sum}$. Превышение лимита: {is_limit_exceeded}")

final_sum, is_limit_exceeded = calculate_rental_batch(quantity=40, rental_rate=4.99, discount=0.1)
print(f"Партия 2 (Affair Prejudice): Сумма {final_sum}$. Превышение лимита: {is_limit_exceeded}")

final_sum, is_limit_exceeded = calculate_rental_batch(10, 1.99)
print(f"Партия 3 (Agent Truman): Сумма {final_sum}$. Превышение лимита: {is_limit_exceeded}")

final_sum, is_limit_exceeded = calculate_rental_batch(quantity=50, rental_rate=3.50, discount=0.2)
print(f"Партия 4 (African Egg): Сумма {final_sum}$. Превышение лимита: {is_limit_exceeded}")
