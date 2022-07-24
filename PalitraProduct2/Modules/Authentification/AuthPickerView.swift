
import Foundation
import UIKit

typealias PickerTextFieldDisplayNameHandler = ((Any) -> String)
typealias PickerTextFieldItemSelectionHandler = ((Int, Any) -> Void)

final class AuthPickerView: UITextField {
    
    private let pickerView = UIPickerView(frame: .zero)
    private var lastSelectedRow: Int?
    
    public var pickerData : [Any] = []
    public var displayNameHandler: PickerTextFieldDisplayNameHandler?
    public var itemSelectionHandler: PickerTextFieldItemSelectionHandler?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        return .zero
    }
    
    private func configureView() {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.inputView = self.pickerView
        self.inputView?.backgroundColor = .systemBackground
        self.inputView?.layer.cornerRadius = 10.0
        self.inputView?.clipsToBounds = true
        self.inputView?.layer.borderWidth = 1.0
        self.inputView?.layer.borderColor = UIColor.red.cgColor

        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        toolBar.backgroundColor = .systemBackground
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Выбрать", style: .plain, target: self, action: #selector(self.doneButtonDidTap))
        toolBar.setItems([spaceButton, doneButton], animated: false)
        self.inputAccessoryView = toolBar
    }
     
    private func updateText() {
        if self.lastSelectedRow == nil {
            self.lastSelectedRow = 0
        }
        if self.lastSelectedRow! > self.pickerData.count {
            return
        }
        let data = self.pickerData[self.lastSelectedRow!]
        self.text = self.displayNameHandler?(data)
    }
    
    @objc private func doneButtonDidTap() {
        self.updateText()
        self.resignFirstResponder()
    }
}

extension AuthPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let data = self.pickerData[row]
        return self.displayNameHandler?(data)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.lastSelectedRow = row
        self.updateText()
        let data = self.pickerData[row]
        self.itemSelectionHandler?(row, data)
    }
}


