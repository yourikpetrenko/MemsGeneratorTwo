//
//  ViewController.swift
//  MemsGeneratorTwo
//
//  Created by Jura on 23.07.2020.
//  Copyright © 2020 Jura. All rights reserved.
//

import UIKit
import Alamofire

final class MainVC: UIViewController {
    
    var imageNetworkService: ImageNetworkServiceProtocol = ImageNetworkService()
    var listNetworkService: ListNetworkServiceProtocol = ListNetworkService()
    private var arrayFont = [String]()
    private var selectedFont: String?
    private var imageData: UIImage?
    private var urlTop: String?
    private var urlBottom: String?
    private var urlFont: String?
    private var currentMem = "" {
        didSet {
            setupImage()
        }
    }
    
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var textFieldTopOutlet: UITextField!
    @IBOutlet weak var textFieldBottomOutlet: UITextField!
    @IBOutlet weak var textFieldFontOutlet: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingDefaultImage()
        fontLoad()
        textFieldTopOutlet.delegate = self
        textFieldBottomOutlet.delegate = self
        createToolBar()
    }
    
    @IBAction func goToTheListOfMemes(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "listMemsSegue", sender: self)
    }
    
    @IBAction func sendAction(_ sender: UIButton) {
        generateImage()
    }
    
    @IBAction func cleaningButtom(_ sender: UIBarButtonItem) {
        self.imageOutlet.image = UIImage(imageLiteralResourceName: "jdun")
        self.activityIndicator.isHidden = true
        self.textFieldTopOutlet.text = nil
        self.textFieldBottomOutlet.text = nil
        self.textFieldFontOutlet.text = nil
    }
    
    @IBAction func toShare(_ sender: UIBarButtonItem) {
        settingActivityViewController()
    }
}

extension MainVC: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, CurrentMemeDelegate {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
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
    
    @objc func dismissKeyboard() {
        urlFont = textFieldFontOutlet.text ?? ""
        view.endEditing(true)
    }
    
    func fontLoad() {
        let elementPicker = UIPickerView()
        elementPicker.delegate = self
        textFieldFontOutlet.inputView = elementPicker
        elementPicker.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        
        let urlFonts = "https://ronreiter-meme-generator.p.rapidapi.com/fonts"
        listNetworkService.getList(url: urlFonts) { (arrayFont) in
            self.arrayFont = arrayFont.array
        }
    }
    
    func setupImage() {
        let urlImage = "https://ronreiter-meme-generator.p.rapidapi.com/meme?meme=\(currentMem)&top=%20&bottom=%20"
        if imageOutlet.image == nil {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }
        imageNetworkService.getImage(url: urlImage) { (image) in
            DispatchQueue.main.async {
                self.imageOutlet.image = UIImage(data: image.imageData)
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func generateImage() {
        editText()
        let urlDoneMem = "https://ronreiter-meme-generator.p.rapidapi.com/meme?font=\(urlFont ?? "")&font_size=50&meme=\(currentMem)&top=\(urlTop ?? "")&bottom=\(urlBottom ?? "")"
        imageNetworkService.getImage(url: urlDoneMem) { (image) in
            DispatchQueue.main.async {
                self.imageOutlet.image = UIImage(data: image.imageData)
            }
        }
    }
    
    func editText() {
        urlTop = textFieldTopOutlet.text?.components(separatedBy: " ").filter { !$0.isEmpty }.joined(separator: "%20")
        urlBottom = textFieldBottomOutlet.text?.components(separatedBy: " ").filter { !$0.isEmpty }.joined(separator: "%20")
        urlFont = textFieldFontOutlet.text?.components(separatedBy: " ").filter { !$0.isEmpty }.joined(separator: "%20")
    }
    
    func settingActivityViewController() {
        guard let image = imageOutlet.image else { return }
        let items: [Any] = [image]
        let avc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(avc, animated: true, completion: nil)
    }
    
    func transmittingIdMeme(id: String) {
        currentMem = id
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if case let listMemsVC as ListMemsVC = segue.destination {
        listMemsVC.completion = { [weak self] mem in
            self?.currentMem = mem
        }
    }
}
    
    func settingDefaultImage() {
        if self.imageOutlet.image == nil {
            self.imageOutlet.image = UIImage(imageLiteralResourceName: "jdun")
        }
    }
}
