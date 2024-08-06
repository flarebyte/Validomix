# Architecture decision records

An [architecture
decision](https://cloud.google.com/architecture/architecture-decision-records)
is a software design choice that evaluates:

-   a functional requirement (features).
-   a non-functional requirement (technologies, methodologies, libraries).

The purpose is to understand the reasons behind the current architecture, so
they can be carried-on or re-visited in the future.

## Image prompt

> A Celtic-style gravure of Validomix, a Gaul character with a sturdy
> build and medium height. He has shoulder-length, wavy brown hair tied
> back.

## intial thoughts

The string validation library should be designed to enforce validation rules
on strings triggered by various events, producing custom messages.

The library should comprise at least five main components:

-   a rule enforcement system
-   an event manager
-   a set of rule definitions
-   a message generator
-   a rule locator

The rule enforcement system applies a series of validation rules, such as
size and format checks, to input strings.

The event manager handles events like onEnter, onExit, and onCharChange,
triggering validations in response to these events.

Rule definitions include abstract classes or interfaces for different
validation rules, with concrete implementations for specific checks like size
and format.

The message generator produces messages based on the validation results,
ensuring that these messages are generic and defined outside the library.

A rule locator should make it easy to find and use specific validation rules
based on an event name and an rule ID.

Communication flows from the event manager triggering validations, the rule
enforcement system applying rules, and the message generator producing the
appropriate messages based on validation outcomes, which are then used by the
client application. This structure should allow for flexible and reusable
string validation with clear separation of concerns.
