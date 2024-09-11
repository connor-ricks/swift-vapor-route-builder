# Contributing to `swift-vapor-route-builder`

First off, thanks for taking the time to contribute! ❤️

All types of contributions are encouraged and valued. See the [Table of Contents](#table-of-contents) for different ways to help and details about how this project handles them. Please make sure to read the relevant section before making your contribution. It will make it a lot easier for us maintainers and smooth out the experience for all involved. The community looks forward to your contributions. 🎉

> And if you like the project, but just don't have time to contribute, that's fine. There are other easy ways to support the project and show your appreciation, which we would also be very happy about:
> - Star the project
> - Tweet about it
> - Refer this project in your project's README
> - Mention the project at local meetups and tell your friends/colleagues

## Table of Contents

- [I Have a Question](#i-have-a-question)
- [I Want To Contribute](#i-want-to-contribute)
- [Reporting Bugs](#reporting-bugs)
- [Suggesting Enhancements](#suggesting-enhancements)
- [Your First Code Contribution](#your-first-code-contribution)
- [Improving The Documentation](#improving-the-documentation)
- [Styleguides](#styleguides)
- [Commit Messages](#commit-messages)
- [Join The Project Team](#join-the-project-team)

## I Have a Question

> If you want to ask a question, we assume that you have read the available documentation.

Before you ask a question, it is best to search for existing [Issues](https://github.com/connor-ricks/swift-vapor-route-builder/issues) that might help you. In case you have found a suitable issue and still need clarification, you can write your question in this issue.

If you then still feel the need to ask a question and need clarification, we recommend the following:

- Open an [Issue](https://github.com/connor-ricks/swift-vapor-route-builder/issues/new).
- Provide as much context as you can about what you're running into.
- Provide project and platform versions (nodejs, npm, etc), depending on what seems relevant.

We will then take care of the issue as soon as possible.

## I Want To Contribute

> ### Legal Notice
> When contributing to this project, you must agree that you have authored 100% of the content, that you have the necessary rights to the content and that the content you contribute may be provided under the project licence.

### Reporting Bugs

#### Before Submitting a Bug Report

A good bug report shouldn't leave others needing to chase you up for more information. Therefore, we ask you to investigate carefully, collect information and describe the issue in detail in your report. Please complete the following steps in advance to help us fix any potential bug as fast as possible.

- Make sure that you are using the latest version.
- Determine if your bug is really a bug and not an error on your side e.g. using incompatible environment components/versions (Make sure that you have read the documentation. If you are looking for support, you might want to check [this section](#i-have-a-question)).
- To see if other users have experienced (and potentially already solved) the same issue you are having, check if there is not already a bug report existing for your bug or error in the [issues](https://github.com/connor-ricks/swift-vapor-route-builder/issues).
- Collect information about the bug:
- Stack trace (Traceback)
- OS, Platform and Version (iOS, macOS, tvOS, visionOS, watchOS)
- Version of the interpreter, compiler, SDK, runtime environment, package manager, depending on what seems relevant.
- Possibly your input and the output
- Can you reliably reproduce the issue? And can you also reproduce it with older versions?

#### How Do I Submit a Good Bug Report?

> You must never report security related issues, vulnerabilities or bugs including sensitive information to the issue tracker, or elsewhere in public. Instead sensitive bugs must be sent by email to `swift-vapor-route-builder+connor.ricks@gmail.com`.

We use GitHub issues to track bugs and errors. If you run into an issue with the project:

- Open an [Issue](https://github.com/connor-ricks/swift-vapor-route-builder/issues/new). (Since we can't be sure at this point whether it is a bug or not, we ask you not to talk about a bug yet and not to label the issue.)
- Explain the behaviour you would expect and the actual behaviour.
- Please provide as much context as possible and describe the *reproduction steps* that someone else can follow to recreate the issue on their own. This usually includes your code. For good bug reports you should isolate the problem and create a reduced test case.
- Provide the information you collected in the previous section.

### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion for swift-vapor-route-builder, **including completely new features and minor improvements to existing functionality**. Following these guidelines will help maintainers and the community to understand your suggestion and find related suggestions.

#### Before Submitting an Enhancement

- Make sure that you are using the latest version.
- Read the documentation carefully and find out if the functionality is already covered, maybe by an individual configuration.
- Perform a [search](https://github.com/connor-ricks/swift-vapor-route-builder/issues) to see if the enhancement has already been suggested. If it has, add a comment to the existing issue instead of opening a new one.
- Find out whether your idea fits with the scope and aims of the project. It's up to you to make a strong case to convince the project's developers of the merits of this feature. Keep in mind that we want features that will be useful to the majority of our users and not just a small subset. If you're just targeting a minority of users, consider writing an add-on/plugin library.

#### How Do I Submit a Good Enhancement Suggestion?

Enhancement suggestions are tracked as [issues](https://github.com/connor-ricks/swift-vapor-route-builder/issues).

- Use a **clear and descriptive title** for the issue to identify the suggestion.
- Provide a **step-by-step description of the suggested enhancement** in as many details as possible.
- **Describe the current behaviour** and **explain which behaviour you expected to see instead** and why. At this point you can also tell which alternatives do not work for you.
- You may want to **include screenshots and animated GIFs** which help you demonstrate the steps or point out the part which the suggestion is related to. You can use [this tool](https://www.cockos.com/licecap/) to record GIFs on macOS and Windows, and [this tool](https://github.com/colinkeenan/silentcast) or [this tool](https://github.com/GNOME/byzanz) on Linux. <!-- this should only be included if the project has a GUI -->
- **Explain why this enhancement would be useful** to most swift-vapor-route-builder users. You may also want to point out the other projects that solved it better and which could serve as inspiration.

## Styleguides
### Commit Messages

All commits in this repo should have an associated emoji. This can be useful to quickly scan the git history for commits of relevance.

To have emojis automatically inserted into your commits when you type a keyword, run the following command within the repo's folder.

```
./Utilities/setup.sh
```

This will setup a git hook that will parse keywords between `:` into emojis when you make a commit.

For example, comitting 

```
:initial: :feature: Created a new nibble!
```

Will result in the git hook converting the commit message to

```
🎉 ✨ Created a new nibble!
```

Below is a list of supported keywords, along with their associated usages and emojis

| Emoji | Keyword           | Usage                                          |
|-------|-------------------|------------------------------------------------|
| 🐛    | bug               | Indicates a bug fix.                           |
| 🧹    | cleanup           | Indicates a small cleanup of code.             |
| 📦    | dependency        | Indicates the addition of a dependency.        |
| 📚    | docs              | Indicates documentation updates.               |
| ✨    | feauture          | Indicates a new feature.                       |
| 🛠    | fixup             | Indicates a quick tweak of code.               |
| 🎉    | initial           | Indicates an initial commit of a project.      |
| 🏎    | performance       | Indicates improvements to performance.         |
| ♻️    | refactor          | Indicates code refactoring.                    |
| 🗑️    | removal           | Indicates the removal of code.                 |
| 🔒    | security          | Indicates a security fix.                      |
| 🎨    | styling           | Indicates changes to code styling.             |
| 🔖    | tag               | Indicates a tag for a version.                 |
| 🧪    | tests             | Indicates test related work.                   |
| 🧰    | tooling           | Indicates changes to tooling (Such as Actions) |
| 🚧    | wip               | Indicates work that is in-progress.            |


## Attribution
This guide is based on the **contributing-gen**. [Make your own](https://github.com/bttger/contributing-gen)!