# validomix

![Experimental](https://img.shields.io/badge/status-experimental-blue)

> From Strings to Objects Validomix validates all

The Validomix library is designed to enforce validation rules on strings,
triggered by various events, and to produce custom messages. It applies a
series of validation rules, such as size and format checks, to input strings
through a rule enforcement system.

![Hero image for validomix](doc/validomix.jpeg)

Highlights:

-   Validation of strings, numbers, or lists.
-   Produce custom messages for errors and successes.
-   Rules can be serialized as JSON.
-   Invalid configurations are captured in metrics.
-   Inventory of the rules is available.
-   Fully extendable.

A few examples:

Create an inventory used to keep track of rules:

```dart
final optionsInventory = VxOptionsInventory()
```

Create a string rule:

```dart
final rule = VxStringRules.charsLessThan<String>(name: 'test',
metricStoreHolder: metricStoreHolder, optionsInventory: optionsInventory,
failureProducer: SimpleMessageProducer('Too many characters'));
```

## Documentation and links

-   [Code Maintenance :wrench:](MAINTENANCE.md)
-   [Code Of Conduct](CODE_OF_CONDUCT.md)
-   [Contributing :busts\_in\_silhouette: :construction:](CONTRIBUTING.md)
-   [Architectural Decision Records :memo:](DECISIONS.md)
-   [Contributors
    :busts\_in\_silhouette:](https://github.com/flarebyte/validomix/graphs/contributors)
-   [Dependencies](https://github.com/flarebyte/validomix/network/dependencies)
-   [Glossary
    :book:](https://github.com/flarebyte/overview/blob/main/GLOSSARY.md)
-   [Software engineering principles
    :gem:](https://github.com/flarebyte/overview/blob/main/PRINCIPLES.md)
-   [Overview of Flarebyte.com ecosystem
    :factory:](https://github.com/flarebyte/overview)
-   [Dart dependencies](DEPENDENCIES.md)
-   [Usage](USAGE.md)
-   [Example](example/example.dart)

## Related

-   [form\_validator](https://pub.dev/packages/form_validator)
