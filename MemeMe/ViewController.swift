//
//  ViewController.swift
//  MemeMe
//
//  Created by Asim Abdul on 8/5/15.
//  Copyright (c) 2015 AsimAbdul. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

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
        stylizeButtons()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
//        enableCameraButton(isCameraAvailable())
        
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
    
    func enableCameraButton(allow: Bool) {
        if allow {
            self.cameraButton.enabled = true
        } else {
            self.cameraButton.image = nil
            self.cameraButton.enabled = false
            self.cameraButton.tintColor = UIColor.lightGrayColor()
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
        UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil)
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
        let savedImage:UIImage? = saveImageWithText()
        if (savedImage != nil) {
            activityView = UIActivityViewController(activityItems: [savedImage!], applicationActivities: nil)
            self.presentViewController(activityView, animated: true, completion: nil)
        }
    }
    
    func noCamera() {
        cameraButton.enabled = false
        let alertController = UIAlertController(title: "No camera available", message: "The camera could not be accessed. Please pick a photo from the album", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        stylizeMemeLabels()
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageView.contentMode = .ScaleAspectFill
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    func stylizeMemeLabels() {
        var memeLabels = [topLabel, bottomLabel]
        for label in memeLabels {
            label.hidden = false
        }
    }
    
    
    func stylizeButtons() {
        cameraButton.image = UIImage(named: "camera_icon")?.imageWithRenderingMode(.AlwaysOriginal)
        albumButton.image = UIImage(named: "album_icon")?.imageWithRenderingMode(.AlwaysOriginal)
        shareButton.image = UIImage(named: "social_share")?.imageWithRenderingMode(.AlwaysOriginal)
    }


}


//TODO: Dry up memelabels hiding
//TODO: Disable camera button in simulator
