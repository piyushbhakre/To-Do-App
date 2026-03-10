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
    <td><img src="<img width="1080" height="2340" alt="flutter_01" src="https://github.com/user-attachments/assets/db4a2808-6727-4000-9e92-c804c70583b9" />
" alt="Signup Screen" width="240"/></td>
    <td><img src="<img width="1080" height="2340" alt="flutter_02" src="https://github.com/user-attachments/assets/2ea6d232-7acc-4a23-8466-db6f8531244d" />
" alt="Login Screen" width="240"/></td>
    <td><img src="<img width="1080" height="2340" alt="flutter_03" src="https://github.com/user-attachments/assets/a17cb342-100a-46d2-84d1-c90241329eaa" />
" alt="Home Screen" width="240"/></td>
  </tr>
  <tr>
    <td align="center"><b>Add Task</b></td>
    <td align="center"><b>Edit Task</b></td>
    <td align="center"><b>Task Completed</b></td>
  </tr>
  <tr>
    <td><img src=<img width="1080" height="2340" alt="flutter_01" src="https://github.com/user-attachments/assets/093588ec-9499-4cfd-83d5-fa3a80603555" />
"" alt="Add Task Dialog" width="240"/></td>
    <td><img src="<img width="1080" height="2340" alt="flutter_02" src="https://github.com/user-attachments/assets/03bc4d40-9ff1-4d8c-9d3c-7fb804f70794" />
" alt="Edit Task Dialog" width="240"/></td>
    <td><img src="<img width="1080" height="2340" alt="flutter_03" src="https://github.com/user-attachments/assets/04b0f6b8-d327-4630-934e-5c0136a2fdb9" />
" alt="Completed Task State" width="240"/></td>
  </tr>
</table>

## Run Locally
```bash
flutter pub get
flutter run
```
