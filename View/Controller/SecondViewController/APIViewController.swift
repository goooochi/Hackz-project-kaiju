//
//  APIViewController.swift
//  Swift5Bokete1
//
//  Created by Yuki on 2022/03/15.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import Photos

class APIViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate {
    
    
        @IBOutlet weak var odaiImageView: UIImageView!
        
        @IBOutlet weak var commentTextView: UITextView!
        
        @IBOutlet weak var searchTextField: UITextField!
        
        let maxLength: Int = 5
        
        var count = 0
        


    override func viewDidLoad() {
        super.viewDidLoad()

        commentTextView.layer.cornerRadius = 20.0
                
                PHPhotoLibrary.requestAuthorization{(status) in
                    
                    switch(status){
                        
                    case .authorized:break
                    case .notDetermined:break
                    case .restricted:break
                    case .denied:break
                    case .limited:break
                    @unknown default: break
                        
                    }
                    
                    
                }
                
                //UITextFieldDelegateというのは、UITextFieldが持っているDelegateメソッドを呼べる。Delegateメソッドは、Appleがはじめから書いているもの。
                //selfはviewControllerのこと
                //delegateメソッドを反映したい場所はどこですか
                //こたえはviewControllerクラスのsearchTextField
                searchTextField.delegate = self
                
                
                getImages(keyword: "funny")
                
                
                commentTextView.delegate = self
                

    }
    

    
    //キーボード以外を押したら
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchTextField.resignFirstResponder()
    }
    
    
    
    //検索キーワードの値をもとに、画像を引っ張ってくる
    //今回は、pixabay.comから引っ張る
    func getImages(keyword:String){
        
        //APIKey 26076447-1599e5cccca12d589653881ee
        
        let url = "https://pixabay.com/api/?key=26076447-1599e5cccca12d589653881ee&q=\(keyword)"
        
        //Alamofireを使って、URLが検索される(通信される)
        //parametersは、すでに\(keyword)をつけているので、nilで大丈夫
        AF.request(url, method: .get,parameters: nil, encoding: JSONEncoding.default).responseJSON{ (response) in
            
            switch response.result{
                
                //値が入っていたとき(レスポンスが正常に行われたとき)
            case .success:
                //データを取得
                let json:JSON = JSON(response.data as Any)
                
                //hitsの中に入っている配列にアクセスする
                //hits[ {0番目}, {1番目}, {2番目}, ･･･････････････ ,{ヒット数の上限番目}]
                //次のお題ボタンを押したら、countをインクリメントしなければいけない
                //webformatURLにかかれているURLをString型で取る
                var imageString = json["hits"][self.count]["webformatURL"].string
                
                
                //もし、検索して得られた配列の要素数が少なかった場合、out of rangeのエラーが出てしまう
                //条件分岐で、countに条件をつける
                if imageString == nil{
                    
                    imageString = json["hits"][0]["webformatURL"].string
                    self.odaiImageView.sd_setImage(with: URL(string: imageString!),completed: nil)
                    
                }else{
                    
                    //String型のURLを、URL型にキャストして、odaiImageViewに反映させる
                    self.odaiImageView.sd_setImage(with: URL(string: imageString!),completed: nil)
                    
                }
                
                
                //値が入っていなかったとき(レスポンスが正常に行われなかったとき)
            case .failure(let error):
                
                
                print("error")
                
                
            }
            
            
            
        }
        
        //値がJSON形式で返ってきて、それをJSON解析を行う
        //imageVireのimageに貼り付ける
        
        
        
        
    }
    
    
    @IBAction func nextOdai(_ sender: Any) {
        
        count = count + 1
        if searchTextField.text == ""{
            
            getImages(keyword: "funny")
        }else{
            
            
            getImages(keyword: searchTextField.text!)
            
        }
    }
    
    
    //検索窓に入っているキーワードで検索する
    @IBAction func searchAction(_ sender: Any) {
        
        count = 0
        
        if searchTextField.text == ""{
            
            getImages(keyword: "funny")
        }else{
            
            getImages(keyword: searchTextField.text!)
            
        }
    }
    
    //アルバムから選択を押す
    @IBAction func selectAlbum(_ sender: Any) {
        
        //UIImagePickerController.SourceTypeという型
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        //メソッドcreateImagePickerが呼ばれるx
        createImagePicker(sourceType: sourceType)
        
        
        
    }
    
    
    //カメラを選択
    @IBAction func camera(_ sender: Any) {
        
        //UIImagePickerController.SourceTypeという型
        let sourceType:UIImagePickerController.SourceType = .camera
        //メソッドcreateImagePickerが呼ばれる
        createImagePicker(sourseType: sourceType)
        
        
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return commentTextView.text.count + (text.count - range.length) <= 55
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
    
    
    
    
    func createImagePicker(sourceType:UIImagePickerController.SourceType)
    {
        //インスタンスを作成
        
        let cameraPicker = UIImagePickerController()
        cameraPicker.sourceType = sourceType
        cameraPicker.delegate = self
        cameraPicker.allowsEditing = true
        self.present(cameraPicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //選択された五臓のイメージがinfo[.editedImage] as? UIImageとなる
        if let pickerImage = info[.editedImage] as? UIImage{
            
            odaiImageView.image = pickerImage
            
            //閉じる処理
            picker.dismiss(animated: true, completion: nil)
            
            
        }
    }
    
    
    @IBAction func next(_ sender: Any) {
        
        performSegue(withIdentifier: "next", sender: nil)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let shareVC = segue.destination as! ShareViewController
        
        shareVC.commentString = commentTextView.text
        
        shareVC.resultImage = odaiImageView.image!
        
    }
    
}

