
/*
In Dart, constructors are highly flexible. You can use 7 distinct types of constructors to initialize your classes, optimize memory, or implement design patterns like singletons and factories.
Here is the complete breakdown of every constructor type in Dart.

1. Generative Constructor

The most common constructor. It creates a new instance of the class and initializes its member variables. Dart supports Generative Initialization Lists, allowing you to set variables before the constructor body runs.
dart
class Point {
  double x;
  double y;

  // Generative constructor with initializing formal parameters (this.x)
  Point(this.x, this.y);

  // Generative constructor with an Initializer List
  Point.fromJson(Map<String, double> json)
      : x = json['x'] ?? 0.0,
        y = json['y'] ?? 0.0 {
    print('Point initialized at ($x, $y)');
  }
}
Use code with caution.

2. Named Constructor

Dart does not support constructor overloading (having multiple constructors with the same name but different arguments). Instead, it uses Named Constructors to provide multiple ways to clarify an object's initialization path.
dart
class User {
  String name;
  String role;

  User(this.name, this.role);

  // Named Constructor
  User.admin(this.name) : role = 'Admin';
  User.guest() : name = 'Anonymous', role = 'Guest';
}
Use code with caution.

3. Default Constructor

If you do not declare any constructor in your class, Dart automatically creates an invisible, no-argument, generative constructor for you.
dart
class Item {
  String? name;
  // Automatically has an implicit: Item();
}
Use code with caution.

4. Constant (const) Constructor

If a class is completely immutable (meaning all its fields are marked final), you can add a const constructor. This tells Dart to create the object at compile-time. If you instantiate this object multiple times using const, Dart reuses the exact same canonical instance in memory, which drastically speeds up Flutter UI rendering.
dart
class ProfileCard {
  final String title;
  final double padding;

  // Const Constructor
  const ProfileCard({required this.title, this.padding = 16.0});
}

// Usage: Both variables point to the exact same memory address
var card1 = const ProfileCard(title: 'Home');
var card2 = const ProfileCard(title: 'Home');
Use code with caution.

5. Factory Constructor

A factory constructor is used when you want flexibility in what the constructor returns. Unlike a generative constructor, a factory constructor does not automatically create a new instance of its own class.
Instead, it can:
• Return an existing instance from a cache (like a Singleton).
• Return a subclass instance instead of the parent class.
dart
class Logger {
  final String name;
  static final Map<String, Logger> _cache = {};

  // Factory constructor caching instances
  factory Logger(String name) {
    return _cache.putIfAbsent(name, () => Logger._internal(name));
  }

  // Private named generative constructor
  Logger._internal(this.name);
}
Use code with caution.

6. Redirecting Constructor

A constructor whose sole purpose is to forward the initialization request to another constructor within the same class, using the this keyword. It cannot have a body.
dart
class Car {
  String brand;
  int doors;

  Car(this.brand, this.doors);

  // Redirects to the main generative constructor
  Car.sports(String brand) : this(brand, 2);
  Car.suv(String brand) : this(brand, 5);
}
Use code with caution.

7. Super / Redirecting to Non-Virtual Super Constructor

Used to pass arguments up to the parent class's constructor using the super keyword. Modern Dart allows Super Initializing Parameters (super.field) to eliminate repetitive boilerplate code.
dart
class Person {
  String name;
  Person(this.name);
}

class Employee extends Person {
  int employeeId;

  // Modern syntax: 'super.name' directly forwards the value to Person
  Employee(super.name, this.employeeId);

  // Traditional syntax (Alternative):
  // Employee(String name, this.employeeId) : super(name);
}
Use code with caution.

Summary Cheatsheet


Constructor Type	Keyword / Syntax	Primary superpower
Generative	ClassName(...)	Standard object creation.
Named	ClassName.identifier(...)	Solves missing constructor overloading.
Default	Invisible	Automatically provided if zero constructors exist.
Constant	const ClassName(...)	Freezes object at compile-time for extreme performance.
Factory	factory ClassName(...)	Can hand back cached singletons or child subclasses.
Redirecting	: this(...)	Shortcuts one constructor straight into another.
Super	: super(...) or super.x	Passes data up the chain to the parent class.

Are you running into a specific issue, like trying to figure out why a factory constructor can't access this, or how to parse nested JSON inside an initializer list? Let me know what code you're writing!

 */