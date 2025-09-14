# book_store_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



Perfect 👌🏽 — here’s your **fully updated README file** with everything included:

* ✅ What’s already done
* ✅ Project structure
* ✅ Team responsibilities + code examples
* ✅ Explanation of `constants.dart` & `validators.dart`
* ✅ Navigation flow diagram

You can copy-paste this directly into your repo as `README.md`.

---

# 📖 Bookstore App – README

A Flutter + Firebase project for an **online bookstore** where users can browse books, add them to cart, manage orders, leave reviews, and admins can manage books.

---

## ✅ Current Progress (Setup Done)

* **Folder structure created** (`lib/`, `assets/`, `utils/`, `widgets/`, etc.)
* **Theme setup** (`app_colors.dart`, `app_styles.dart`) → global colors + text styles ready
* **Shared UI components** (`custom_button.dart`, `custom_textfield.dart`) → can be reused across screens
* **Navigation setup in `main.dart`** → routes already created for Login, Signup, Reset, Home, Profile, Wishlist, Cart, Orders, Admin
* **Placeholder screens** for all routes → the app runs without errors and you can click through screens
* **Helper utils added**:

  * `constants.dart` → stores fixed values (Firebase collection names, padding, app name, keys).
  * `validators.dart` → reusable form validation logic (email, password, name, required fields).

👉 Everyone just needs to **replace placeholders with real UI and logic** in their assigned part.

---

## 📂 Project Structure

```
lib/
 ┣ models/        → Data models (User, Book, Order, Review)
 ┣ services/      → Firebase services (Auth, Book, Order, Wishlist, Review)
 ┣ providers/     → State management (auth, cart, orders, books)
 ┣ screens/       → All app pages (auth, home, cart, wishlist, profile, orders, admin)
 ┣ widgets/       → Reusable components (buttons, textfields, book cards, etc.)
 ┣ utils/         → Theme colors, text styles, validators, constants
 ┣ config/        → Firebase setup (firebase_options.dart)
 ┗ main.dart      → Entry point + routes
```

---

## 📌 Utils Explained

### **`constants.dart`**

* Stores fixed values like Firebase collection names, app name, padding, keys.
* Prevents typos & keeps code consistent.
* Example:

  ```dart
  FirebaseFirestore.instance.collection(AppConstants.booksCollection);
  ```

### **`validators.dart`**

* Stores reusable form validation logic.
* Prevents duplicate code across Login, Signup, Checkout forms.
* Example:

  ```dart
  TextFormField(
    decoration: const InputDecoration(labelText: "Email"),
    validator: AppValidators.validateEmail,
  );
  ```

---

## 👥 Team Responsibilities

### **Ire (me)**

* ✅ Setup work: folder structure, theme, routes, global widgets.
* Maintain **main.dart navigation**.
* Build **Profile screen**, **Wishlist screen**, **Review UI**.
* Example usage:

  ```dart
  Padding(
    padding: const EdgeInsets.all(AppConstants.defaultPadding),
    child: Text("Profile", style: AppStyles.heading1),
  );
  ```

---

### **Fadah**

* Work on **Login, Signup, Reset Password** (UI + Firebase auth logic).
* Implement `auth_service.dart` and `auth_provider.dart`.
* Build **Admin Dashboard** + Manage Books.
* Configure Firebase (`firebase_options.dart`).
* Example usage (Login form with validators):

  ```dart
  TextFormField(
    decoration: const InputDecoration(labelText: "Password"),
    obscureText: true,
    validator: AppValidators.validatePassword,
  );
  ```

---

### **Issac**

* Build **Models** (`user.dart`, `book.dart`, `order.dart`, `review.dart`).
* Build **Providers** (book, maybe auth).
* Work on **Home screen** (catalog, search, book details).
* Implement `book_service.dart` to fetch/add books.
* Example usage (Firestore with constants):

  ```dart
  FirebaseFirestore.instance.collection(AppConstants.booksCollection);
  ```

---

### **Dami**

* Build **Cart** and **Orders (history + details)**.
* Implement `order_service.dart`, `cart_provider.dart`, `order_provider.dart`.
* Manage **assets** (images, fonts).
* Maintain `utils/` helpers (validators, constants).
* Example usage (checkout form validation):

  ```dart
  TextFormField(
    decoration: const InputDecoration(labelText: "Address"),
    validator: (value) => AppValidators.validateRequired(value, fieldName: "Address"),
  );
  ```

---

## 🔀 Navigation Flow

```
[Login] -----> [Home] -----> [Profile] -----> [Wishlist]
   |                                |
   |                                v
   |                            [Cart] -----> [Orders] -----> [Admin Dashboard]
   |
   v
[Signup] <----> [Reset Password]
```

### ✅ Explanation

* Users start at **Login** (or go to **Signup** / **Reset Password**).
* After login → **Home** (catalog).
* From Home → open **Profile** (user details) or **Wishlist** (saved books).
* From Profile → go to **Cart** → place orders.
* From Cart → go to **Orders** (order history + details).
* From Orders → go to **Admin Dashboard** (admins only).

---

## 🚀 How to Run

1. Clone project
2. Run `flutter pub get`
3. Add Firebase config (in `firebase_options.dart`)
4. Run `flutter run`

---

## 🔄 Collaboration Notes

* Everyone must **import and use** `AppColors`, `AppStyles`, `CustomButton`, and `CustomTextField` → ensures design consistency.
* Use `constants.dart` (instead of hardcoding collection names, app name, or padding).
* Use `validators.dart` (instead of writing validation in every form).
* Placeholder screens are ready → just replace them with real UI and logic.
* Sync work:

  * **Ire & Issac** → connect Profile/Wishlist UI with Models & Providers.
  * **Fadah & Dami** → connect Auth with Cart/Orders so orders are tied to users.

---

✅ With this README, the whole team understands:

* What’s already been done.
* Their exact role.
* How to use shared utilities (`constants.dart`, `validators.dart`, colors, widgets).
* How navigation flows between screens.

