//
//  CardView.swift
//  CardPaymentApp
//
//  Created by Exaltare Technologies Pvt LTd. on 14/03/22.
//

import UIKit

//MARK: - Card View
class CardView: UIControl {

    //MARK: - Outlets
    lazy var labelCardNumber = UILabel()
    lazy var labelExpiryDate = UILabel()
    lazy var labelCVV = UILabel()
    
    lazy var labelTitleCardNumber = UILabel()
    lazy var labelTitleExpiryDate = UILabel()
    lazy var LabelTitleCVV = UILabel()
    
    lazy var imageViewIcon = UIImageView()
    
    lazy var cardNumberVstack = UIStackView(arrangedSubviews: [self.labelTitleCardNumber,self.labelCardNumber])
    
    lazy var cardExpiryDateVstack = UIStackView(arrangedSubviews: [self.labelTitleExpiryDate,self.labelExpiryDate])
    
    lazy var cardCvvVstack = UIStackView(arrangedSubviews: [self.LabelTitleCVV,self.labelCVV])
    
    lazy var cardExpiryCvvHstack = UIStackView(arrangedSubviews: [cardExpiryDateVstack,cardCvvVstack,UIStackView()])
    
    lazy var cardNumberExpiryCvvVstack = UIStackView(arrangedSubviews: [cardNumberVstack,cardExpiryCvvHstack])
    
    // MARK: - Properties
    @IBInspectable var icon: UIImage? {
        get { return imageViewIcon.image }
        set { imageViewIcon.image = newValue }
    }
    
    @IBInspectable var font: UIFont? {
        get { return labelCVV.font }
        set { _setFont(newValue) }
    }
    
    @IBInspectable var iconTintColor: UIColor {
        get { return imageViewIcon.tintColor }
        set { _setIconColor(newValue) }
    }
    
    var cardNumber: String? {
        get { return labelCardNumber.text }
        set {
            if let value = newValue,!value.isEmpty{
                labelCardNumber.text = value
            }
            else{
                labelCardNumber.text = StringConstant.labelDefaultCardNumber
            }
        }
    }
    
    var expiryDate: String? {
        get { return labelExpiryDate.text }
        set {
            if let value = newValue,!value.isEmpty{
                labelExpiryDate.text = value
            }
            else{
                labelExpiryDate.text = StringConstant.labelDefaultExpiryDate
            }
        }
    }
    
    var cvvNumber: String? {
        get { return labelCVV.text }
        set {
            if let value = newValue,!value.isEmpty{
                labelCVV.text = value
            }
            else{
                labelCVV.text = StringConstant.labelDefaultCVV
            }
        }
    }
    
    //MARK: - Init Methods
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

// MARK: - SetUI and Properties Methods
extension CardView{
    /// set Properties
    private func setupView() {
        UIFont.loadFonts()
        
        addSubview(imageViewIcon)
        addSubview(cardNumberExpiryCvvVstack)
        setTitle()
        _setTextColor(.white)
        iconTintColor = .white
        
        //set card number Expiry date Cvv Vstack Properties
        cardNumberExpiryCvvVstack.axis = .vertical
        cardNumberExpiryCvvVstack.spacing = 25
        cardNumberExpiryCvvVstack.alignment = .fill
        cardNumberExpiryCvvVstack.distribution = .equalCentering
        
        // set card number Vstack Properties
        cardNumberVstack.axis = .vertical
        cardNumberVstack.spacing = 3
        cardNumberVstack.alignment = .fill
        cardNumberVstack.distribution = .fill
        
        // set Expiry date Vstack Properties
        cardExpiryDateVstack.axis = .vertical
        cardExpiryDateVstack.spacing = 3
        cardExpiryDateVstack.alignment = .fill
        cardExpiryDateVstack.distribution = .equalCentering
        
        // set CVV Vstack Properties
        cardCvvVstack.axis = .vertical
        cardCvvVstack.spacing = 3
        cardCvvVstack.alignment = .fill
        cardCvvVstack.distribution = .equalCentering
        
        // set Expiry CVV Vstack Properties
        cardExpiryCvvHstack.axis = .horizontal
        cardExpiryCvvHstack.spacing = 15
        cardExpiryCvvHstack.alignment = .fill
        cardExpiryCvvHstack.distribution = .fillEqually
        
        setUIConstrain()
    }
    
    ///set Titles
    private func setTitle(){
        imageViewIcon.image = UIImage(named: "visa")
        // set title Fonts
        self._setTitleFont(labelTitleCardNumber)
        self._setTitleFont(labelTitleExpiryDate)
        self._setTitleFont(LabelTitleCVV)
        
        // set number text Fonts
        self._setTextFont(labelCardNumber)
        self._setTextFont(labelExpiryDate)
        self._setTextFont(labelCVV)
        
        // set title text
        labelTitleCardNumber.text = StringConstant.labelTitleCardNumber
        labelTitleExpiryDate.text = StringConstant.labelTitleExpiryDate
        LabelTitleCVV.text = StringConstant.labelTitleCVV
        
        // set number lables Default Text
        labelCardNumber.text = StringConstant.labelDefaultCardNumber
        labelExpiryDate.text = StringConstant.labelDefaultExpiryDate
        labelCVV.text = StringConstant.labelDefaultCVV
        
    }
    
    ///set Constrain
    func setUIConstrain(){
        // set image View UIConstrain
        imageViewIcon.translatesAutoresizingMaskIntoConstraints = false
        imageViewIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        imageViewIcon.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        imageViewIcon.heightAnchor.constraint(equalTo: imageViewIcon.widthAnchor, multiplier: 2/3).isActive = true
        
        // set Vstack
        cardNumberExpiryCvvVstack.translatesAutoresizingMaskIntoConstraints = false
        cardNumberExpiryCvvVstack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
        cardNumberExpiryCvvVstack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25).isActive = true
//        cardCardNumberExpiryCvvVstack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30).isActive = true
        cardNumberExpiryCvvVstack.topAnchor.constraint(equalTo: imageViewIcon.topAnchor, constant: 30).isActive = true
    }
}

//MARK: - Private Methods
extension CardView{
    ///set icon color
    private func _setIconColor(_ color: UIColor) {
        imageViewIcon.tintColor = color
        imageViewIcon.tintColorDidChange()
    }
    
    /// set text Font
    private func _setFont(_ font: UIFont?) {
        labelCVV.font = font
        LabelTitleCVV.font = font
        labelExpiryDate.font = font
        labelTitleExpiryDate.font = font
        labelCardNumber.font = font
        labelTitleCardNumber.font = font
    }
    
    /// set Title label Font
    private func _setTitleFont(_ label: UILabel) {
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
//        label.font = UIFont(name: "Credit Card", size: 12)
    }
    
    /// set number text Fonts
    private func _setTextFont(_ label: UILabel) {
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
//        label.font = UIFont(name: "Credit Card", size: 14)
    }
    
    /// set label Text Color
    private func _setTextColor(_ Color:UIColor){
        labelCVV.textColor = Color
        LabelTitleCVV.textColor = Color
        labelExpiryDate.textColor = Color
        labelTitleExpiryDate.textColor = Color
        labelCardNumber.textColor = Color
        labelTitleCardNumber.textColor = Color
    }
}
