
/*
In Dart, classes are highly versatile. By combining different class types (like abstract, mixin, or sealed)
with different constructors (like factory or const), you can model almost any architectural pattern.
Here is the complete breakdown of every class type and variation in Dart.
*/


//1. Core Class Types (Modifiers)
//===============================
/*
These modifiers define how a class can be instantiated, extended, or implemented.
• Standard Class: The default class. It can be instantiated, extended (extends), or implemented (implements).dart
*/
class Bicycle {
   int speed = 0;
}
/*
Use code with caution.
• Abstract Class: A blueprint class that cannot be instantiated directly. It is used to define an interface or shared
behavior for subclasses to implement.dart
*/
abstract class Vehicle {
void move(); // Abstract method (no body)
}
/*
Use code with caution.
• Mixin Class: A class that can be used as a traditional class and mixed into other classes using the "with" keyword to
share code without rigid inheritance.dart
*/
interface class Animal{
}
mixin class Flier {
void fly() => print('Flying!');
}
class Bird extends Animal with Flier {

  void canBardFly() {
    fly(); //direct use of mixin method
  }
}
/*
Use code with caution.
• Sealed Class: A class that defines a strictly closed set of subtypes. All subclasses must be
defined in the same file. This allows the compiler to check that switch statements cover every possible
subtype (exhaustiveness checking).dart
*/
sealed class Result {}
class Success extends Result { final String data; Success(this.data); }
class Failure extends Result { final Exception error; Failure(this.error); }
//Use code with caution.

//2. Base, Interface, and Final Modifiers
//=======================================

/*
Dart provides controls to restrict how other libraries can interact with your classes.
• Base Class: Enforces that any class wrapping it must use extends (inheritance), not implements.
This guarantees that subclasses inherit its concrete implementations.dart
*/
base class VehicleBase {}
/*
Use code with caution.
• Interface Class: Enforces that other libraries can only implements the class,
not extends it. This hides the internal implementation details and forces others to rebuild the interface.dart
*/
interface class Disconnectable {
}
/*
Use code with caution.
• Final Class: Closes the inheritance chain completely. It cannot be extended or implemented outside of its own file.dart
*/
final class DatabaseConnection {}
//Use code with caution.

//3. Special Purpose "Classes"
//============================

/*
These are distinct, class-like constructs in Dart designed for specialized data modeling.
• Enum (Enumerated Type): A special class used to represent a fixed number of constant values.
In modern Dart, enums can have fields, methods, and constructors (Enhanced Enums).dart
*/
enum Status {
pending, success, failed;
bool get isFinal => this != pending;
}
/*
Use code with caution.
• Extension Type: A compile-time-only wrapper around an existing type. It provides a new interface with zero
runtime overhead (unlike wrapping an object in a standard class).dart
*/
extension type Id(int value) {
bool get isValid => value > 0;
}
//Use code with caution.

//4. Constructor-Based Class Variants
//===================================

/*
Sometimes a class is distinct because of how it builds objects.
• Immutable (Const) Class: A class where all fields are final, allowing it to have
a const constructor. These objects are deeply frozen at compile-time, boosting Flutter rendering performance.dart
*/
class Point {
final double x, y;
const Point(this.x, this.y); // Can be created as: const Point(0, 0)
}
/*
Use code with caution.
• Factory / Singleton Class: A class that uses a factory constructor. Instead of always creating a
new instance, it can return an existing instance from a cache or return a subclass.dart
*/
class Logger {
static final Logger _cache = Logger._internal();
factory Logger() => _cache; // Always returns the same instance
Logger._internal();
}
/*

Quick Comparison Matrix


Modifier / Type	Can Instantiate (new/()) == Can Extend (extends) == Can Implement (implements) == Main Use Case
Standard	  ✅	✅	✅	Everyday general objects
Abstract	  ❌	✅	✅	Defining shared APIs/blueprints
Mixin	      ✅	✅	✅ (via with)	Sharing plug-and-play features
Sealed	    ❌	✅ (Same file only)	✅ (Same file only)	State management (e.g., Bloc states)
Base	      ✅	✅	❌	Safe inheritance without API breaks
Interface	  ✅	❌	✅	Creating strict public APIs
Final	      ✅	❌	❌	Preventing any third-party subclassing
 */