//
//  MemeEditorViewController.swift
//  MemeMe 2.0
//
//  Created by jalloh on 08/06/2016.
//  Copyright © 2016 CWJ. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var textTop: UITextField!
    @IBOutlet weak var textBottom: UITextField!
    @IBOutlet weak var barBottom: UIToolbar!
    @IBOutlet weak var barTop: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var isEditMode: Bool! = false
    var memeToBeEdited: Meme!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Display view preferences
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        imageView.layer.zPosition = -5;
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        let obj = UIApplication.sharedApplication().delegate
        let appDel = obj as! AppDelegate
        
        if appDel.memes.count == 0 {
            cancelButton.enabled = false
        } else {
            cancelButton.enabled = true
        }
        
        initTextField(textTop, initText: "TOP")
        initTextField(textBottom, initText: "BOTTOM")
        
        if isEditMode! {
            imageView.image = memeToBeEdited.originalImg
            textTop.text = memeToBeEdited.topText
            textBottom.text = memeToBeEdited.bottomText
        }
        
        if (imageView.image == nil) {
            shareButton.enabled = false
        } else {
            shareButton.enabled = true
        }
        
        subscribeToKeyboardNotifications()

    }
    
   
    
    
    //MARK: TextField Delegate
    func initTextField(textField: UITextField!, initText: String?) {
        textField.delegate = self
        
        if let text = initText {
            textField.text = text
        } else {
            print("No init string.")
        }
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -5,
            ]
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .Center
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if !isEditMode! {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    //MARK: User Actions
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        pickAnImage(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera (sender: AnyObject) {
        pickAnImage(UIImagePickerControllerSourceType.Camera)
    }
    
    
    // MARK: UIImagePickerController Delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func pickAnImage(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    // generateMemeImage Function
    func generateMemedImage() -> UIImage {
        
        barBottom.hidden = true
        barTop.hidden = true
        
     
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        barBottom.hidden = false
        barTop.hidden = false
        
        return memedImage
    }
    
    
    // store meme model
    func save(memedImage: UIImage) {
        let meme = Meme(topText: textTop.text!, bottomText: textBottom.text!, originalImg: imageView.image, memedImg: memedImage)
        
        let obj = UIApplication.sharedApplication().delegate
        let appDel = obj as! AppDelegate
        appDel.memes.append(meme)
    }
    
    
    // shareButton functions
    @IBAction func shareButtonClicked(sender: AnyObject) {
        let memedImage = generateMemedImage()
        
        let shareViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        presentViewController(shareViewController, animated: true, completion: nil)
        shareViewController.completionWithItemsHandler = { (activityType: String?, completed: Bool, returnedItems: [AnyObject]?, activityError: NSError?) in
            if completed {
                self.save(memedImage)
                shareViewController.dismissViewControllerAnimated(true, completion: nil)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    @IBAction func exitEditor(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    // MARK: Keyboard handlers
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if textBottom.isFirstResponder() {
            view.frame.origin.y =  getKeyboardHeight(notification) * -1
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if textBottom.isFirstResponder() {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }

    
    
}
