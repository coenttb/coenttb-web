# coenttb-web

`coenttb-web` builds on [coenttb/swift-web](https://www.github.com/coenttb/swift-web) with additional features and integrations for Vapor and other frameworks.

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

* [coenttb/pointfree-html](https://www.github.com/coenttb/coenttb/pointfree-html): A Swift DSL for type-safe HTML forked from [pointfreeco/swift-html](https://www.github.com/pointfreeco/swift-html) and updated to the version on [pointfreeco/pointfreeco](https://github.com/pointfreeco/pointfreeco).
* [swift-css](https://www.github.com/coenttb/swift-css): A Swift DSL for type-safe CSS.
* [swift-html](https://www.github.com/coenttb/swift-html): A Swift DSL for type-safe HTML & CSS, integrating [swift-css](https://www.github.com/coenttb/swift-css) and [pointfree-html](https://www.github.com/coenttb/pointfree-html).
* [coenttb-html](https://www.github.com/coenttb/coenttb-html): Extends [swift-html](https://www.github.com/coenttb/swift-html) with additional functionality and integrations for HTML, Markdown, Email, and printing HTML to PDF.
* [swift-web](https://www.github.com/coenttb/swift-web): Modular tools to simplify web development in Swift forked from  [pointfreeco/swift-web](https://www.github.com/pointfreeco/swift-web), and updated for use in [coenttb-web](https://www.github.com/coenttb/coenttb-web).
* [coenttb-web](https://www.github.com/coenttb/coenttb-web): A collection of features for your Swift server, with integrations for Vapor.
* [coenttb-com-server](https://www.github.com/coenttb/coenttb-com-server): The backend server for coenttb.com, written entirely in Swift and powered by [Vapor](https://www.github.com/vapor/vapor) and [coenttb-web](https://www.github.com/coenttb/coenttb-web).
* [swift-languages](https://www.github.com/coenttb/swift-languages): A cross-platform translation library written in Swift.

## Feedback is much appreciated!

If you’re working on your own Swift project, feel free to learn, fork, and contribute.

Got thoughts? Found something you love? Something you hate? Let me know! Your feedback helps make this project better for everyone. Open an issue or start a discussion—I’m all ears.

> [Subscribe to my newsletter](http://coenttb.com/en/newsletter/subscribe)
>
> [Follow me on X](http://x.com/coenttb)
> 
> [Link on Linkedin](https://www.linkedin.com/in/tenthijeboonkkamp)

## License

This project is licensed under the **GNU Affero General Public License v3.0 (AGPL-3.0)**.  
You are free to use, modify, and distribute this project under the terms of the AGPL-3.0.  
For full details, please refer to the [LICENSE](LICENSE) file.

### Commercial Licensing

A **Commercial License** is available for organizations or individuals who wish to use this project without adhering to the terms of the AGPL-3.0 (e.g., to use it in proprietary software or SaaS products).  

For inquiries about commercial licensing, please contact **info@coenttb.com**.

### PointFree

Included files that are indicated to be created by PointFree are licensed by PointFree under the **MIT License**.
See [POINTFREE MIT LICENSE](LICENCE) for details.
