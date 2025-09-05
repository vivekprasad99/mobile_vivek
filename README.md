# mmfsl

Project contains modularisation in form of packages and app.

There are 2 apps.

1. Main
2. Lite

Lite app includes only a small subset of packages to publish a lite version of the app having only
some of the features.

## Getting Started

### Build commands

#### Debug build -

DEV: flutter run -t lib/build_variants/main_dev.dart

SIT: flutter run -t lib/build_variants/main_sit.dart

UAT: flutter run -t lib/build_variants/main_uat.dart

PROD: flutter run -t lib/build_variants/main.dart

#### Release build -

DEV: flutter run --release -t lib/build_variants/main_dev.dart

SIT: flutter run --release -t lib/build_variants/main_sit.dart

UAT: flutter run --release -t lib/build_variants/main_uat.dart

PROD: flutter run --release -t lib/build_variants/main.dart

#### Release Build apk and IPA

Main App

flutter run --release -t lib/build_variants/main_dev.dart

Lite App

Step 1 - Navigate to Lite App directory $ cd lite

Step 2 - flutter run --release -t lib/build_variants/main_dev.dart

## Modularization

We intend to create features in a way so that it can be imported as a package in the end
applications (main app and lite app).

Main App - To use all the packages

Lite App - To use some of the packages

We intend to reduce app size in lite application by exlcuding non-relevant dependencies hence import
only required dependencies (packages) in the Main app and Lite App.

## Clean Architecture

Clean architecture was created by Robert C. Martin and promoted on his blog, Uncle Bob. Like other
software design philosophies, clean architecture attempts to provide a cost-effective methodology
that makes it easier to develop quality code that will perform better, is easier to change and has
fewer dependencies.

Each flutter package may develop one or more features. Each feature will be developed with clean
architecture & having clean seperation between logic, view, and data.

1. Presentation layer
2. Domain layer
3. Data layer

## Bloc for state management

Flutter_bloc is a state management library for Flutter applications, built on top of the BLoC (Business Logic Component) pattern. It offers a structured approach to managing application state by decoupling the UI from the business logic, promoting better code organization and reusability.

Three key advantages of using flutter_bloc are:

1. **Separation of Concerns**: Flutter_bloc encourages a clear separation of concerns by segregating UI components from the underlying business logic. This separation enhances code maintainability and makes it easier to understand and debug the application.

2. **Reactive Programming**: It leverages the power of reactive programming, enabling developers to create responsive and scalable applications. With the use of streams and stream transformers, Flutter_bloc facilitates the propagation of state changes throughout the application in a predictable and efficient manner.

3. **Testability**: By encapsulating business logic within BLoCs, Flutter_bloc makes it simpler to write unit tests for individual components of the application. This promotes a test-driven development (TDD) approach, leading to more robust and reliable code.

In summary, Flutter_bloc provides a structured and efficient way to manage state in Flutter applications, offering advantages such as separation of concerns, reactive programming capabilities, and enhanced testability, ultimately resulting in more maintainable and scalable codebases.

## Tests

Add GenerateMock annotation to main() method of each unit test class.
e.g.
@GenerateMocks(
[PhoneValidateUseCase, ValidateOtpUsecase, UserConsentUseCase, PrefUtils])
main(){}

Run below command to generate mock objects of the dependencies
dart run build_runner build

## melos

Splitting up large code bases into separate independently versioned packages is extremely useful for code sharing. However, making changes across many repositories is messy and difficult to track, and testing across repositories gets complicated really fast.

Install Melos as a global package via pub.dev so it can be used from anywhere on your system:
dart pub global activate melos

e.g.
melos exec flutter clean
