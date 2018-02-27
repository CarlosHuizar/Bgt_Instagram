//
//  PhotoMapViewController.swift
//  Instagram2
//
//  Created by Carlos Huizar-Valenzuela on 2/26/18.
//  Copyright © 2018 Carlos Huizar-Valenzuela. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class PhotoMapViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var uploadImageView: UIImageView!
    let vc = UIImagePickerController()
    var imageUpload: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captionTextField.placeholder = "Enter Your Cpation"
        vc.delegate = self
        vc.allowsEditing = true
        
        //vc.sourceType = UIImagePickerControllerSourceType.camera
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        
        
        self.present(vc, animated: true, completion: nil)

        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = resize(image: originalImage, newSize: CGSize(width: 300, height: 300))
        imageUpload = editedImage
        // Do something with the images (based on your use case)
        uploadImageView.image = editedImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(0, 0, newSize.width, newSize.height))

        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBack(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let PhotoMapViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        self.present(PhotoMapViewController, animated: true, completion: nil)
    }
    @IBAction func onShare(_ sender: Any) {
       Post.postUserImage(image: uploadImageView.image, withCaption: captionTextField.text){
            (success, error) in
    NotificationCenter.default.post(name: NSNotification.Name("didShare"), object: nil)
    }
}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
}
extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
