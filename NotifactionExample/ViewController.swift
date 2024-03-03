//
//  ViewController.swift
//  NotifactionExample
//
//  Created by Fatih Gümüş on 3.03.2024.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    var izinKontrol = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {
            granted,error in
            
            self.izinKontrol = granted // izin değerini true false olarak aktarmakta granted değeri
            
            if granted {
                print("İzin alma işlemi başarılı")
            }else{
                print("İzin alma işlemi başarısız")
            }
        })
    }

    @IBAction func notifactionButton(_ sender: Any) {
        if izinKontrol{
            let icerik = UNMutableNotificationContent()
            icerik.title = "Test Bildirim Başlığı"
            icerik.subtitle = "Alt Başlık"
            icerik.body = "Açıklama"
            icerik.badge = 1
            icerik.sound = UNNotificationSound.default
            
            let tetikleme =  UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
     
            // id değeri aynı olan bildirimler gruplandırılıyor(instagram yorum bildirimleri beğeni bildirimleri gibi düşün)
            let bildirimIstek = UNNotificationRequest(identifier: "begeni", content: icerik, trigger: tetikleme)
            
            UNUserNotificationCenter.current().add(bildirimIstek)
        }
    }
    
}

extension ViewController : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // banner değeri uygulama açıkken de bildirimin gösterilmesini sağlamaktadır.
        completionHandler([.banner,.sound,.badge])
    }
    
    //bildirime tıklandığında
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let app = UIApplication.shared
        
        center.setBadgeCount(0)
        
        print("Bildirim seçildi")
        
        if app.applicationState == .active{
            print("Ön Plan : Bildirim Seçildi")
        }else if app.applicationState == .inactive{
            print("Arka Plan : Bildirim Seçildi")
        }else{
            print("Hata")
        }
        
        completionHandler()
    }
}
