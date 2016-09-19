//
//  MemeDetailViewController.swift
//  MemeMe 2.0
//
//  Created by jalloh on 08/06/2016.
//  Copyright © 2016 CWJ. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    // ins variables
    var meme: Meme! = nil
    var editButton: UIBarButtonItem!
    var didEdit: Bool!
    
    // outlet
    @IBOutlet weak var memeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MemeDetailViewController.editMeme))
        self.navigationItem.rightBarButtonItem = editButton
        didEdit = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        memeImageView.image = meme.memedImg
        
        if didEdit! {
            didEdit = false
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
    // edit meme functions
    func editMeme() {

        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let editorVC = mainStoryboard.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        
        editorVC.memeToBeEdited = meme
        editorVC.isEditMode = true
        
        navigationController?.presentViewController(editorVC, animated: true, completion:nil)
        
        didEdit = true
    }
    
}
