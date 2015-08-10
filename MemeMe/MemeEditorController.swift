//
//  ViewController.swift
//  MemeMe
//
//  Created by Asim Abdul on 8/5/15.
//  Copyright (c) 2015 AsimAbdul. All rights reserved.
//

import UIKit

class MemeEditorController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var bottomTextFieldConstraint: NSLayoutConstraint!
    
    var imagePicker: UIImagePickerController!
    var activityView: UIActivityViewController!
    
    let topTextFieldDelegate = MemeTextFieldDelegate()
    let bottomTextFieldDelegate = MemeTextFieldDelegate()
    
    override func viewWillAppear(animated: Bool) {
        prepareButtons()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        topTextFieldDelegate.memeLabel = topLabel
        topTextField.delegate = self.topTextFieldDelegate
        bottomTextFieldDelegate.memeLabel = bottomLabel
        bottomTextField.delegate = self.bottomTextFieldDelegate
        
        let topLabelGesture = UITapGestureRecognizer(target: self, action: Selector("topLabelTapped:"))
        let bottomLabelGesture = UITapGestureRecognizer(target: self, action: Selector("bottomLabelTapped:"))
        topLabel.addGestureRecognizer(topLabelGesture)
        bottomLabel.addGestureRecognizer(bottomLabelGesture)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if self.bottomTextField.isFirstResponder() {
            self.view.frame.origin.y -= 200
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.bottomTextField.isFirstResponder() {
            self.view.frame.origin.y += 200
        }
    }
    
    func isCameraAvailable() -> Bool {
        return UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil
    }
    
    func topLabelTapped(sender: UITapGestureRecognizer) {
        handleLabelTap(sender)
    }
    
    func bottomLabelTapped(sender: UITapGestureRecognizer) {
        handleLabelTap(sender)
    }
    
    func handleLabelTap(sender: UITapGestureRecognizer) {
        let currentLabel:UILabel = sender.view as! UILabel
        currentLabel.hidden = true
        let associatedTextField = self.view.viewWithTag(currentLabel.tag) as? UITextField
        associatedTextField?.becomeFirstResponder()
        associatedTextField?.hidden = false
    }
    

    func saveImageWithText() -> UIImage {
        let newView = UIView()
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, view.opaque, 0)
        view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: false)
        let newImage  = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    @IBAction func chooseFromAlbum(sender: UIBarButtonItem) {
        imagePicker.sourceType = .PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func takePhoto(sender: UIBarButtonItem) {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) == nil {
            noCamera()
        } else {
            imagePicker.sourceType = .Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func shareImage(sender: UIBarButtonItem) {

        if (imageView.image == nil) {
            displayAlert("No image chosen", message: "Please take a photo or choose an image from your library using the buttons below. A blank image cannot be shared as a meme.")
        } else {
            let savedImage:UIImage? = saveImageWithText()
            if (savedImage != nil) {
                activityView = UIActivityViewController(activityItems: [savedImage!], applicationActivities: nil)
                self.presentViewController(activityView, animated: true, completion: nil)
            }
        }
    }
    
    func noCamera() {
        cameraButton.enabled = false
        displayAlert("No camera available", message: "The camera could not be accessed. Please pick a photo from the album")
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        resetMemeFields()
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageView.contentMode = .ScaleAspectFill
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    func resetMemeFields() {
        topLabel.text = "TOP TEXT"
        bottomLabel.text = "BOTTOM TEXT"
        topTextField.text = ""
        bottomTextField.text = ""
    }
    
    func prepareButtons() {
        if isCameraAvailable() {
            cameraButton.image = UIImage(named: "camera_icon")?.imageWithRenderingMode(.AlwaysOriginal)
            cameraButton.enabled = true
        } else {
            cameraButton.enabled = false
            cameraButton.image = UIImage(named: "camera_disabled_icon")?.imageWithRenderingMode(.AlwaysOriginal)
        }
        
        albumButton.image = UIImage(named: "album_icon")?.imageWithRenderingMode(.AlwaysOriginal)
        shareButton.image = UIImage(named: "social_share")?.imageWithRenderingMode(.AlwaysOriginal)
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

}


//TODO: Dry up memelabels hiding
//TODO: Enlarge icons; 1x, 2x ,3x
