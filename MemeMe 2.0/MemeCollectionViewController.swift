//
//  MemeCollectionViewController.swift
//  MemeMe 2.0
//
//  Created by jalloh on 08/06/2016.
//  Copyright © 2016 CWJ. All rights reserved.
//

import UIKit

// global
private let reuseIdentifier = "Cell"

class MemeCollectionViewController: UICollectionViewController {
    

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        setItemDimension(self.view.frame.size)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeCollectionViewController.rotated), name: UIDeviceOrientationDidChangeNotification, object: nil)
    }

    override func viewWillAppear(animated: Bool) {
        collectionView!.reloadData()
    }
    
    
    // MARK: Specific Methods
    
    func setItemDimension(size: CGSize) {
        let space: CGFloat = 3.0
        var dimension: CGFloat
        var itemsPerRow: Int!
        
        if (size.height > size.width) {
            itemsPerRow = 3
        } else {
            itemsPerRow = 5
        }
        
        dimension = (size.width - (CGFloat(itemsPerRow - 1) * space)) / CGFloat(itemsPerRow)
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    func rotated(){
        setItemDimension(self.view.frame.size)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "addMeme") {
            let editorVC = segue.destinationViewController as! MemeEditorViewController
        }
    }
    
    
    //MARK: - UICollectionView Delegate
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        
        return appDelegate.memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        let meme = appDelegate.memes[indexPath.row]
        
        let labelAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
            NSStrokeWidthAttributeName : -5,
            ]

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        
        cell.memeImageView?.image = meme.memedImg
        let topText = NSAttributedString(string: "\(meme.topText.uppercaseString)", attributes: labelAttributes)
        let bottomText = NSAttributedString(string: "\(meme.bottomText.uppercaseString)", attributes: labelAttributes)
        
        cell.topText?.attributedText = topText
        cell.bottomText?.attributedText = bottomText

        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        let meme = appDelegate.memes[indexPath.row]
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = meme
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    @IBAction func addMeme(sender: UIBarButtonItem) {
        performSegueWithIdentifier("addMeme", sender: nil)
    }

}
