# Herody Assignment - Flutter To-Do App

## What This App Does
This app is a Firebase-powered To-Do application built with Flutter.

Users can:
- Sign up and log in using Firebase Authentication (email/password)
- Stay logged in across app restarts
- Create tasks
- Edit tasks
- Mark tasks as completed/incomplete
- Delete tasks
- View all personal tasks in a clean responsive UI

## Tech Stack
- Flutter
- Firebase Authentication
- Firebase Realtime Database (REST API via `dio`)
- Cloud Firestore (user profile details)
- MVVM-style separation with `core/services` and feature viewmodels

## Project Structure (High Level)
```text
lib/
  core/
    services/
    security/
    utils/
    constants/
  features/
    auth/
      signup/
      login/
    home/
```

## Screenshot Gallery (3x2)
> Put your 6 app screenshots inside a `screenshots/` folder using the same names below.

<table>
  <tr>
    <td align="center"><b>Signup</b></td>
    <td align="center"><b>Login</b></td>
    <td align="center"><b>Home</b></td>
  </tr>
  <tr>
    <td><img src="screenshots/01_signup.png" alt="Signup Screen" width="240"/></td>
    <td><img src="screenshots/02_login.png" alt="Login Screen" width="240"/></td>
    <td><img src="screenshots/03_home.png" alt="Home Screen" width="240"/></td>
  </tr>
  <tr>
    <td align="center"><b>Add Task</b></td>
    <td align="center"><b>Edit Task</b></td>
    <td align="center"><b>Task Completed</b></td>
  </tr>
  <tr>
    <td><img src="screenshots/04_add_task.png" alt="Add Task Dialog" width="240"/></td>
    <td><img src="screenshots/05_edit_task.png" alt="Edit Task Dialog" width="240"/></td>
    <td><img src="screenshots/06_task_completed.png" alt="Completed Task State" width="240"/></td>
  </tr>
</table>

## Run Locally
```bash
flutter pub get
flutter run
```
