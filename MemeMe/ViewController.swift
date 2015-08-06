//
//  ViewController.swift
//  MemeMe
//
//  Created by Asim Abdul on 8/5/15.
//  Copyright (c) 2015 AsimAbdul. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    var imagePicker: UIImagePickerController!
    
    override func viewWillAppear(animated: Bool) {
        stylizeButtons()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topLabel.hidden = true
        bottomLabel.hidden = true

        // Do any additional setup after loading the view, typically from a nib.
    }

    
    @IBAction func takePhoto(sender: UIBarButtonItem) {
        imagePicker = UIImagePickerController()
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) == nil {
            noCamera()
        } else {
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func noCamera() {
        let alertController = UIAlertController(title: "No camera available", message: "The camera could not be accessed. Please pick a photo from the album", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        stylizeMemeLabels()
        
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageView.contentMode = .ScaleAspectFit
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    func stylizeMemeLabels() {
        topLabel.text = "Enter top text, so that somethingfits properly in this ios project"
        bottomLabel.text = "Enter bottom text, so that somethingfits properly in this ios"
        var memeLabels = [topLabel, bottomLabel]
        for label in memeLabels {
            label.numberOfLines = 0
            label.sizeToFit()
            label.hidden = false
        }
    }
    
    func stylizeButtons() {
        cameraButton.image = UIImage(named: "camera_icon")?.imageWithRenderingMode(.AlwaysOriginal)
        albumButton.image = UIImage(named: "album_icon")?.imageWithRenderingMode(.AlwaysOriginal)
    }


}

