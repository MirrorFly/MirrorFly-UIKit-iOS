//
//  OtpViewController.swift
//  MirrorflyUIkit
//
//  Created by User on 17/08/21.
//

import UIKit
import FirebaseAuth
import FlyCore
import FlyCommon
import PhoneNumberKit

class OTPViewController: UIViewController {
    
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var pgHeader: UILabel!
    @IBOutlet weak var pgTxt: UILabel!
    @IBOutlet weak var mobileNumber: UITextField!
    @IBOutlet weak var countryCode: UILabel!
    @IBOutlet weak var getOtpBtn: UIButton!
    public var countryArray = [Country]()
    private var otpViewModel : OTPViewModel!
    let chatmanager = ChatManager.shared
    var countryRegion = ""
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        configureDefaults()
    }
    
    // MARK:- Functions
    func setupUI() {
        pgHeader.font = UIFont.font23px_appHeavy()
        pgTxt.font = UIFont.font14px_appLight()
        mobileNumber.font = UIFont.font15px_appMedium()
        countryCode.font = UIFont.font15px_appRegular()
        getOtpBtn.titleLabel?.font = UIFont.font16px_appSemibold()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        defaults.set(view.safeAreaLayoutGuide.layoutFrame.height, forKey: "safeAreaHeight")
        defaults.set(view.safeAreaLayoutGuide.layoutFrame.width, forKey: "safeAraeWidth")
    }
    
    func configureDefaults() {
        scroller.delegate = self
        otpViewModel =  OTPViewModel()
        mobileNumber.delegate = self
        otpViewModel.getCountryData(completionHandler: { (countryArray) in
            if let countries = countryArray, countries.count > 0 {
                self.countryArray  = countries
                DispatchQueue.main.async { [weak self] in
                    let countryCode = Locale.current.regionCode
                    if let country = self?.countryArray.first(where: {$0.code == countryCode}) {
                        self?.countryRegion = country.code
                        self?.countryCode.text = country.dial_code
                    } else {
                        self?.countryCode.text = self?.countryArray[0].dial_code
                        self?.countryRegion = self?.countryArray[0].code ?? ""
                    }
                }
            }
        })
    }
    
    // MARK:- Button Actions
    
    @IBAction func countryPicker(_ sender: Any) {
        self.closeKeyboard()
        let storyboard : UIStoryboard = UIStoryboard(name: Storyboards.main, bundle: nil)
        let country = storyboard.instantiateViewController(withIdentifier: Identifiers.countryPicker) as! CountryPickerViewController
        country.countryArray = countryArray
        country.delegate = self
        self.navigationController?.pushViewController(country, animated: true)
    }
    
    @IBAction func getOtp(_ sender: Any) {
        
            self.closeKeyboard()
        let phoneNumberKit = PhoneNumberKit()
        guard let mobileNumberText = mobileNumber.text else {
            return
        }
        if !mobileNumberText.isEmpty, let mobileNumber = mobileNumber.text, let countryCode = countryCode.text {
            let phoneNumber = countryCode + mobileNumber
            if mobileNumber.count >= minimumMobileNumber {
                if phoneNumberKit.isValidPhoneNumber(phoneNumber) {
                    FlyDefaults.myMobileNumber =  phoneNumber
                    if mobileNumber.isValidMobileNumber(mobileNumber: mobileNumber) {
                        if NetworkReachability.shared.isConnected {
                            startLoading(withText: pleaseWait)
                            //Request SMS
                            otpViewModel.requestOtp(phoneNumber: phoneNumber) {
                                (verificationID, error) in
                                if let error = error {
                                    self.stopLoading()
                                    DispatchQueue.main.async {
                                        let authError = error as NSError?
                                        if (authError?.code == AuthErrorCode.tooManyRequests.rawValue) {
                                            AppAlert.shared.showToast(message: ErrorMessage.otpAttempts)
                                        }else if (authError?.code == AuthErrorCode.invalidPhoneNumber.rawValue) {
                                            AppAlert.shared.showToast(message: ErrorMessage.validphoneNumber)
                                        }
                                    }
                                    return
                                }
                                if let verificationId = verificationID {
                                    DispatchQueue.main.async { [weak self] in
                                        self?.stopLoading()
                                        AppAlert.shared.showToast(message: SuccessMessage.successOTP)
                                        let vc = UIStoryboard.init(name: Storyboards.main, bundle: Bundle.main).instantiateViewController(withIdentifier: Identifiers.verifyOTPViewController) as? VerifyOTPViewController
                                        vc?.verificationId = verificationId
                                        vc?.mobileNumber = phoneNumber
                                        vc?.getMobileNumber = countryCode + " " + mobileNumber
                                        self?.navigationController?.pushViewController(vc!, animated: true)
                                        self?.mobileNumber.text = ""
                                    }
                                    
                                }
                            }
                        }else {
                        AppAlert.shared.showAlert(view: self, title: warning, message: ErrorMessage.noInternet, buttonTitle: okayButton)
                        }
                    }else {
                    AppAlert.shared.showAlert(view: self, title: warning, message: ErrorMessage.validphoneNumber, buttonTitle: okayButton)
                    }
                }else {
                AppAlert.shared.showAlert(view: self, title: warning, message: ErrorMessage.validphoneNumber, buttonTitle: okayButton)
                }
            } else {
            AppAlert.shared.showAlert(view: self, title: warning, message: ErrorMessage.shortMobileNumber, buttonTitle: okayButton)
            }
        }else {
            if mobileNumberText.isEmpty{
                AppAlert.shared.showAlert(view: self, title: warning, message: ErrorMessage.enterMobileNumber, buttonTitle: okayButton)
            }else{
                AppAlert.shared.showAlert(view: self, title: warning, message: ErrorMessage.validphoneNumber, buttonTitle: okayButton)
            }
        }
    }
    
    func closeKeyboard() {
        self.view.endEditing(true)
    }
   
}

extension OTPViewController:  UIScrollViewDelegate {
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        closeKeyboard()
    }
}

extension OTPViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var returnValue = true
        guard let text = textField.text else { return true }
        print(text)
        let newLength = text.count + string.count - range.length
                let allowedCharacters = CharacterSet(charactersIn:"0123456789")
                let characterSet = CharacterSet(charactersIn: string)
        let length = newLength <= maximumMobileNumber
        let allowedChar = allowedCharacters.isSuperset(of: characterSet)
        if length, allowedChar{
            returnValue = true
        }else{
            returnValue = false
        }
        return returnValue
    }
}

extension OTPViewController: CountryPickerDelegate {
    func selectedCountry(country: Country) {
        countryCode.text = country.dial_code
    }
}