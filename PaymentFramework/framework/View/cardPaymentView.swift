//
//  cardPaymentView.swift
//  CardPaymentApp
//
//  Created by Exaltare Technologies Pvt LTd. on 10/03/22.
//

import Foundation
import UIKit

@IBDesignable public class cardPaymentView :UIControl{
    
    //MARK: - Outlets
    /// A boolean indicating if the card details provided pass all the validation (length, Luhn, expiration, etc.)
    public var isValid: Bool { return _model.cardPaymentmodel.cardValid }
    /// The color of the border on each field
    @IBInspectable public var borderColor: UIColor = ColorConstant.borderColor { didSet { updateStyling() } }
    /// The color of the background on buttonPay and CardView
    @IBInspectable public var themeColor: UIColor = ColorConstant.themeColor { didSet { buttonPay.backgroundColor = themeColor
        cardView.backgroundColor = themeColor
    } }
    /// The color of the Title on buttonPay
    @IBInspectable public var buttonTitleColor: UIColor = ColorConstant.buttonTitleColor { didSet { buttonPay.setTitleColor(buttonTitleColor, for: .normal) } }
    /// The tint color for the icons in the view
    @IBInspectable public var iconColor: UIColor = ColorConstant.iconColor { didSet { updateStyling() } }
    /// The color used to error any fields that do not pass validation
    @IBInspectable public var errorColor: UIColor = ColorConstant.errorColor { didSet { updateStyling() } }
    /// The color used for text in the fields.
    @IBInspectable public var textColor: UIColor = ColorConstant.textColor { didSet { updateStyling() } }
    /// The color used for placeholder in the fields.
    @IBInspectable public var placeHolderColor: UIColor = ColorConstant.textColor { didSet { updateStyling() } }
    
    /// Card number field placeholder text.  Use this property for localization.
    @IBInspectable public var cardNumberPlaceholderText: String? {
        get { return numberField.placeholder }
        set { numberField.placeholder = newValue
            guard let newValue = newValue else { return }
            StringConstant.placeHolderCardNumber = newValue
        }
    }
    
    /// card expiry field placeholder text.  Use this property for localization.
    @IBInspectable public var cardExpiryPlaceholderText: String? {
        get { return expiryField.placeholder }
        set { expiryField.placeholder = newValue
            guard let newValue = newValue else { return }
            StringConstant.placeHolderExpiryDate = newValue
        }
    }
    
    /// CVV field placeholder text.  Use this property for localization.
    @IBInspectable public var cardCvvPlaceholderText: String? {
        get { return cvvField.placeholder }
        set { cvvField.placeholder = newValue
            guard let newValue = newValue else { return }
            StringConstant.placeHolderCVV = newValue
        }
    }
    
    /// The next used for the next button on the keyboard toolbar.  Use this property for localization.
    @IBInspectable public var nextButtonText: String? {
        get { return nextButton.title }
        set { nextButton.title = newValue
            guard let next = newValue else { return }
            StringConstant.buttonTitleNext = next
        }
    }
    
    //MARK: - Properties
    lazy var cardView = CardView()
    private lazy var numberField = lazyTextField()
    private lazy var expiryField = ExpiryPickerField()
    private lazy var cvvField = lazyTextField()
    //    lazy var expiryField = lazyTextField()
    
    lazy var buttonPay = UIButton()
    
    private lazy var keyboardToolbar: UIToolbar = lazyKeyboardToolbar()
    private lazy var nextButton: UIBarButtonItem = lazyKeyboardNextButton()
    private lazy var doneButton: UIBarButtonItem = lazyKeyboardDoneButton()
    
    private lazy var expiryCvvStack = lazyStackView(axis: .horizontal, spacing: 20, views: [expiryField, cvvField])
    
     lazy var fieldStack = lazyStackView(axis: .vertical, spacing: 10, views: [numberField, expiryCvvStack])
    
    var _model: CardPaymentViewModel = CardPaymentViewModel.shared
    
    //MARK: - Init Method
    public init() {
        super.init(frame: .zero)
        setupView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
}

// MARK: - SetUI, Properties and Actions Methods
extension cardPaymentView {
    /// set Properties
    private func setupView() {
        _model.modelDidSet = {[self] in
            render(_model.cardPaymentmodel)
            sendActions(for: .valueChanged)
        }
        
        addSubview(cardView)
        addSubview(fieldStack)
        addSubview(buttonPay)
        
        // set Card View properties
        cardView.addShadow(color: ColorConstant.shadowColor, radius: 10)
        cardView.backgroundColor = themeColor
        cardView.layer.cornerRadius = 10
        
        // set stack View Properties
        expiryCvvStack.distribution = .fillEqually
        fieldStack.distribution = .fillEqually
        
        // set number field Properties
        numberField.keyboardType = .numberPad
        numberField.returnKeyType = .next
        numberField.clearButtonMode = .always
        
        // set Expiry field properties
//        expiryField.keyboardType = .numberPad
//        expiryField.returnKeyType = .next
//        expiryField.clearButtonMode = .always
        
        // set cvv field properties
        cvvField.keyboardType = .numberPad
        cvvField.returnKeyType = .done
        cvvField.clearButtonMode = .always
        cvvField.isSecureTextEntry = true
        
        // set accessory View each fields
        numberField.inputAccessoryView = keyboardToolbar
        expiryField.inputAccessoryView = keyboardToolbar
        cvvField.inputAccessoryView = keyboardToolbar
        
        
        setUIConstrain()
        setupActions()
        setupStaticValues()
        
        // render the initial state
        render(_model.cardPaymentmodel)
    }
    
    /// Set UI Constrain
    func setUIConstrain(){
        let width = UIScreen.main.bounds.width<UIScreen.main.bounds.height ? UIScreen.main.bounds.width : UIScreen.main.bounds.height
        // set card View UIConstrain
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        cardView.widthAnchor.constraint(equalToConstant: width - 40).isActive = true
//        cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
//        cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        cardView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        cardView.heightAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.5).isActive = true
        
        // set FieldStack UI Constrain
        fieldStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18).isActive = true
        fieldStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18).isActive = true
        fieldStack.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 25).isActive = true
        // set Number field UI constrain
        numberField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        // set Button Pay UI Constrain
        buttonPay.translatesAutoresizingMaskIntoConstraints = false
        buttonPay.trailingAnchor.constraint(equalTo: fieldStack.trailingAnchor, constant: 0).isActive = true
        buttonPay.leadingAnchor.constraint(equalTo: fieldStack.leadingAnchor, constant: 0).isActive = true
        buttonPay.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
        buttonPay.heightAnchor.constraint(equalToConstant: 45).isActive = true
        buttonPay.topAnchor.constraint(greaterThanOrEqualTo: fieldStack.bottomAnchor, constant: 15).isActive = true
        
//        fieldStack.bottomAnchor.constraint(lessThanOrEqualTo: buttonPay.topAnchor, constant: -500).isActive = true
//        fieldStack.bottomAnchor.constraint(greaterThanOrEqualTo: buttonPay.topAnchor, constant: 20).isActive = true
        
    }
    
    ///set Action each fields or button
    private func setupActions() {
        
        // edit change or value change Action set
        numberField.addTarget(self, action: #selector(numberChanged(_:)), for: .editingChanged)
        cvvField.addTarget(self, action: #selector(cvcChanged(_:)), for: .editingChanged)
//        expiryField.addTarget(self, action: #selector(expiryDateChanged(_:)), for: .editingChanged)
        expiryField.addTarget(self, action: #selector(expiryChanged(_:)), for: .valueChanged)
        
        //did begin editing Value change Action set
        numberField.addTarget(self, action: #selector(numberEditingBegan(_:)), for: .editingDidBegin)
        expiryField.addTarget(self, action: #selector(expiryEditingBegan(_:)), for: .editingDidBegin)
        cvvField.addTarget(self, action: #selector(cvcEditingBegan(_:)), for: .editingDidBegin)
        
        //did end editing Value change Action set
        numberField.addTarget(self, action: #selector(numberEditingEnded), for: .editingDidEnd)
        expiryField.addTarget(self, action: #selector(expiryEditingEnded), for: .editingDidEnd)
        cvvField.addTarget(self, action: #selector(cvcEditingEnded), for: .editingDidEnd)
        
        //tutch up inside Value change Action set
        buttonPay.addTarget(self, action: #selector(PayAction(_:)), for: .touchUpInside)
    }
    
    private func setupStaticValues() {
        // These values are not localized, it is on the integrator to localize the placholders using the properties provided
        numberField.placeholder = StringConstant.placeHolderCardNumber
        expiryField.placeholder = StringConstant.placeHolderExpiryDate
        cvvField.placeholder = StringConstant.placeHolderCVV
        
        // Expiry field and cvv field icon set
        expiryField.icon = ImageConstant.imageExpiry
        expiryField.iconTintColor = iconColor
        cvvField.icon = ImageConstant.imageCvv
        
        // button pay properties set
        buttonPay.setTitle(StringConstant.buttonTitlePay, for: .normal)
        buttonPay.setTitleColor(buttonTitleColor, for: .normal)
        buttonPay.backgroundColor = themeColor
        buttonPay.setAttributedTitle(NSAttributedString(string: StringConstant.buttonTitlePay, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: (buttonPay.titleLabel?.font.pointSize)!)]), for: .normal)
        buttonPay.layer.cornerRadius = 10
    }
    
    // if model any properties value cahnge call this method
    private func render(_ viewModel: CardPaymentModel) {
        numberField.icon = viewModel.cardBrandIcon
        cardView.icon = viewModel.cardBrandIcon
        
        numberField.text = viewModel.formattedCardNumber
        cardView.cardNumber = viewModel.formattedCardNumber
        
        
        expiryField.monthSelectionTitles = viewModel.expiryMonthTitles
        expiryField.yearSelectionTitles = viewModel.expiryYearTitles
        expiryField.selectedMonthIndex = viewModel.selectedExpiryMonthIndex
        expiryField.selectedYearIndex = viewModel.selectedExpiryYearIndex
        
        expiryField.text = viewModel.formattedExpiryDate
        cardView.expiryDate = viewModel.formattedExpiryDate
        cvvField.text = viewModel.formattedExpiryCvv
        var cvv = ""
        for _ in viewModel.formattedExpiryCvv ?? ""{
            cvv.append("*")
        }
        cardView.cvvNumber = cvv
    }
}

//MARK: - @IBActions
extension cardPaymentView {
    @IBAction func numberChanged(_ sender: Any) {
        _model.cardPaymentmodel.formattedCardNumber = numberField.text
    }

//    @IBAction func expiryDateChanged(_ sender: Any) {
//        _model.formattedExpiryDate = expiryField.text
//    }
    
    @IBAction func expiryChanged(_ sender: Any) {
        _model.cardPaymentmodel.updateExpirySelection(month: expiryField.selectedMonthIndex, year: expiryField.selectedYearIndex)
    }
    
    @IBAction func cvcChanged(_ sender: Any) {
        _model.cardPaymentmodel.formattedExpiryCvv = cvvField.text
    }
    
    @IBAction func numberEditingBegan(_ sender: Any) {
//        numberField.underlineColor = tintColor
//        numberField.borderColor = themeColor
        nextButton.target = self
        nextButton.action = #selector(selectExpiryAction(_:))
        keyboardToolbar.items = [doneButton, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), nextButton]
    }
    
//    @IBAction func nameEditingBegan(_ sender: Any) {
//        nextButton.target = self
//        nextButton.action = #selector(selectExpiryAction(_:))
//        keyboardToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), nextButton]
//    }
    
//    @IBAction func expiryEditingBegan(_ sender: Any) {
//        expiryField.underlineColor = tintColor
//        nextButton.target = self
//        nextButton.action = #selector(selectCvcAction(_:))
//        keyboardToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), nextButton]
//    }
    
    @IBAction func expiryEditingBegan(_ sender: Any) {
        _model.cardPaymentmodel.initiateExpiryEditing()
//        expiryField.underlineColor = tintColor
//        expiryField.borderColor = themeColor
        nextButton.target = self
        nextButton.action = #selector(selectCvvAction(_:))
        keyboardToolbar.items = [doneButton, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), nextButton]
    }
    
    @IBAction func cvcEditingBegan(_ sender: Any) {
//        cvvField.underlineColor = tintColor
//        cvvField.borderColor = themeColor
        keyboardToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton]
    }
    
    @IBAction func numberEditingEnded() {
        if _model.cardPaymentmodel.numberValid{
//            numberField.underlineColor = underlineColor/
            numberField.borderColor = borderColor
//            numberField.error = nil
        }
        else{
//            numberField.underlineColor = errorColor
            numberField.borderColor = errorColor
//            numberField.error = StringConstant.errorCardNumber
        }
        fieldStack.layoutIfNeeded()
    }
    
//    @IBAction func expiryEditingEnded() {
//        if _model.expiryDateValid{
//            expiryField.underlineColor = underlineColor
//            expiryField.error = nil
//        }
//        else{
//            expiryField.underlineColor = errorColor
//            expiryField.error = StringConstant.errorExpiryDate
//        }
//        expiryCvvStack.layoutIfNeeded()
//        fieldStack.layoutIfNeeded()
//    }
    
    @IBAction func expiryEditingEnded() {
//        expiryField.underlineColor = _model.expiryValid ? underlineColor : errorColor
        expiryField.borderColor = _model.cardPaymentmodel.expiryValid ? borderColor : errorColor
    }
    
    @IBAction func cvcEditingEnded() {
        if _model.cardPaymentmodel.cvvValid{
//            cvvField.underlineColor = underlineColor
            cvvField.borderColor = borderColor
//            cvvField.error = nil
        }
        else{
//            cvvField.underlineColor = errorColor
            cvvField.borderColor = errorColor
//            cvvField.error = StringConstant.errorCVV
        }
        expiryCvvStack.layoutIfNeeded()
        fieldStack.layoutIfNeeded()
    }
    
    @IBAction func PayAction(_ sender: Any) {
        if !isValid{
            setBorderColor()
        }
        else{
            _ = resignFirstResponder()
            _model.start()
        }
        
    }
}


// MARK: - Lazy Constructor Functions
extension cardPaymentView {
    private func lazyStackView(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment = .fill, spacing: CGFloat = 8, views: [UIView] = []) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = axis
        stack.alignment = alignment
        stack.spacing = spacing
        return stack
    }
    
    private func lazyTextField(alignment: NSTextAlignment = .natural) -> DynamicTextField {
        let textFields = DynamicTextField()
        textFields.tintColor = iconColor
        textFields.textAlignment = alignment
        textFields.translatesAutoresizingMaskIntoConstraints = false
        return textFields
    }
    
    private func lazyKeyboardToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.tintColor = tintColor
        toolbar.sizeToFit()
        return toolbar
    }
    
    private func lazyKeyboardDoneButton() -> UIBarButtonItem {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction(_:)))
        return button
    }
    
    private func lazyKeyboardNextButton() -> UIBarButtonItem {
        let button = UIBarButtonItem(title: StringConstant.buttonTitleNext, style: .done, target: self, action: nil)
        return button
    }
}

//extension cardPaymentView {
//
//    /// Card number field placeholder text.  Use this property for localization.
//    @IBInspectable public var cardNumberPlaceholderText: String? {
//        get { return numberField.placeholder }
//        set { numberField.placeholder = newValue }
//    }
//
//    /// card expiry field placeholder text.  Use this property for localization.
//    @IBInspectable public var cardExpiryPlaceholderText: String? {
//        get { return expiryField.placeholder }
//        set { expiryField.placeholder = newValue }
//    }
//
//    /// CVV field placeholder text.  Use this property for localization.
//    @IBInspectable public var cardCvcPlaceholderText: String? {
//        get { return cvvField.placeholder }
//        set { cvvField.placeholder = newValue }
//    }
//
//    /// The next used for the next button on the keyboard toolbar.  Use this property for localization.
//    @IBInspectable public var nextButtonText: String? {
//        get { return nextButton.title }
//        set { nextButton.title = newValue }
//    }
//}

//MARK: - private Methods
extension cardPaymentView {
    private func setBorderColor(){
        numberField.borderColor = _model.cardPaymentmodel.numberValid ? borderColor : errorColor
        expiryField.borderColor = _model.cardPaymentmodel.expiryValid ? borderColor : errorColor
        cvvField.borderColor = _model.cardPaymentmodel.cvvValid ? borderColor : errorColor
        
        if !_model.cardPaymentmodel.numberValid{
            numberField.becomeFirstResponder()
        }
        else if !_model.cardPaymentmodel.expiryValid{
            expiryField.becomeFirstResponder()
        }
        else if !_model.cardPaymentmodel.cvvValid{
            cvvField.becomeFirstResponder()
        }
    }
    
    private func updateStyling() {
        style(numberField)
        style(expiryField)
        style(cvvField)
    }
    
    private func style(_ field: DynamicTextField) {
        field.textColor = textColor
        field.iconTintColor = iconColor
        field.borderColor = borderColor
        field.setPlaceHolderColor(placeHolderColor)
    }
}

//MARK: - @objc Methods
extension cardPaymentView {
    @objc func doneAction(_ sender: Any) {
        _ = resignFirstResponder()
    }
    
    @objc func selectExpiryAction(_ sender: Any) {
        _ = expiryField.becomeFirstResponder()
    }
    
    @objc func selectCvvAction(_ sender: Any) {
        _ = cvvField.becomeFirstResponder()
    }
}

//MARK: - Override Methods
extension cardPaymentView {
    override public func prepareForInterfaceBuilder() {
        numberEditingBegan(self)
    }
    
    public override func tintColorDidChange() {
        keyboardToolbar.tintColor = tintColor
        keyboardToolbar.tintColorDidChange()
    }
    
    public override func resignFirstResponder() -> Bool {
        numberField.resignFirstResponder()
        expiryField.resignFirstResponder()
        cvvField.resignFirstResponder()
        sendActions(for: .editingDidEnd)
        return true
    }
}

//MARK: - UItextField Delegate Methods
extension cardPaymentView: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField as! DynamicTextField) == numberField {
            expiryField.becomeFirstResponder()
        } else if textField == expiryField {
            cvvField.becomeFirstResponder()
        } else if textField == cvvField {
            cvvField.resignFirstResponder()
        }
        return true
    }
}

