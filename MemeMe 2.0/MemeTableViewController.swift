//
//  MemeTableViewController.swift
//  MemeMe 2.0
//
//  Created by jalloh on 08/06/2016.
//  Copyright © 2016 CWJ. All rights reserved.
//  complete

import UIKit

class MemeTableViewController: UITableViewController {
    
  override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView!.reloadData()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if (segue.identifier == "addMeme") {
            let editorVC = segue.destinationViewController as! MemeEditorViewController
        }
    }
    
    
    // add meme function
    @IBAction func addMeme(sender: UIBarButtonItem) {
        performSegueWithIdentifier("addMeme", sender: nil)
    }
 
    // colllectionView DataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let object = UIApplication.sharedApplication().delegate
        let appDel = object as! AppDelegate
        return appDel.memes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let obj = UIApplication.sharedApplication().delegate
        let appDel = obj as! AppDelegate
        let meme = appDel.memes[indexPath.row]

        let labelAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
            NSStrokeWidthAttributeName : -5,
            ]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell", forIndexPath: indexPath) as! MemeTableViewCell
        cell.memeText?.text = (meme.topText + "..." + meme.bottomText).uppercaseString
        cell.memeImageView?.image = meme.memedImg
        
        let topText = NSAttributedString(string: "\(meme.topText.uppercaseString)", attributes: labelAttributes)
        let bottomText = NSAttributedString(string: "\(meme.bottomText.uppercaseString)", attributes: labelAttributes)

        cell.topText?.attributedText = topText
        cell.bottomText?.attributedText = bottomText

        return cell
    }
    
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let obj = UIApplication.sharedApplication().delegate
        let appDel = obj as! AppDelegate
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            tableView.beginUpdates()
            appDel.memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            tableView.endUpdates()
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let obj = UIApplication.sharedApplication().delegate
        let appDel = obj as! AppDelegate
        let meme = appDel.memes[indexPath.row]
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = meme
        
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}
