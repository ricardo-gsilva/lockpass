# LockPass

LockPass is a secure password manager built with Flutter, designed to demonstrate architectural maturity, clean state management, and secure authentication flows.

The application allows users to store credentials locally on their device without relying on cloud-based storage. It focuses on security, performance, and well-defined separation of concerns.

---

## Features

- Email & Password Authentication (Firebase)
- PIN-based quick access
- Session Lock using app lifecycle detection
- Encrypted local storage (AES)
- Secure Backup & Restore (ZIP export)
- Soft Delete (Trash mode)
- Feature-based modular architecture
- Unit and Widget testing

---

## Architecture

The project follows a feature-based and layered architecture with explicit separation of responsibilities:

Presentation → Controller (Cubit/BLoC) → UseCase → Repository → DataSource

This structure promotes scalability, maintainability, and strong domain boundaries.

---

## Technologies

- Flutter
- flutter_bloc (State Management)
- GetIt (Dependency Injection)
- Firebase Authentication
- SQLite (sqflite)
- AES Encryption
- Dart Isolates (background processing)

---

## Security Approach

- PIN validation rules
- Session-based authentication
- Re-authentication required after logout
- Encrypted local persistence
- Controlled backup generation and restoration

---

## Platforms

- iOS
- Android

---

## Project Structure

lib
├── core        # Shared logic, services, security and DI
├── data        # Data sources and repository implementations
├── domain      # Entities and repository contracts
├── features    # Feature-based modules (presentation + domain)
└── main.dart

Each feature follows a consistent internal structure:

feature/
├── domain      # UseCases
└── presentation
    ├── controller (Cubit/BLoC)
    ├── state
    └── page