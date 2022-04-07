//
//  UserProfileViewController.swift
//  MirrorflyUIkit
//
//  Created by sowmiya on 31/01/22.
//

import UIKit
import AVFoundation
import FlyCore
import FlyCommon
import Foundation
import MobileCoreServices
import Photos
import Toaster
import Tatsi
import QCropper
import SDWebImage
import PhoneNumberKit

class UserProfileViewController : UIViewController {
    @IBOutlet weak var profileImage: UIImageView?
    @IBOutlet weak var nameTextField: UITextField?
    @IBOutlet weak var emailTextField: UITextField?
    @IBOutlet weak var mobileNumberLabel: UILabel?
    @IBOutlet weak var statusButton: UIButton?
    @IBOutlet weak var statusLabel: UILabel?
    @IBOutlet weak var saveButton: UIButton?
    
    var isImagePicked: Bool = false
    let imagePickerController = UIImagePickerController()
    private let profileViewModel = ProfileViewModel()
    var profileImageLocalPath = String()
    var previewImage: UIImage!
    var getMobileNumber: String = ""
    var delegate: ProfileViewControllerProtocol?
    var getUserMobileNumber:String = ""
    var profileDetails: ProfileDetails? = nil
    // The last collection the user has selected. Set from the picker's delegate method.
    // It is not recommended to PHAssetCollection in persitant storage. If you do, check if the album is still available before showing the picker.
    var lastSelectedCollection: PHAssetCollection?
    
    // If the rememberCollectioSwitch is turned on we return the last known collection, if available.
     var firstView: TatsiConfig.StartView {
        if let lastCollection = self.lastSelectedCollection {
            return .album(lastCollection)
        } else {
            return .userLibrary
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setupUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UserProfileViewController.onProfileImage(_:)))
        profileImage?.isUserInteractionEnabled = true
        emailTextField?.isUserInteractionEnabled = false
        profileImage?.addGestureRecognizer(tapGesture)
        nameTextField?.addTarget(self, action: #selector(UserProfileViewController.textFieldDidChange(_:)),
                                for: .editingChanged)
    }
    
    func setupUI() {
        nameTextField?.textInputMode?.primaryLanguage == "emoji"
        nameTextField?.keyboardType = .default
        nameTextField?.adjustsFontSizeToFitWidth = false
        hideKeyboardWhenTappedAround()
        print(getMobileNumber)
        mobileNumberLabel?.text = getMobileNumber
        statusLabel?.text = inMirrorfly.localized
        profileImage?.layer.masksToBounds = false
        profileImage?.layer.cornerRadius = (profileImage?.frame.height ?? 0.0) / 2
        profileImage?.clipsToBounds = true
        startLoading(withText: pleaseWait)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
           self.getProfile()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        profileImage?.layer.cornerRadius = (profileImage?.frame.size.width ?? 0.0) / 2
        profileImage?.clipsToBounds = true
    }
    
    @objc func onProfileImage(_ recognizer: UIGestureRecognizer) {
        if profileDetails?.image.trim().count ?? 0 > 0 {
            isImagePicked = true
        }
        if(isImagePicked) {
            moveToImageViewer()
        }
    }
}

// MARK: Get ,update Profile and remove profile image

extension UserProfileViewController {
   
    func getProfile() {
        print( FlyDefaults.myXmppUsername)
        
        if(FlyDefaults.isProfileUpdated) {
        do {
            let JID = FlyDefaults.myXmppUsername + "@" + FlyDefaults.xmppDomain
         
            try ContactManager.shared.getUserProfile(for:  JID, fetchFromServer: true, saveAsFriend: true) { [weak self] isSuccess, flyError, flyData in
                var data  = flyData
                if(isSuccess) {
                DispatchQueue.main.async {
                    print(data.getData() as! ProfileDetails)
                    self?.profileDetails = data.getData() as? ProfileDetails
                      
                    print("profileDetails.image")
                    print(self?.profileDetails?.image)
                    if(self?.profileDetails?.image != "") {
                        self?.setImage(imageURL: self?.profileDetails?.image ?? "")
                        self?.isImagePicked = true
                    }
                    else {
                        self?.getUserNameInitial()
                    }
                    self?.nameTextField?.text = self?.profileDetails?.name
                    self?.emailTextField?.text = self?.profileDetails?.email
                    self?.getUserMobileNumber = self?.profileDetails!.mobileNumber ?? ""
                    let mobileNumberWithoutCountryCode = self?.mobileNumberParse(phoneNo: (self?.profileDetails!.mobileNumber)!)
                    self?.mobileNumberLabel?.text = "+91 " +  mobileNumberWithoutCountryCode!
                    self?.statusLabel?.text = self?.profileDetails?.status
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        self?.stopLoading()
                    }
                }
            }
        }
        } catch {
            self.stopLoading()
        }
        }
        else{
            saveButton?.setTitle(save.localized, for: .normal)
            self.stopLoading()
        }
    }
    
    func mobileNumberParse(phoneNo:String) -> String {
        var splittedMobileNumber:String = ""
        let phoneNumberKit = PhoneNumberKit()
          do {
            let phoneNumber = try phoneNumberKit.parse(phoneNo)
            splittedMobileNumber  = String(describing:phoneNumber.nationalNumber)
          }
          catch {
          }
        return splittedMobileNumber
    }

    func setImage(imageURL: String) {
        let urlString = "\(Environment.sandboxImage.baseURL)\(media)/\(imageURL)?mf=\(FlyDefaults.authtoken)"
        let url = URL(string: urlString)
        profileImage?.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "ic_profile_placeholder"))
    }

    // MARK: Update Profile
    func updateMyProfile(isRemovedProfileImage: Bool) {
        if NetworkReachability.shared.isConnected {
            let JID = FlyDefaults.myXmppUsername + "@" + FlyDefaults.xmppDomain
            startLoading(withText: pleaseWait)
            var myProfile = FlyProfile(jid: JID)
            guard let email = emailTextField?.text else {
                return
            }
            myProfile.email = email
            guard let mobileNumber = mobileNumberLabel?.text else {
                return
            }
            myProfile.mobileNumber = self.getUserMobileNumber
            
            guard let nickName = nameTextField?.text else {
                return
            }
            myProfile.nickName = nickName
            myProfile.name = nickName
            
            guard let status = statusLabel?.text else {
                return
            }
            myProfile.status = status
            if(isImagePicked) {
                myProfile.image = profileImageLocalPath
                if profileImageLocalPath.isEmpty && profileDetails?.image != ""{
                    myProfile.image = profileDetails?.image ?? ""
                    isImagePicked = false
                }
            }
            ContactManager.shared.updateMyProfile(for: myProfile, isFromLocal: isImagePicked) { isSuccess, flyError, flyData in
                self.stopLoading()
                var data  = flyData
                if isSuccess {
                    if isRemovedProfileImage == false {
                        AppAlert.shared.showToast(message: profileUpdateSuccess.localized)
                    }
                    Utility.saveInPreference(key: isProfileSaved, value: true)
                } else {
                    print(data.getMessage() as! String)
                    AppAlert.shared.showToast(message: "Please try again later")
                }
            }
        }
        
        else {
            AppAlert.shared.showToast(message: ErrorMessage.noInternet)
        }
    }
    
    //MARK: Remove Profile Image
    func removeProfileImage(fileUrl : String){
        if NetworkReachability.shared.isConnected {
            AppAlert.shared.showToast(message: profilePictureRemoved.localized)
            ContactManager.shared.removeProfileImage( completionHandler: { [weak self] isSuccess, flyError, flyData in
            var data  = flyData
              
            if isSuccess {
                print(data.getMessage() as! String )
                self?.updateMyProfile(isRemovedProfileImage: true)
            } else{
                print(data.getMessage() as! String )
            }
        })
        }
        else {
            AppAlert.shared.showToast(message: ErrorMessage.noInternet)
        }
    }
}

//MARK : Actions
extension UserProfileViewController {
    @IBAction func onCameraButton(_ sender: Any) {
        showActionSheet()
    }
    
    @IBAction func onStatusButton(_ sender: Any) {
         moveToEditStatusViewer()
    }
    
    @IBAction func onSaveButton(_ sender: Any) {
        guard let userName = nameTextField?.text else {return}
        guard let email = emailTextField?.text else {return}
        guard let mobileNumber = mobileNumberLabel?.text else {return}
        profileViewModel.profileCompletionHandler { (status, message) in
            if status {
                self.updateMyProfile(isRemovedProfileImage: false)
            } else {
                AppAlert.shared.showToast(message: message)
            }
        }
        profileViewModel.updateProfileWith(userName: userName, emailId: email, mobileNumber: mobileNumber)
    }
    
    func moveToImageViewer() {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        if let initialViewController = storyboard.instantiateViewController(withIdentifier: "ImageViewerViewController") as? ImageViewerViewController {
            initialViewController.getProfileImage = previewImage ?? profileImage?.image
            navigationController?.pushViewController(initialViewController, animated: true)
        }
    }
    
    func moveToEditStatusViewer() {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        if let editStatusViewController = storyboard.instantiateViewController(withIdentifier: "EditStatusViewController") as? EditStatusViewController {
            editStatusViewController.defaultStatus = statusLabel?.text
            editStatusViewController.delegate = self
            navigationController?.pushViewController(editStatusViewController, animated: true)
        }
    }
}

extension UserProfileViewController: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if(FlyDefaults.isProfileUpdated) {
            if(nameTextField?.text?.trimmingCharacters(in: .whitespacesAndNewlines) != profileDetails?.nickName || statusLabel?.text != profileDetails?.status) {
                saveButton?.setTitle(save.localized, for: .normal)
            }
            else {
                saveButton?.setTitle(save.localized, for: .normal)
            }
        }
       if(!isImagePicked) {
        if (textField == nameTextField) {
                getUserNameInitial()
            }
        }
    }
    
    func getUserNameInitial() {
        if(( nameTextField?.text?.count)! > 0) {
            if let trimmedName = nameTextField?.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                let ipimage = IPImage(text: trimmedName, radius: Double(profileImage?.frame.size.height ?? 0.0), font: UIFont.font84px_appBold(), textColor: nil, randomBackgroundColor:  false)
                profileImage?.image = ipimage.generateImage()
            }
        }
         else {
             profileImage?.image = UIImage.init(named: ImageConstant.ic_profile_placeholder)
         }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == nameTextField) {
            return  textLimit(existingText: textField.text, newText: string, limit: userNameMaxLength)
        }
        return true
    }
    
    func textView(_ textField: UITextField,
                    shouldChangeTextIn range: NSRange,
                    replacementText text: String) -> Bool{
        if(textField == nameTextField) {
          var nsString:NSString = ""
          
          if textField.text != nil  && text != "" {
              nsString = textField.text! as NSString
              nsString = nsString.replacingCharacters(in: range, with: text) as NSString
          }   else if (text == "") && textField.text != ""  {
              nsString = textField.text! as NSString
              nsString = nsString.replacingCharacters(in: range, with: text) as NSString
              
          } else if (text == "") && textField.text == "" {
            textField.text = ""
          }

          guard let texts = textField.text else { return true }
          let currentText = nsString as NSString
          if currentText.length >= userNameMaxLength {
            textField.text = currentText.substring(to: userNameMaxLength)
          }
          return currentText.length <= userNameMaxLength
        }
        
        return true
    }
    
    func textLimit(existingText: String?, newText: String, limit: Int) -> Bool {
          let text = existingText ?? ""
          let limitText = text.count + newText.count
          let isAtLimit = text.count + newText.count <= limit
          if limitText > limit {
           AppAlert.shared.showToast(message:  userNameValidation.localized)
          }
          return isAtLimit
      }
    
}

//MARK: ImagePicker Action
extension UserProfileViewController {
    func showActionSheet() {
        let alertAction = UIAlertController(title: nil, message:nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: takePhoto.localized, style: .default) { [weak self] _ in
            
            if NetworkReachability.shared.isConnected {
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self?.checkCameraPermissionAccess(sourceType: .camera)
            } else {
                AppAlert.shared.showAlert(view: self!, title: noCamera.localized, message: noCameraMessage.localized, buttonTitle: noCamera.localized)
            }
            }
            else {
                AppAlert.shared.showToast(message: ErrorMessage.noInternet)
            }
        }
        let galleryAction = UIAlertAction(title: chooseFromGallery.localized, style: .default) { [weak self] _ in
            if NetworkReachability.shared.isConnected {
            self?.checkGalleryPermissionAccess(sourceType: .photoLibrary)
            }
            else {
                AppAlert.shared.showToast(message: ErrorMessage.noInternet)
            }
        }
        let cancelAction = UIAlertAction(title: cancel, style: .cancel)
        
        alertAction.addAction(cameraAction)
        alertAction.addAction(galleryAction)
        if(isImagePicked) {
            let removeAction = UIAlertAction(title: removePhoto.localized, style: .default) { [weak self] _ in
                guard let self = self else {
                    return
                }
                if NetworkReachability.shared.isConnected {
                    AppAlert.shared.showAlert(view: self, title: alert, message: removePhotoAlert, buttonOneTitle: cancel, buttonTwoTitle: removeButton)
                    AppAlert.shared.onAlertAction = { [weak self] (result) ->
                        Void in
                        if result == 1 {
                            self?.isImagePicked = false
                            self?.profileDetails?.image = ""
                            guard let nameText = self?.nameTextField?.text else {
                                return
                            }
                            if(nameText.count > 0) {
                                self?.getUserNameInitial()
                            }
                            else {
                                self?.profileImage?.image = UIImage.init(named: ImageConstant.ic_profile_placeholder)
                            }
                         
                            self?.removeProfileImage(fileUrl:  self!.profileImageLocalPath)
                        }else {
                           
                        }
                    }
                }
                else {
                    AppAlert.shared.showToast(message: ErrorMessage.noInternet)
                }
            }
            alertAction.addAction(removeAction)
        }
        alertAction.addAction(cancelAction)
         present(alertAction, animated: true, completion: nil)
    }
    /**
     *  This function used to check camera Permission
     */
    func checkCameraPermissionAccess(sourceType: UIImagePickerController.SourceType) {
        let authorizationStatus =  AVCaptureDevice.authorizationStatus(for: .video)
        switch authorizationStatus {
        case .denied:
            presentCameraSettings()
            break
        case .restricted:
            break
        case .authorized:
            showImagePickerController(sourceType: sourceType)
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                   if granted {
                    print("Granted access to ")
                    self.showImagePickerController(sourceType: sourceType)
                   } else {
                       print("Denied access to")
                   }
            }
            break
        @unknown default:
            print("Permission failed")
        }
    }
    
    func presentCameraSettings() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "",
                message: cameraAccessDenied.localized,
                preferredStyle: UIAlertController.Style.alert
            )
            
            alert.addAction(UIAlertAction(title: cancel.localized, style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: settings.localized, style: .default, handler: { (alert) -> Void in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                    })
                    
                }
            }))
            
            self.present(alert, animated: false, completion: nil)
        }
    }
    
    /**
     *  This function used to check gallery Permission
     */
    func checkGalleryPermissionAccess(sourceType: UIImagePickerController.SourceType) {
        var config = TatsiConfig.default
        config.supportedMediaTypes = [.image]
        config.firstView = self.firstView
        config.maxNumberOfSelections = 1
        
        let pickerViewController = TatsiPickerViewController(config: config)
        pickerViewController.pickerDelegate = self
        pickerViewController.isEditing = true
        self.present(pickerViewController, animated: true, completion: nil)
    }
    
   func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    func getUIImage(asset: PHAsset) -> UIImage? {

        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in

            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }
}

//MARK: ImagePicker Delegate Method
extension UserProfileViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        DispatchQueue.main.async {
            self.imagePickerController.delegate = self
            self.imagePickerController.mediaTypes = ["public.image"]
            self.imagePickerController.sourceType = sourceType
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            isImagePicked = true
            if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let cropper = CropperViewController(originalImage: userPickedImage , isCircular: true)
            cropper.delegate = self
            picker.dismiss(animated: true) {
                self.present(cropper, animated: true, completion: nil)
                }
            }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension UserProfileViewController: StatusDelegate {
    func userSelectedStatus(selectedStatus: String) {
      
        statusLabel?.text = selectedStatus
        if(FlyDefaults.isProfileUpdated) {
            if(nameTextField?.text != profileDetails?.nickName || emailTextField?.text != profileDetails?.email || statusLabel?.text != profileDetails?.status) {
                saveButton?.setTitle(save.localized, for: .normal)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        AppAlert.shared.showToast(message: profileUpdateSuccess.localized)
        }
    }
}

//MARK : Photos cropping
extension UserProfileViewController: CropperViewControllerDelegate {
    func cropperDidConfirm(_ cropper: CropperViewController, state: CropperState?) {
        cropper.dismiss(animated: true, completion: nil)

        if let state = state,
            let image = cropper.originalImage.cropped(withCropperState: state) {
            
            self.profileImage?.contentMode = .scaleAspectFit
            self.previewImage = image
          
            profileImage?.image = image
            print(cropper.isCurrentlyInInitialState)
            print(image)
            
            let str = AppUtils.shared.getRandomString(length: 15)
            let fileName = str ?? ""
            profileImageLocalPath = AppUtils.shared.saveInDirectory(with:     profileImage?.image?.jpegData(compressionQuality: 1.0), fileName: fileName + jpg) ?? ""
            
            print("localPath--\( profileImageLocalPath)")
        }
    }
}

//MARK: For Gallery picker - Select photos and allow photos in permisssion
extension UserProfileViewController: TatsiPickerViewControllerDelegate {
    
    func pickerViewController(_ pickerViewController: TatsiPickerViewController, didSelectCollection collection: PHAssetCollection) {
        self.lastSelectedCollection = collection
        print("User selected collection: \(collection)")
    }
    
    func pickerViewController(_ pickerViewController: TatsiPickerViewController, didPickAssets assets: [PHAsset]) {
        print("Picked assets: \(assets)")
        
        let options = PHContentEditingInputRequestOptions()
        options.isNetworkAccessAllowed = false //for icloud backup assets
        let asset : PHAsset = assets .first!
        asset.requestContentEditingInput(with: options) { (contentEditingInput, info) in
            if let uniformTypeIdentifier = contentEditingInput?.uniformTypeIdentifier {
                var fullImage: CIImage? = nil
                if let fullSizeImageURL = contentEditingInput?.fullSizeImageURL {
                    fullImage = CIImage(contentsOf: fullSizeImageURL)
                }
                print("uniformTypeIdentifier", uniformTypeIdentifier)
                //if uniformTypeIdentifier == (kUTTypePNG as String) || uniformTypeIdentifier == (kUTTypeJPEG as String) {
                    self.isImagePicked = true
                    
                    guard let assetToImage = self.getUIImage(asset: asset) else {
                        return
                    }
                    let cropper = CropperViewController(originalImage: assetToImage, isCircular: true)
                    cropper.delegate = self
                    pickerViewController.dismiss(animated: true) {
                        self.present(cropper, animated: true, completion: nil)
                    }
                //}
                
//                else {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                        AppAlert.shared.showToast(message: unsupportedFile.localized)
//                    }

               // }
               
            }
        }
    }
    
    func setCroppedImage(_ croppedImage: UIImage) {
        self.profileImage?.image = croppedImage
    }
}