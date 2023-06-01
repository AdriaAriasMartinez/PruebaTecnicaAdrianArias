//
//  WebPageViewController.swift
//  PruebaTecnica
//
//  Created by AdrianArias on 01/06/23.
//

import UIKit
import WebKit
import Network

@available(iOS 13.0, *)
class WebPageViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    @IBOutlet weak var pageView: WKWebView!
    @IBOutlet weak var Activity: UIActivityIndicatorView!
    
    var networCheck = NetworkCheck.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if networCheck.currentStatus == .satisfied{
            self.title = bankName
            pageView.uiDelegate = self
            pageView.allowsBackForwardNavigationGestures = true
            pageView.allowsLinkPreview = true
            pageView.navigationDelegate = self
            
            self.loadData()
        }else{
            
            let alert = UIAlertController(title: "Aviso", message: "Se requiere conexión a internet para cargar la página", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default){ action in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func loadData(){
        
        switch bankName {
        case "Paga Todo":
            self.urlString = "https://www.pagatodo.com"
            break
        case "BBVA Bancomer":
            self.urlString = "https://www.bbva.mx"
            break
        case "Scotiabank México":
            self.urlString = "https://www.scotiabank.com.mx"
            break
        case "Citibanamex":
            self.urlString = "https://www.banamex.com"
            break
        case "Banregio":
            self.urlString = "https://www.banregio.com"
            break
        default:
            self.urlString = "www.google.com"
        }
        
        loadWebPage()
    }
    
    func loadWebPage(){
        
        DispatchQueue.global().async {
            let urlString = self.urlString
            if let url = URL(string: urlString){
                let request = URLRequest(url: url)
                
                DispatchQueue.main.async {
                    self.pageView.load(request)
                }
            }
        }
        
    }
    
    func verificarConexionInternet() -> Bool {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "MonitoreoInternet")
        
        var tieneConexionInternet = false
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                if path.usesInterfaceType(.wifi){
                    tieneConexionInternet = true
                }else{
                    tieneConexionInternet = false
                }
            }
        }
        
        monitor.start(queue: queue)
        print(tieneConexionInternet)
        return tieneConexionInternet
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Activity.isHidden = false
        Activity.startAnimating()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Activity.isHidden = true
        Activity.stopAnimating()
    }
    
    
    var bankName: String = ""
    var urlString: String = ""
}
