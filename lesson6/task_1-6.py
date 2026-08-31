#Задание 1: Приветствие
name = input("Как тебя зовут? ")
print(f"Привет, {name}! Приятно познакомиться")

#Задание 2: Программа вычисляет площадь прямоугольника по длине и ширине
length = float(input("Введите длину прямоугольника: "))
width = float(input("Введите ширину прямоугольника: "))
area = length * width
print(f"Площадь прямоугольника: {area}")

#Задание 3: Программа переводит температуру из градусов Цельсия в градусы Фаренгейта
celsius = float(input("Введите температуру в градусах Цельсия: "))
fahrenheit = celsius * 9 / 5 + 32
print(f"{celsius}°C это {fahrenheit}°F")

#Задание 4: Программа определяет, является ли введённое целое число чётным или нечётным
number = int(input("Введите целое число: "))
if number % 2 == 0:
    print(f"Число {number} – чётное.")
else:
    print(f"Число {number} – нечётное.")

import random

#Задание 5: Загадывается рандомное число от 1 до 20. У пользователя есть 5 попыток чтобы отгадать его
secret_number = random.randint(1, 20)
attempts = 5
print("Я загадал число от 1 до 20. У тебя 5 попыток!")

while attempts > 0:
    print(f"Попытка {6 - attempts}. Введите число: ", end="")
    guess = int(input())

    if guess == secret_number:
        print("Ты угадал! Отличная работа.")
        break
    elif guess < secret_number:
        print("Слишком мало!")
    else:
        print("Слишком много!")

    attempts -= 1
    if attempts > 0:
        print(f"Осталось попыток: {attempts}")
    else:
        print("Попытки закончились. Загаданное число было", secret_number)

#Дополнительное задание - калькулятор
num1 = float(input("Введите первое число: "))
num2 = float(input("Введите второе число: "))
operator = input("Выберите оператор (+, -, *, /): ")

if operator == '+':
    result = num1 + num2
elif operator == '-':
    result = num1 - num2
elif operator == '*':
    result = num1 * num2
elif operator == '/':
    if num2 != 0:
        result = num1 / num2
    else:
        result = "Нельзя делить на ноль!"
else:
    result = "Неизвестный оператор"

if isinstance(result, str):
    print(result)
else:
    print(f"Результат: {num1} {operator} {num2} = {result}")
