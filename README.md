# coenttb-web

`coenttb-web` builds on [coenttb/swift-web](https://www.github.com/coenttb/swift-web) with additional features and integrations for Vapor and other frameworks.

<img src="https://img.shields.io/badge/License-AGPL--3.0%20|%20Commercial-blue.svg" alt="License">
![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

This package is currently in active development and is subject to frequent changes. Features and APIs may change without prior notice until a stable release is available.

## Key Features
- **Built entirely in Swift**: Leverages the power of Swift and Vapor to deliver backend capabilities without JavaScript dependencies.
- **Functional Elegance**: Clean and testable architecture inspired by PointFree's best practices.
- **Hypermodular**: Highly modular design, allowing for reusable components that are easy to test, maintain, and integrate.
- **Third Party Integrations**: Support for third-party services such as Stripe, Mailgun, Hotjar, Google Analytics, and Postgres.

## Project Structure

The project is organized into multiple modules for clarity and modularity:

### Sources
- `CoenttbEnvVars`: Handles environment variables and configurations.
- `CoenttbServerRouter`: Manages server routing logic.
- `CoenttbVapor`: Extending Vapor with commonly used functionality.
- `CoenttbWebAccount` & `CoenttbWebAccountLive`: Account management.
- `CoenttbWebBlog`: Blog functionality.
- `CoenttbWebDatabase`: Database interactions.
- `CoenttbWebDependencies`: Handles Dependencies.
- `CoenttbWebHTML`: Builds on [coenttb-html](https://www.github.com/coenttb/coenttb-html) and adds functionality for building websites.
- `CoenttbWebLegal`: Common website legal documents.
- `CoenttbWebModels`: Common models and data structures.
- `CoenttbWebNewsletter`: Newsletter service.
- `CoenttbWebStripe` & `CoenttbWebStripeLive`: Stripe payment integration.
- `CoenttbWebTranslations`: Builds on [swift-languages](https://www.github.com/coenttb/swift-languages). Internationalization and localization specific to website development.
- `CoenttbWebUtils`: Builds on [coenttb-utils](https://www.github.com/coenttb/coenttb-utils) with functionality specific to web development.
- **Third-Party Integrations**:
  - `GitHub`
  - `GoogleAnalytics`
  - `Hotjar`
  - `Mailgun`
  - `Postgres`

## Installation

You can add `coenttb-web` to an Xcode project by including it as a package dependency:

Repository URL: https://github.com/coenttb/coenttb-web

For a Swift Package Manager project, add the dependency in your Package.swift file:
```
dependencies: [
  .package(url: "https://github.com/coenttb/coenttb-web", branch: "main")
]
```

## Example

Refer to [coenttb/coenttb-com-server](https://www.github.com/coenttb/coenttb-com-server) for an example of how to use coenttb-web.

## Related projects

### The coenttb stack

* [swift-css](https://www.github.com/coenttb/swift-css): A Swift DSL for type-safe CSS.
* [swift-html](https://www.github.com/coenttb/swift-html): A Swift DSL for type-safe HTML & CSS, integrating [swift-css](https://www.github.com/coenttb/swift-css) and [pointfree-html](https://www.github.com/coenttb/pointfree-html).
* [swift-web](https://www.github.com/coenttb/swift-web): Foundational tools for web development in Swift.
* [coenttb-html](https://www.github.com/coenttb/coenttb-html): Builds on [swift-html](https://www.github.com/coenttb/swift-html), and adds functionality for HTML, Markdown, Email, and printing HTML to PDF.
* [coenttb-web](https://www.github.com/coenttb/coenttb-web): Builds on [swift-web](https://www.github.com/coenttb/swift-web), and adds functionality for web development.
* [coenttb-server](https://www.github.com/coenttb/coenttb-server): Build fast, modern, and safe servers that are a joy to write. `coenttb-server` builds on [coenttb-web](https://www.github.com/coenttb/coenttb-web), and adds functionality for server development.
* [coenttb-vapor](https://www.github.com/coenttb/coenttb-server-vapor): `coenttb-server-vapor` builds on [coenttb-server](https://www.github.com/coenttb/coenttb-server), and adds functionality and integrations with Vapor and Fluent.
* [coenttb-com-server](https://www.github.com/coenttb/coenttb-com-server): The backend server for coenttb.com, written entirely in Swift and powered by [coenttb-server-vapor](https://www.github.com/coenttb-server-vapor).

### PointFree foundations
* [coenttb/pointfree-html](https://www.github.com/coenttb/pointfree-html): A Swift DSL for type-safe HTML, forked from [pointfreeco/swift-html](https://www.github.com/pointfreeco/swift-html) and updated to the version on [pointfreeco/pointfreeco](https://github.com/pointfreeco/pointfreeco).
* [coenttb/pointfree-web](https://www.github.com/coenttb/pointfree-html): Foundational tools for web development in Swift, forked from  [pointfreeco/swift-web](https://www.github.com/pointfreeco/swift-web).
* [coenttb/pointfree-server](https://www.github.com/coenttb/pointfree-html): Foundational tools for server development in Swift, forked from  [pointfreeco/swift-web](https://www.github.com/pointfreeco/swift-web).

## Feedback is much appreciated!

If you’re working on your own Swift project, feel free to learn, fork, and contribute.

Got thoughts? Found something you love? Something you hate? Let me know! Your feedback helps make this project better for everyone. Open an issue or start a discussion—I’m all ears.

> [Subscribe to my newsletter](http://coenttb.com/en/newsletter/subscribe)
>
> [Follow me on X](http://x.com/coenttb)
> 
> [Link on Linkedin](https://www.linkedin.com/in/tenthijeboonkkamp)

## License

This project is available under **dual licensing**:

### Open Source License
**GNU Affero General Public License v3.0 (AGPL-3.0)**  
Free for open source projects. See [LICENSE](LICENSE.md) for details.

### Commercial License
For proprietary/commercial use without AGPL restrictions.  
Contact **info@coenttb.com** for licensing options.

### PointFree

Included files that are indicated to be created by PointFree are licensed by PointFree under the **MIT License**.
See [POINTFREE MIT LICENSE](LICENCE) for details.
