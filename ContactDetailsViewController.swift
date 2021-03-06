//
//  ContactDetailsViewController.swift
//  Familink
//
//  Created by formation 1 on 25/01/2019.
//  Copyright © 2019 CubaLibre. All rights reserved.
//

import UIKit
import MessageUI

class ContactDetailsViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    @IBOutlet weak var gravatarView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var phoneTitleLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profilTitleLabel: UILabel!
    @IBOutlet weak var profilLabel: UILabel!
    @IBOutlet weak var isFamilinkUserLabel: UILabel!
    @IBOutlet weak var isEmergencyUserLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    var contact: Contact!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViewContent()
        self.hideKeyboardGesture()
        self.initViewUI()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"edit"), style: .plain, target: self, action: #selector(onEditButtonPressed))
    }
    
    @IBAction func onEditButtonPressed() {
        let editContactController = EditContactViewController(nibName:nil, bundle: nil)
        editContactController.contact = contact
        self.navigationController?.pushViewController(editContactController, animated: true)
    }
    
    @IBAction func onMessageButtonTap(_ sender: Any) {
        UIView.animate(withDuration: -1, animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            self.messageButton.backgroundColor = .green
            UIView.animate(withDuration: -1, animations: {
                self.messageButton.backgroundColor = .rosyBrown
            }) { (_) in
                let messageVC = MFMessageComposeViewController()
                
                messageVC.body = "";
                messageVC.recipients = ([self.contact.phone] as! [String])
                messageVC.messageComposeDelegate = self
                
                if MFMessageComposeViewController.canSendText() {
                    self.present(messageVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case .cancelled:
            dismiss(animated: true, completion: nil)
        case .failed:
            print("Echec de l'envoi du message")
            dismiss(animated: true, completion: nil)
        case .sent:
            print("Message envoyé")
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    @IBAction func onCallButtonTap(_ sender: Any) {
        UIView.animate(withDuration: -1, animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            self.callButton.backgroundColor = .green
            UIView.animate(withDuration: -1, animations: {
                self.callButton.backgroundColor = .oldRose
            }) { (_) in
                guard let number = URL(string: "tel://" + self.contact.phone!) else { return }
                if (UIApplication.shared.canOpenURL(number)){
                    UIApplication.shared.open(number)
                }
                else {
                    let alert = UIAlertController(title: "Désolé !", message: "Votre téléphone ne supporte pas de passer des appels", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func onEmailButtonTap(_ sender: Any) {
        UIView.animate(withDuration: -1, animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            self.emailButton.backgroundColor = .green
            UIView.animate(withDuration: -1, animations: {
                self.emailButton.backgroundColor = .rosyBrown
            }) { (_) in
                if MFMailComposeViewController.canSendMail() {
                    guard let contactEmail = self.contact.email else {
                        return
                    }
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
                    mail.setToRecipients([contactEmail])
                    self.present(mail, animated: true)
                } else {
                    let alert = UIAlertController(title: "Désolé !", message: "Votre téléphone ne supporte pas l'envoi d'email", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func loadImageFromUrl(){
        guard let imageUrl = contact.gravatar else{return}
        guard let url = URL(string: imageUrl) else {return}
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else {return}
            DispatchQueue.main.async {
                self.gravatarView.image = UIImage(data: data)
            }
        }
    }
    
    func initViewContent() {
        loadImageFromUrl()
        firstNameLabel.text = contact.firstName
        lastNameLabel.text = contact.lastName
        phoneLabel.text = contact.phone
        emailLabel.text = contact.email
        profilLabel.text = contact.profile
        isFamilinkUserLabel.isHidden = !contact.isFamilinkUser
        isEmergencyUserLabel.isHidden = !contact.isEmergencyUser
    }
    
    func initViewUI() {
        self.navigationController?.navigationBar.barTintColor = .rosyBrown
        self.navigationController?.navigationBar.tintColor = .seaShell
        self.view.backgroundColor = .seaShell
        
        firstNameLabel.textColor = .oldRose
        lastNameLabel.textColor = .oldRose
        
        phoneTitleLabel.textColor = .oldRose
        phoneLabel.textColor = .rosyBrown
        
        emailTitleLabel.textColor = .oldRose
        emailLabel.textColor = .rosyBrown
        
        profilTitleLabel.textColor = .oldRose
        profilLabel.textColor = .rosyBrown
        
        isFamilinkUserLabel.textColor = .rosyBrown
        isEmergencyUserLabel.textColor = .rosyBrown
        
        messageButton.layer.cornerRadius = messageButton.frame.height/2
        messageButton.backgroundColor = .rosyBrown
        messageButton.setTitleColor(.seaShell, for: .normal)
        messageButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        messageButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        messageButton.layer.shadowOpacity = 1.0
        
        callButton.layer.cornerRadius = callButton.frame.height/2
        callButton.backgroundColor = .oldRose
        callButton.setTitleColor(.seaShell, for: .normal)
        callButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        callButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        callButton.layer.shadowOpacity = 1.0
        
        emailButton.layer.cornerRadius = emailButton.frame.height/2
        emailButton.backgroundColor = .rosyBrown
        emailButton.setTitleColor(.seaShell, for: .normal)
        emailButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        emailButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        emailButton.layer.shadowOpacity = 1.0
    }
}
