//
//  AlbumViewController.swift
//  Swift5Bokete1
//
//  Created by Yuki on 2022/03/15.
//

import UIKit
import Photos


class AlbumViewController: UIViewController ,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var commentString: UITextView!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func selectAlbum(_ sender: Any) {
        
        //UIImagePickerController.SourceTypeという型
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        //メソッドcreateImagePickerが呼ばれるx
        createImagePicker(sourceType: sourceType)
        
        
    }
    
    
    func createImagePicker(sourseType:UIImagePickerController.SourceType){
        
        
        
        //インスタンスを作成
        let cameraPicker = UIImagePickerController()
        
        cameraPicker.sourceType = sourseType
        
        //cameraPickerに使えるデリゲートメソッドをViewControllerでも使えるようにする
        //他のクラスから自分のクラスへ委任を受ける
        cameraPicker.delegate = self
        
        cameraPicker.allowsEditing = true
        
        self.present(cameraPicker, animated: true, completion: nil)
        
        
        
    }
    
    
    
    @IBAction func next(_ sender: Any) {
        
        performSegue(withIdentifier: "next", sender: nil)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let shareVC = segue.destination as! ShareViewController
        
        shareVC.commentString = commentString.text
        
        shareVC.resultImage = imageView.image!
        
    }
    
}
    
