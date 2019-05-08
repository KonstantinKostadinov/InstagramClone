//
//  ViewController.swift
//  InstagramClone
//
//  Created by username on 7.05.19.
//  Copyright © 2019 Konstantin Kostadinov. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    var ref =  Database.database().reference()
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "plus_photo.png"),for: .normal)
        //button.backgroundColor = .red
        return button
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "email"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "username"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let signUpButton:UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = false
        button.setTitle("Sign up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleTextInputMessage), for: .editingChanged)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    @objc
    func handleSignUp(){
        guard let email = emailTextField.text, email.count > 0 else {return }
        guard let username = usernameTextField.text, username.count > 0 else {return}
        guard let password = passwordTextField.text, password.count > 0 else {return}
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error{
                print("Failed to created User \(error)")
            }
            guard let uid = user?.user.uid else { return }
            let values = [uid: 1]
            print("Successfuly created user: " , user?.user.uid ?? " ")
            self.ref.child("users").setValue(values, withCompletionBlock: { (err, ref) in
                if let err = err{
                    print("Failed to save user info in db: ",err)
                    return
                }
                print("Successfully saved info in db")
            })
        }
    }
    
    @objc
    func handleTextInputMessage(){
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && usernameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        if isFormValid{
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        }
        else{
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(plusPhotoButton)
        plusPhotoButton.heightAnchor.constraint(equalToConstant: 140).isActive = true
        plusPhotoButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusPhotoButton.topAnchor.constraint(equalTo: view.topAnchor,constant: 40).isActive = true
        
        setupInputFields()
        
//        view.addSubview(emailTextField)
//        NSLayoutConstraint.activate([
//            emailTextField.topAnchor.constraint(equalTo: plusPhotoButton.bottomAnchor, constant: 20),
//            emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
//            emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
//            emailTextField.heightAnchor.constraint(equalToConstant: 50)
//            ])
        
        
    }
    
    fileprivate func setupInputFields(){
        
        
        let redView = UIView()
        redView.backgroundColor = .red
        let stackView = UIStackView(arrangedSubviews: [emailTextField,usernameTextField,passwordTextField,signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10

        view.addSubview(stackView)
        
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40,width: 0,height: 200)
    }
}


extension UIView{
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor? , paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat){
        
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top{
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left{
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let bottom = bottom{
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        if let right = right{
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0{
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0{
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
