//
//  ViewController.swift
//  PhotoShow
//
//  Created by maya on 2022/12/04.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let saveData: UserDefaults = UserDefaults.standard
    
    @IBOutlet var imageView: UIImageView!
    
    var imageName: URL!
    // ドキュメントディレクトリの「ファイルURL」（URL型）定義
    var documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    // ドキュメントディレクトリの「パス」（String型）定義
    let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if saveData.string(forKey: "PHOTO") != nil {
            
            imageName = saveData.url(forKey: "PHOTO")!
            print(imageName!)
            // パス型に変換
            let filePath = imageName?.path
            imageView.image = UIImage(contentsOfFile: filePath!)
        } else {
            imageView.image = UIImage(named: "noimage.png")
        }
        
    }
    
    //カメラロールにある画像を読み込む時のメソッド
    @IBAction func openAlbum() {
        //カメラロールが使えるかの確認
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            //カメラロールの画像を選択して画像を表示させるまでの一連の流れ
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            
            picker.allowsEditing = true
            
            present(picker, animated: true, completion: nil)
        }
    }
    
    //カメラ、カメラロールを使った時に選択した画像をアプリ内に表示させるためのメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.editedImage] as? UIImage
        
        dismiss(animated: true, completion: nil)
        save()
    }
    
    //保存するためのパスを作成する
    func createLocalDataFile() {
        // 作成するテキストファイルの名前
        let fileName = "\(NSUUID().uuidString).png"
        
        // DocumentディレクトリのfileURLを取得
        if documentDirectoryFileURL != nil {
            // ディレクトリのパスにファイル名をつなげてファイルのフルパスを作る
            let path = documentDirectoryFileURL.appendingPathComponent(fileName)
            documentDirectoryFileURL = path
        }
    }
    //画像を保存する関数の部分
      func saveImage() {
          createLocalDataFile()
          if imageView.image != nil{
              //pngで保存する場合
              let pngImageData = imageView.image?.pngData()
              do {
                print("save")
                  try pngImageData!.write(to: documentDirectoryFileURL)
              } catch {
                  //エラー処理
                  print("エラー")
              }
          }
      }
     
      
    func save() {
        saveImage()
        
        if imageView.image != nil {
            saveData.set(documentDirectoryFileURL, forKey: "PHOTO")
        }
        
        let alert: UIAlertController = UIAlertController(title: "完了", message: "保存しました",preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default,handler: {(action) -> Void in
            UIView.animate(withDuration: 1, delay: 0) {
                self.imageView.center.y += 100
            }
        }))
        
        present(alert, animated: true, completion: nil)
        

        
    }
    
    


}

