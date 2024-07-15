# MediTask Take Away Homework

FRONTEND: flutter

BACKEND: Django and Django REST framework

DATABASE: SQLite


# 1. HOW TO SET UP (WSL)

BACKEND:

`cd homework/backend`

Create a virtual environment to isolate our package dependencies locally
`python3 -m venv env` original env is present, so can skip this
`source env/bin/activate`  # On Windows use `env\Scripts\activate`

Install Django and Django REST framework into the virtual environment
`pip install djangorestframework`

FRONTEND:

`cd homeowrk/frontend`

add http:, mockito:, build_runner to pubspec.yaml
`flutter pub add http dev:mockito dev:build_runner`


# 2. HOW TO RUN

BACKEND:

`cd homework/backend`

activate virtual enviornment
`./env/Scripts/activate`

`cd meditask`

`python manage.py runserver`

FRONTEND:

`cd homework/fronend`

open with android studio and run with emulator
OR
`flutter run`

# 3. UNIT TESTS
BACKEND
`cd homework/backend`
`./env/Scripts/activate`
`cd meditask`
`python manage.py test`

FRONTEND:
generate the mocks
`dart run build_runner build`

`cd homework/frontend`
`flutter test`