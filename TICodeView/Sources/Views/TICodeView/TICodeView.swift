//
//  Copyright (c) 2020 Touch Instinct
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the Software), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

/// Basic textFieldView for entering the verification code
open class TICodeView<View: OneCodeView, ViewModel: TICodeViewModel>: BaseInitializableView {
    public private(set) var codeStackView = UIStackView()
    public private(set) var textFieldsCollection: [View] = []

    public var code: String {
        textFieldsCollection.compactMap { $0.codeTextField.text }.joined()
    }
    
    open override func addViews() {
        super.addViews()
        
        addSubview(codeStackView)
    }
    
    open override func configureAppearance() {
        super.configureAppearance()
        
        codeStackView.contentMode = .center
        codeStackView.distribution = .fillEqually
    }

    open func configure(with viewModel: ViewModel) {
        textFieldsCollection = createTextFields(numberOfFields: viewModel.codeConfig.codeSymbolsCount)
        
        codeStackView.addArrangedSubviews(textFieldsCollection)
        codeStackView.spacing = viewModel.codeConfig.spacing
        
        configure(customSpacing: viewModel.codeConfig.customSpacing, for: codeStackView)
        
        bindTextFields(with: viewModel)
        
        viewModel.delegate = self
    }
    
    open func updateFirstResponder(isFocus: Bool) {
        let textField = textFieldsCollection.first {
            $0.codeTextField.unwrappedText.isEmpty
        } ?? textFieldsCollection.last
        
        DispatchQueue.main.async {
            _ = isFocus
                ? textField?.codeTextField.becomeFirstResponder()
                : textField?.codeTextField.resignFirstResponder()
        }
    }
}

extension TICodeView: TICodeViewModelDelegate {
    public func update(text: String) {
        textFieldsCollection.first?.codeTextField.set(inputText: text)
    }
    
    public func update(focus: Bool) {
        updateFirstResponder(isFocus: focus)
    }
}

// MARK: - Configure textfields

private extension TICodeView {
    func configure(customSpacing: Spacing?, for stackView: UIStackView) {
        guard let customSpacing = customSpacing else {
            return
        }
        
        customSpacing.forEach { [weak self] viewIndex, spacing in
            guard viewIndex < stackView.arrangedSubviews.count, viewIndex >= 0 else {
                return
            }
            
            self?.set(spacing: spacing,
                      after: stackView.arrangedSubviews[viewIndex],
                      at: viewIndex,
                      for: stackView)
        }
    }
    
    func set(spacing: CGFloat,
             after view: UIView,
             at index: Int,
             for stackView: UIStackView) {
        if #available(iOS 11.0, *) {
            stackView.setCustomSpacing(spacing, after: view)
        } else {
            let emptyView = UIView(frame: .init(origin: .zero,
                                                size: .init(width: spacing,
                                                            height: .zero)))
            stackView.insertArrangedSubview(emptyView, at: index + 1)
        }
    }
    
    func createTextFields(numberOfFields: Int) -> [View] {
        var textFieldsCollection: [View] = []
        
        (0..<numberOfFields).forEach { _ in
            let textField = View()
            textField.codeTextField.previousTextField = textFieldsCollection.last?.codeTextField
            textFieldsCollection.last?.codeTextField.nextTextField = textField.codeTextField
            textFieldsCollection.append(textField)
        }
        
        return textFieldsCollection
    }
    
    func bindTextFields(with viewModel: ViewModel) {
        let onTextChanged: (() -> Void) = { [weak self] in
            guard let code = self?.code else { return }
            
            let correctedCode = code.prefix(viewModel.codeConfig.codeSymbolsCount).string
            viewModel.onTextEnter?(correctedCode)
        }
        
        let onTap: (() -> Void) = { [weak self] in
            self?.updateFirstResponder(isFocus: true)
        }
        
        textFieldsCollection.forEach {
            $0.codeTextField.onTextChanged = onTextChanged
            $0.onTap = onTap
        }
    }
}
