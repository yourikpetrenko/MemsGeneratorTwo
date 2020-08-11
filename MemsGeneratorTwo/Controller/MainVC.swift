//
//  ViewController.swift
//  MemsGeneratorTwo
//
//  Created by Jura on 23.07.2020.
//  Copyright © 2020 Jura. All rights reserved.
//

import UIKit
import Alamofire

class MainVC: UIViewController {
    
    private var arrayFont = [String]()
    private var selectedFont: String?
    private var imageData: UIImage?
    private var urlTop: String?
    private var urlBottom: String?
    private var urlFont: String?
    private var currentMem = ""
    
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var textFieldTopOutlet: UITextField!
    @IBOutlet weak var textFieldBottomOutlet: UITextField!
    @IBOutlet weak var textFieldFontOutlet: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingFonts()
        textFieldTopOutlet.delegate = self
        textFieldBottomOutlet.delegate = self
        createPickerView()
        createToolBar()
        registerForKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        downloadTheSelectedMeme()
    }
    
    // MARK: - Botton to open the list of memes
    
    @IBAction func buttonLeadingToTheList(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "listMemsSegue", sender: self)
    }
    
    // MARK: - Generatting meme

    @IBAction func memeGeneratingButton(_ sender: UIButton) {
        generatingMame()
    }
    
    // MARK: - Button for cleaning screen

    @IBAction func clearingButtom(_ sender: UIBarButtonItem) {
        self.imageOutlet.image = UIImage(imageLiteralResourceName: "jdun")
        self.activityIndicator.isHidden = true
        self.textFieldTopOutlet.text = nil
        self.textFieldBottomOutlet.text = nil
        self.textFieldFontOutlet.text = nil
    }
    
    // MARK: - Share a meme.

    @IBAction func toShareButtom(_ sender: UIBarButtonItem) {
        presentActivityViewController()
    }
}

extension MainVC: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, CurrentMemeDelegate {
   
    // MARK: - Setting UIPickerView

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayFont.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayFont[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedFont = arrayFont[row]
        textFieldFontOutlet.text = selectedFont
    }
    
    // MARK: - Creating a UIPickerView for the font list.

    func createPickerView() {
        let elementPicker = UIPickerView()
        elementPicker.delegate = self
        textFieldFontOutlet.inputView = elementPicker
        elementPicker.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
    }
    
    // MARK: - Creating a toolbar for the UIPickerView, button implementation "Done".

    func createToolBar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneItem = UIBarButtonItem(title: "Готово",
                                       style: .plain,
                                       target: self,
                                       action: #selector(dismissKeyboard))
        toolbar.setItems([doneItem], animated: true)
        toolbar.isUserInteractionEnabled = true
        textFieldFontOutlet.inputAccessoryView = toolbar
    }
    
    // MARK: - Dissmiss keyboard. By clicking on "Done", in toolbar
    
    @objc func dismissKeyboard() {
        urlFont = textFieldFontOutlet.text ?? ""
        view.endEditing(true)
    }
    
    // MARK: - Networking Service. Load fonts list.
    
    func loadingFonts() {
        let urlFonts = "https://ronreiter-meme-generator.p.rapidapi.com/fonts"
        ListNetworkService.getList(url: urlFonts) { (arrayFont) in
            self.arrayFont = arrayFont.array
        }
    }
    
    // MARK: - Networking Service. Load selected image.

    func downloadTheSelectedMeme() {
        let urlImage = "https://ronreiter-meme-generator.p.rapidapi.com/meme?meme=\(currentMem)&top=%20&bottom=%20"
        if imageOutlet.image == nil {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }
        ImageNetworkService.getList(url: urlImage) { (image) in
            DispatchQueue.main.async {
                self.imageOutlet.image = UIImage(data: image.imageData)
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                if self.imageOutlet.image == nil {
                    self.imageOutlet.image = UIImage(imageLiteralResourceName: "jdun")
                }
            }
        }
    }
    
    // MARK: - Network Service. Generate memos.

    func generatingMame() {
        convertingTextForUrl()
        let urlDoneMem = "https://ronreiter-meme-generator.p.rapidapi.com/meme?font=\(urlFont ?? "")&font_size=50&meme=\(currentMem)&top=\(urlTop ?? "")&bottom=\(urlBottom ?? "")"
        ImageNetworkService.getList(url: urlDoneMem) { (image) in
            DispatchQueue.main.async {
                self.imageOutlet.image = UIImage(data: image.imageData)
            }
        }
    }
    
    // MARK: - Adaptation of the text for the url address.

    func convertingTextForUrl() {
        urlTop = textFieldTopOutlet.text?.components(separatedBy: " ").filter { !$0.isEmpty }.joined(separator: "%20")
        urlBottom = textFieldBottomOutlet.text?.components(separatedBy: " ").filter { !$0.isEmpty }.joined(separator: "%20")
        urlFont = textFieldFontOutlet.text?.components(separatedBy: " ").filter { !$0.isEmpty }.joined(separator: "%20")
    }
    
    // MARK: - Implementation of functionality for the ability to share.

    func presentActivityViewController() {
        guard let image = imageOutlet.image else { return }
        let items: [Any] = [image]
        let avc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(avc, animated: true, completion: nil)
    }
    
    // MARK: - Passing information about the current meme.
    
    func transmittingIdMeme(id: String) {
        currentMem = id
    }
    
    // MARK: - Data transfer between ViewControllers.

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listMemsSegue" {
            let destanationListMems = segue.destination as! ListMems
            destanationListMems.delegate = self
        }
    }
    
    // MARK: - Dissmiss keyboard. By clicking on "Return"

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // MARK: - Raising the context above the keyboard.
     
     func registerForKeyboardNotifications() {
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                                name: UIResponder.keyboardWillShowNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                                name: UIResponder.keyboardWillHideNotification, object: nil)
     }
     
    func remoteKeyboardNotifications() {
         NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
         NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
     }
     
     @objc func keyboardWillShow(notification: NSNotification) {
         if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
             if self.view.frame.origin.y == 0 {
                 self.view.frame.origin.y -= keyboardSize.height
             }
         }
     }

     @objc func keyboardWillHide(notification: NSNotification) {
         if self.view.frame.origin.y != 0 {
             self.view.frame.origin.y = 0
         }
     }

}
