//
//  ProfileVC.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/23/21.
//

import Foundation
import UIKit
import MessageUI

class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var navigation: Navigator?
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var addCodeButton: UIButton!
    @IBOutlet weak var shareToSocialButton: UIButton!
    
    let localStorage = LocalStorage()
    var user = ""
    var uid = ""
    var image: UIImage?
    var addMessage = ""
    var shareMessage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigation = Navigator(currentViewController: self)
        
        
        addCodeButton.layer.cornerRadius = 18
        shareToSocialButton.layer.cornerRadius = 18
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = 70
        
        // Allow profile image to be tapped to update it
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
        // Getting user info to display
        let userInfo = localStorage.getUser()
        
        self.user = userInfo.name
        self.uid = userInfo.uid
        self.userName.text = "\(user)"
        self.addMessage = "Add your friend \(self.user) on GhostRunner using the following code: \(self.uid)"
        self.shareMessage = "Try to beat my time on GhostRunner! Add me using the following code: \(self.uid)"
    }
    
    @IBAction func tapProfileImage(_ sender: Any) {
        presentProfilePicActionSheet()
    }
    
    // Provide options to either take a photo or select one from library
    func presentProfilePicActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "Take a new photo or choose from your library", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoLibrary()
        }))
      present(actionSheet, animated: true, completion: nil)
    }
    
    func presentCamera() {
        let pc = UIImagePickerController()
        pc.delegate = self
        pc.sourceType = .camera
        pc.allowsEditing = true
        present(pc, animated: true, completion: nil)
    }
    
    func presentPhotoLibrary() {
        let pc = UIImagePickerController()
        pc.delegate = self
        pc.sourceType = .photoLibrary
        pc.allowsEditing = true
        present(pc, animated: true, completion: nil)
    }
    
    // Here we can save and display the actual image information
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImage.image = image
            self.image = image
           // let userDb = UserDb()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Brings up the messaging options to send the add code
    @IBAction func addCodeButtonPress(_ sender: Any) {
        let vc = UIActivityViewController(activityItems: [self.addMessage], applicationActivities: nil)
        vc.excludedActivityTypes = [.addToReadingList, .airDrop, .assignToContact, .markupAsPDF, .openInIBooks, .postToFacebook, .postToFlickr, .postToTencentWeibo, .postToTwitter, .postToVimeo, .postToWeibo, .saveToCameraRoll]
        present(vc, animated: true, completion: nil)
    }
    
    // Possible issue here: If you don't have the social media apps then this just shows similar apps and is not really useful. Maybe that's acceptable?
    @IBAction func sharetoSocialButtonPress(_ sender: Any) {
        let vc = UIActivityViewController(activityItems: [self.shareMessage], applicationActivities: nil)
        vc.excludedActivityTypes = [.addToReadingList, .airDrop, .assignToContact, .markupAsPDF, .openInIBooks, .postToFlickr, .postToTencentWeibo, .postToVimeo, .postToWeibo, .saveToCameraRoll, .message, .mail]
        present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func homeButtonPress(_ sender: UIButton) {
        navigation?.goToHome()
    }
}

