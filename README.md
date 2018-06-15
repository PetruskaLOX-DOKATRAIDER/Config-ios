## Config


## Project structure

__Config__ - main target. Contains only additional container configurations, side services initialization (fabric, etc) and AppViewModel usages.

__Core__ - core app framework. Contains 99% of code. Can be used in Playgrounds. Has a bunch of auto generators as a build steps. (Core/Autogeneration)

__TestsHelper__ - code generators and extension for XCTest needs.


## Code generation

`SwiftGen` framework is used to generate all image assets. All of them can be accessed via Images namespace.

#### `Sourcery` framework is used to generate (build step for Core framework):
1. Lenses for structures. Any structure can be marked as AutoLenses (preferred place - /Autogeneration/AutoLensesMarker) and will receive accessor Lens with all possible lenses.
2. Tests for Router. Test tryes to build ViewController relaying on Route rules.
3. Auto Cases for enums.  Any enum can be marked as AutoCases (preferred place - /Autogeneration/AutoCasesMarker) and will receive property 'allCases'
4. Public constructor for structs. Any struct can be marked as AutoInit (preferred place - /Autogeneration/AutoPublicInitMarker) and receive public static func new - that allows to construct related entity. (Default struct init method has internal access level)

#### Additional TestsHelper generators:
1. Mocks for services. Mark any service in Core target as AutoMockable to receive related mock to use in Tests.
2. Empty .new() constructor. Any AutoInit marked structs will receive empty constructor .new() to use in Tests with Lenses.

## About MLSDev

[<img src="https://github.com/MLSDev/development-standards/raw/master/mlsdev-logo.png" alt="MLSDev.com">][mlsdev]

`Config` is maintained by MLSDev, Inc. We specialize in providing all-in-one solution in mobile and web development. Our team follows Lean principles and works according to agile methodologies to deliver the best results reducing the budget for development and its timeline.

Find out more [here][mlsdev] and don't hesitate to [contact us][contact]!

[mlsdev]: http://mlsdev.com
[contact]: http://mlsdev.com/contact_us
