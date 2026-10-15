import tkinter as tk
from tkinter import ttk, messagebox
import pymysql

DB = dict(host="localhost", port=3306, user="root", password="root", database="chudo_obuv", charset="utf8mb4")
COLUMNS = ("Наименование", "Категория", "Подкатегория", "Производитель", "Цена, руб.", "В наличии, пар")
PRODUCTS_SQL = """
SELECT p.name, c.name, s.name, m.name, p.price, COALESCE(SUM(st.quantity), 0)
FROM products p
JOIN categories c ON c.id = p.category_id
JOIN subcategories s ON s.id = p.subcategory_id
JOIN manufacturers m ON m.id = p.manufacturer_id
LEFT JOIN stock st ON st.product_id = p.id
GROUP BY p.id
ORDER BY p.id
"""
ORDER_COLUMNS = ("Номер заказа", "Дата", "Клиент", "Товар", "Размер", "Количество", "Цена, руб.")
ORDERS_SQL = """
SELECT o.id, o.order_date, CONCAT_WS(' ', u.last_name, u.first_name, u.patronymic), p.name, s.size, i.quantity, i.price
FROM orders o
JOIN users u ON u.id = o.user_id
JOIN order_items i ON i.order_id = o.id
JOIN products p ON p.id = i.product_id
JOIN sizes s ON s.id = i.size_id
ORDER BY o.id, i.id
"""


def query(sql, args=()):
    with pymysql.connect(**DB) as connection, connection.cursor() as cursor:
        cursor.execute(sql, args)
        return cursor.fetchall()


class App(tk.Tk):
    def __init__(self):
        super().__init__()
        self.geometry("1100x600")
        self.logo = tk.PhotoImage(file="logo.png").subsample(8)
        self.iconphoto(True, self.logo)
        self.show_login()

    def clear(self, title):
        self.title(f"Чудо Обувь — {title}")
        for widget in self.winfo_children():
            widget.destroy()

    def show_login(self):
        self.clear("Вход")
        tk.Label(self, image=self.logo).pack(pady=20)
        tk.Label(self, text="Логин").pack()
        login = tk.Entry(self, width=30)
        login.pack()
        tk.Label(self, text="Пароль").pack()
        password = tk.Entry(self, width=30, show="*")
        password.pack()
        tk.Button(self, text="Войти", command=lambda: self.login(login.get(), password.get())).pack(pady=10)
        tk.Button(self, text="Войти как гость", command=lambda: self.show_products("Гость", "Гость")).pack()

    def login(self, login, password):
        try:
            users = query("SELECT CONCAT_WS(' ', u.last_name, u.first_name, u.patronymic), r.name "
                          "FROM users u JOIN roles r ON r.id = u.role_id WHERE u.login = %s AND u.password = %s",
                          (login, password))
        except pymysql.Error as error:
            return messagebox.showerror("Ошибка подключения", f"Не удалось подключиться к базе данных:\n{error}")
        if not users:
            return messagebox.showerror("Ошибка входа", "Неверный логин или пароль")
        self.show_products(*users[0])

    def show_products(self, full_name, role):
        self.clear("Список товаров")
        top = tk.Frame(self)
        top.pack(fill="x", padx=10, pady=5)
        tk.Label(top, image=self.logo).pack(side="left")
        tk.Label(top, text=f"{full_name} ({role})").pack(side="left", padx=10)
        tk.Button(top, text="Выход", command=self.show_login).pack(side="right")
        if role in ("Администратор", "Менеджер"):
            tk.Button(top, text="Заказы", command=lambda: self.show_orders(full_name, role)).pack(side="right", padx=5)
        if role == "Администратор":
            tk.Button(top, text="Добавить товар", command=self.placeholder).pack(side="right", padx=5)
        self.table(COLUMNS, PRODUCTS_SQL)

    def show_orders(self, full_name, role):
        self.clear("Заказы")
        tk.Button(self, text="Назад", command=lambda: self.show_products(full_name, role)).pack(anchor="e", padx=10, pady=5)
        self.table(ORDER_COLUMNS, ORDERS_SQL)

    def table(self, columns, sql):
        table = ttk.Treeview(self, columns=columns, show="headings")
        for column in columns:
            table.heading(column, text=column)
        if "Наименование" in columns:
            table.column("Наименование", width=350)
        for row in query(sql):
            table.insert("", "end", values=row)
        table.pack(fill="both", expand=True, padx=10, pady=10)

    def placeholder(self):
        messagebox.showinfo("В разработке", "Этот раздел будет реализован позже")


App().mainloop()
