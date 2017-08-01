//
//  ViewController.swift
//  iroiro
//
//  Created by EZoneLai Lai on 2017/7/29.
//  Copyright © 2017年 EZoneLai Lai. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, URLSessionTaskDelegate, URLSessionDataDelegate, URLSessionDelegate{
    
    var imagePicker:UIImagePickerController!
    
    @IBOutlet weak var picture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //選取照片按鈕
    @IBAction func take(_ sender: Any) {
        // 建立一個ImagePickerController
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        // 編輯啟用
        imagePicker.allowsEditing = true
        imagePicker.isEditing = true
        imagePicker.setEditing(true, animated: true)
        // 設定影像來源 這裡設定photoLibrary
        imagePicker.sourceType = .photoLibrary
        //imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    //上傳照片按鈕2
    @IBAction func uload2(_ sender: Any) {
        // 通信のリクエスト生成.
        let myCofig: URLSessionConfiguration = URLSessionConfiguration.default
        let url:NSURL = NSURL(string: "http://127.0.0.1/upload/upload2.php")!
        var request: URLRequest = URLRequest(url: url as URL)
        request.httpMethod = "POST"
        let session:URLSession = URLSession(configuration: myCofig, delegate: self, delegateQueue: OperationQueue.main)
        // リサイズ後のUIImageを用意.
        //let image:UIImage! = self.CameraView.image?.ResizeÜIImage(width: resizeWidth, height: resizeHeight)
        let image:UIImage! = self.picture.image
        // 画像データを読み出し、Data型に変換する.
        let file: NSData = UIImagePNGRepresentation(image)! as NSData
        // アップロード用のタスクを生成.
        let task:URLSessionUploadTask = session.uploadTask(with: request, from: file as Data)
        
        task.resume()
        
        
    }
    
    
    //上傳照片按鈕1
    @IBAction func uload(_ sender: Any) {
        /////準備伺服器程式位置
        let urlString = "http://127.0.0.1/upload/upload_pic.php"
        /////宣告建立一個NSMutableURLRequest變數
        /////在此使用NSMutableURLRequest而非NSURLRequest(因為後面可能會修改這個request)
        let request = NSMutableURLRequest()
        /////NSMutableURLRequest建構子參數是一個NSURL物件(在此又直接以NSURL的一個需要字串的建構子完成)
        request.url = URL(string: urlString)!
        ////設定這個請求的HTTPMethod屬性為POST(上傳資料一定要POST)
        request.httpMethod = "POST"
        /////////宣告一個NSMutableData變數並以NSMutableData的類別函數alloc()製造出NSMutableData物件
        /////////NSMutableData是一種"二進位"(就是byte啦)的資料形態處理物件，他是NSData的可改變型
        /////////因為再通知完伺服器控制資料後，接著就要上傳資料了，所以在此準備一個NSMutableData物件來處理
        /////////用NSMutableData不用NSData的理由是因為我是一點一點把上傳資料排進去
        let body = NSMutableData()
        //////宣告建立一個字串(隨便寫一個，但你必須確定這個字串不會與我們與伺服器溝通的訊息，和上傳資料的
        //////任一個部分相同 ！！！！！！！！！！！！！！！
        //////因為這個字串是後面用來區隔控制訊息與上傳資料用的，要是與訊息或上傳資料的內容有相同
        //////就會造成對方伺服器搞不清楚哪些是控制資料，哪些是上傳資料!!!
        let boundary = "---------------------------14737809831466499882746641449"
        //////宣告建立一個字串，這個字串是特別以請求(NSURLRequest)的格式寫出要傳達給伺服器的控制資訊的字串
        let contentType = NSString(format: "multipart/form-data; boundary=%@", boundary)
        //////呼叫NSMutableURLRequest的addValue函數，增加通知伺服器的資訊
        //////第一個參數是資訊，第二個參數是資訊的種類
        //////注意!!!其實可以用addValue增加很多通知伺服器的資訊，但在此我們只做上傳一定要做的
        request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
        /////以全域函數UIImagePNGRepresentation處理目前圖筐裡的圖成為byte堆(因為在網路上傳東西必須一個一個byte)
        let imageData = UIImageJPEGRepresentation(self.picture.image!, 100)
        ////////以appendData加上控制資料
        ////////此資料必須是:  "\r\n--這裡要放你先前通知伺服器的分隔字串\r\n"
        body.append(NSString(format: "--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
        ////////再以appendData加上控制資料
        ////////此資料必須是:  "Content-Disposition: form-data; name=\"profile_img\"; filename=\"img.jpg\"\\r\n"
        ////////這裡注意一下!!! name= 後面所寫的的字串，會是伺服器端接收處理程式用來處理上傳資料的變數代號!!!
        ////////filename= 後面所寫的的字串，會是伺服器端接收處理程式用來處理上傳圖片的欓名!!!
        body.append(NSString(format:"Content-Disposition: attachment; name=\"fileToUpload\"; filename=\"%@.jpg\"\r\n", "test").data(using: String.Encoding.utf8.rawValue)!)
        ///////告訴伺服器以application/octet-streamt串流方式上傳
        body.append(NSString(format:"Content-Type: application/octet-stream\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
        //////把已經化為byte的圖片排上去
        body.append(imageData!)
        //////加上界限，告訴伺服器圖片部分上傳完了
        body.append(NSString(format: "\r\n--%@--\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
        //////把一整個要上傳的byte堆指定給請求的HTTPBody屬性
        request.httpBody = body as Data
        
        let session:URLSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue())
        
        let task = session.dataTask(with: request as URLRequest)
        
        task.resume()
        
    }
    
    
    //MARK:-  URLSessionTask 函數
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        print(totalBytesExpectedToSend)
    }
    //MARK:-  URLSession 函數
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print(error ?? "error")
    }
    
    //MARK:-  URLSessionDataTask 函數
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print(String(data: data, encoding: .utf8) ?? "error")
    }
    
    // 判斷相機不可用函數
    func noCameraAlert() {
        let alertController = UIAlertController(title: "錯誤！", message: "沒有可用的相機", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "確定", style: .default, handler: nil)
        alertController.addAction(okayAction)
        present(alertController, animated: true, completion: nil)
    }
    //取得照片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 把照片傳給原本的imageView，設定比例
        //picker.showsCameraControls = true
        picture.image = info[UIImagePickerControllerEditedImage] as? UIImage
        // 關閉相機
        picker.dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // 關閉相機
        picker.dismiss(animated: true, completion: nil)
    }

}

