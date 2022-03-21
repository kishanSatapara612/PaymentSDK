//
//  textfileds.swift
//  CardPaymentApp
//
//  Created by Exaltare Technologies Pvt LTd. on 10/03/22.
//

import UIKit

//MARK: - TextField
@IBDesignable
class DynamicTextField: UITextField {

    //MARK: - Outlets
    var iconContainer: UIView = UIView()
    var iconView: UIImageView = UIImageView(image: nil)
//    var underlineView: UIView = UIView()
//    var labelError :UILabel = UILabel()

    //MARK: - Properties
    var isValid: Bool = true
    
    var borderColor: UIColor? {
        get { return UIColor(cgColor: self.layer.borderColor ?? ColorConstant.borderColor.cgColor)
        }
        set { self.layer.borderColor = newValue?.cgColor }
    }
    
    var icon: UIImage? {
        get { return iconView.image }
        set { _setIcon(newValue) }
    }
    
    var iconTintColor: UIColor {
        get { return iconView.tintColor }
        set { _setIconColor(newValue) }
    }
    
//    var errorColor: UIColor? {
//        get { return labelError.textColor }
//        set { labelError.textColor = newValue }
//    }
    
//    var underlineColor: UIColor? {
//        get { return underlineView.backgroundColor }
//        set { underlineView.backgroundColor = newValue }
//    }

    
    
//    var error: String? {
//        get { return labelError.text }
//        set{ _setError(_: newValue ?? nil) }
//    }
    
    //MARK: - Init Methods
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
}

//MARK: - Private Set Properties Methods
extension DynamicTextField {
    private func _setIcon(_ image: UIImage?) {
        iconView.image = image
        if image == nil {
            leftView = nil
        } else {
            leftView = iconContainer
        }
    }
    
    private func _setIconColor(_ color: UIColor) {
        iconView.tintColor = color
        iconView.tintColorDidChange()
    }
    
//    private func _setError(_ error:String? = nil){
//        if error == nil{
//            removeError()
//        }
//        else{
//            setError(error : error!)
//        }
//    }
}

//MARK: - Private setUI Methods
extension DynamicTextField {
    private func setupView() {
        borderColor = ColorConstant.themeColor
        setupIcon()
        leftView = iconContainer
        leftViewMode = .always
        setBorder()
//        underlineColor = .gray.
//        addSubview(underlineView)
//        setupUnderline()
    }
    
    private func setupIcon() {
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        iconView.contentMode = .scaleAspectFit
        iconContainer.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        iconContainer.addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.leadingAnchor.constraint(equalTo: iconContainer.leadingAnchor, constant: 10).isActive = true
        iconView.trailingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: -10).isActive = true
        iconView.topAnchor.constraint(equalTo: iconContainer.topAnchor, constant: 10).isActive = true
        iconView.bottomAnchor.constraint(equalTo: iconContainer.bottomAnchor, constant: -10).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    private func setBorder(){
        self.layer.cornerCurve = .circular
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = ColorConstant.borderColor.cgColor
    }
    
    func setPlaceHolderColor(_ color:UIColor){
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: color])
    }
//    private func setupUnderline() {
//        underlineView.translatesAutoresizingMaskIntoConstraints = false
//        var constraints = [underlineView.heightAnchor.constraint(equalToConstant: 1)]
//        constraints += underlineView.superviewConnectConstraints(edges: [.leading, .trailing,.bottom], useMargins: false)
//        NSLayoutConstraint.activate(constraints)
//    }
    
//    private func setError(error:String) {
//        labelError.text = error
//        labelError.textColor = .red
//        labelError.font = UIFont(name: labelError.font.familyName, size: 12)
//        addSubview(labelError)
//        labelError.translatesAutoresizingMaskIntoConstraints = false
//        var constraints = labelError.superviewConnectConstraints(edges: [.leading, .trailing], useMargins: false)
//        constraints.append(NSLayoutConstraint(item: labelError, attribute: .top, relatedBy: .equal, toItem: underlineView, attribute: .bottom, multiplier: 1, constant: 0))
//        NSLayoutConstraint.activate(constraints)
//    }
    
//    private func removeError() {
//        labelError.removeFromSuperview()
//    }
}
