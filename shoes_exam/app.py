import tkinter as tk
from tkinter import ttk, messagebox
import pymysql

DB = dict(host="localhost", port=3306, user="root", password="root", database="shoes", charset="utf8mb4")
FONT = ("Times New Roman", 12)
COLUMNS = ("Артикул", "Наименование", "Категория", "Описание", "Производитель", "Поставщик",
           "Цена", "Цена со скидкой", "Ед.", "На складе", "Скидка, %")
PRODUCTS_SQL = """
SELECT p.article, p.name, c.name, p.description, m.name, s.name,
       p.price, ROUND(p.price * (100 - p.discount) / 100, 2), u.name, p.quantity, p.discount
FROM products p
JOIN categories c ON c.id = p.category_id
JOIN manufacturers m ON m.id = p.manufacturer_id
JOIN suppliers s ON s.id = p.supplier_id
JOIN units u ON u.id = p.unit_id
ORDER BY p.id
"""


def query(sql, args=()):
    with pymysql.connect(**DB) as connection:
        with connection.cursor() as cursor:
            cursor.execute(sql, args)
            return cursor.fetchall()


class App(tk.Tk):
    def __init__(self):
        super().__init__()
        self.geometry("1300x650")
        self.configure(bg="#FFFFFF")
        self.logo = tk.PhotoImage(file="Icon.png").subsample(5)
        self.iconphoto(True, self.logo)
        ttk.Style().configure("Treeview", font=FONT, rowheight=26)
        ttk.Style().configure("Treeview.Heading", font=FONT)
        self.show_login()

    def clear(self, title):
        self.title(f"ООО «Обувь» — {title}")
        for widget in self.winfo_children():
            widget.destroy()

    def label(self, parent, text, size=12):
        return tk.Label(parent, text=text, font=("Times New Roman", size), bg=parent["bg"])

    def button(self, parent, text, command):
        return tk.Button(parent, text=text, command=command, font=FONT, bg="#00FA9A")

    def show_login(self):
        self.clear("Вход")
        tk.Label(self, image=self.logo, bg="#FFFFFF").pack(pady=20)
        self.label(self, "Логин").pack()
        login = tk.Entry(self, font=FONT, width=30)
        login.pack()
        self.label(self, "Пароль").pack()
        password = tk.Entry(self, font=FONT, width=30, show="*")
        password.pack()
        self.button(self, "Войти", lambda: self.login(login.get(), password.get())).pack(pady=10)
        self.button(self, "Войти как гость", lambda: self.show_products("Гость", "Гость")).pack()

    def login(self, login, password):
        try:
            users = query("SELECT u.full_name, r.name FROM users u JOIN roles r ON r.id = u.role_id "
                          "WHERE u.login = %s AND u.password = %s", (login, password))
        except pymysql.Error as error:
            return messagebox.showerror("Ошибка подключения", f"Не удалось подключиться к базе данных:\n{error}")
        if not users:
            return messagebox.showerror("Ошибка входа", "Неверный логин или пароль.\nПроверьте данные и повторите попытку.")
        self.show_products(*users[0])

    def show_products(self, full_name, role):
        self.clear("Список товаров")
        header = tk.Frame(self, bg="#7FFF00")
        header.pack(fill="x")
        tk.Label(header, image=self.logo, bg="#7FFF00").pack(side="left")
        self.label(header, "Список товаров", 18).pack(side="left", padx=10)
        self.button(header, "Выход", self.show_login).pack(side="right", padx=10)
        self.label(header, full_name).pack(side="right")
        if role in ("Администратор", "Менеджер"):
            self.button(header, "Заказы", self.placeholder).pack(side="right", padx=10)
        if role == "Администратор":
            self.button(header, "Добавить товар", self.placeholder).pack(side="right")
        table = ttk.Treeview(self, columns=COLUMNS, show="headings")
        for column in COLUMNS:
            table.heading(column, text=column)
            table.column(column, width=100)
        table.column("Описание", width=300)
        table.tag_configure("big_discount", background="#2E8B57")
        table.tag_configure("out_of_stock", background="#ADD8E6")
        for row in query(PRODUCTS_SQL):
            tag = "out_of_stock" if row[9] == 0 else "big_discount" if row[10] > 15 else ""
            table.insert("", "end", values=row, tags=(tag,))
        table.pack(fill="both", expand=True)

    def placeholder(self):
        messagebox.showinfo("В разработке", "Этот раздел будет реализован в следующих модулях.")


App().mainloop()
