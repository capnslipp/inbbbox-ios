#  Inbbbox

Inbbbox is an application where you can browse shots from Dribbble in easy enjoyable way!

### Tools & requirements

- Xcode 7.1 with iOS 9.1 SDK
- [Carthage](https://github.com/Carthage/Carthage) 0.11.0 or newer
- [CocoaPods](https://github.com/CocoaPods/CocoaPods) 0.39.0 or newer

### Configuration

Assuming the above tools are already installed, run the following commands after cloning the repository:

- `carthage update`
- `pod install`

### Coding guidelines

- Respect [Swift style guide](https://github.com/netguru/swift-style-guide).
- Use [clang-format Xcode plugin](https://github.com/travisjeffery/ClangFormat-Xcode). Enable the "File" and "Format on save" options. 
- The code must be readable and self-explanatory - full variable names, meaningful methods, etc.
- Write documentation comments in header files **only when needed** (eg. hacks, tricky parts).
- **Write tests** for every bug you fix and every feature you deliver.
- **Don't leave** any commented-out code.
- Use following flags to indicate:
	- `// NGRFixme:` - buggy code to repair
	- `// NGRHack:` - hacky code
	- `// NGRTemp:` - temporary solutions
   - `// NGRTodo:` - job to do.

### Workflow

- Always hit ⌘U (Product → Test) before committing.
- Always commit to master. No remote branches, forks and pull requests.
- Wait for CI build to succeed before delivering a ticket in Jira.
- Use `[ci skip]` in the commit message just for non-code changes.
