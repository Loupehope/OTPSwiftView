# TICodeView

![Version](https://img.shields.io/github/v/release/Loupehope/TICodeView)
![Platform](https://img.shields.io/badge/platform-iOS-green)
![License](https://img.shields.io/hexpm/l/plug?color=darkBlue)


A fully customizable verification code view.

<p align="left">
<img src="Assets/preview.gif" width=300 height=533>  
</p> 

# Usage
```swift 
class ViewController: UIViewController {
    let codeView = CustomCodeView() // Your custom Code View

    let config = TICodeConfig(codeSymbolsCount: 6, // Base configuration of your Code View
                               spacing: 6,
                               customSpacing: [2: 20])
                          
    let codeViewModel = CustomCodeViewModel(codeConfig: config) // Custom viewModel for Code View

    override func viewDidLoad() {
        super.viewDidLoad()

        /* 
          Add your codeView and set layout 
        */
        
        /* Configure codeView */
        
        codeView.configure(with: codeViewModel)
        
        /* Bind events */
        
        codeViewModel.onTextEnter = { code in
            // Get code from codeView
        }
        
        codeViewModel.set(text: <Some text>) // set text to codeView
        
        codeTextFieldViewModel.clearText() // remove all text from codeView
        
        codeTextFieldViewModel.set(focus: true|false) // set keyboard focus to codeView
    }
```

## OneCodeView
There is a base class that describes a single code view - **OneCodeView**. This class has neither layout nor appearance of input field.
```swift
open class OneCodeView: InitializableOneCodeView {
    public let codeTextField = OneCodeTextField() // Code textField
    
    public var onTap: (() -> Void)? // Closure for a tap gesture
    
    open override func addViews() { // Function to add our codeTextField to base view
        super.addViews()
        
        addSubview(codeTextField)
    }
}
```
To customize the appearance and layout of the one code view, you must inherit from the **OneCodeView**.


Don't forget to add UIGestureRecognizer to call closure `onTap?()`.
```swift
import TICodeView

class CustomOneCodeView: OneCodeView {
    override func addViews() {
        super.addViews()
        
        // Adding additional views to current view. The one code view has already been added.
    }
    
    override func configureLayout() {
        super.configureLayout()
    
        // Confgiure layout of subviews
    }
    
    override func bindViews() {
        super.bindViews()
        
        // Binding to data or user actions
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
        // Appearance configuration method
    }
}
```
## TICodeView
**TICodeView** is a base class that is responsible for the layout of single code views. As with **OneCodeView**, you should create an heir class to configure your code view.
```swift
import TICodeView

final class CodeView: TICodeView<CustomOneCodeView, CodeViewModel> {
    override func addViews() {
        super.addViews()
        
        // Adding additional views to current code view. The code view has already been added.
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        // Confgiure layout of subviews
    }
    
    override func bindViews() {
        super.bindViews()
        
        // Binding to data or user actions
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
        // Appearance configuration method
    }

    override func configure(with viewModel: CodeViewModel) {
        super.configure(with: viewModel)

        // Configure you code view with viewModel
    }
}
```
## TICodeViewModel
To receive information from the code view or to transfer it, you need to create a viewModel.
```swift
import TICodeView

final class CodeViewModel: TICodeViewModel {
    // Your additional code here
}
```

# Installation via SPM

```swift
package.append(.package(url: "https://github.com/Loupehope/TICodeView.git", from: "0.0.3"))
```

# License

TICodeView is available under the Apache License 2.0. See the LICENSE file for more info.
