//
//  GraghViewController.swift
//  MyBalanceInquiry
//
//  Created by 酒井恭平 on 2016/09/26.
//  Copyright © 2016年 酒井恭平. All rights reserved.
//

import UIKit

class GraghViewController: UIViewController {
    
    @IBOutlet weak var graghScrollView: UIScrollView!
    @IBOutlet weak var textField: UITextField!
    
    var superBank: BankManager!
    
    var barGragh: BarGragh!
    
//    var myData: [Int] = [80000, 87000, 105000, 72000, 50000, 123973, 33023, 23244, 97564, 122333]
    var myData: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawGraghIntoScrollView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dateFormat(date: Date, stringFormat: String) -> String {
        // StringをDateに変換するためのFormatterを用意
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = stringFormat
        
        return dateFormatter.string(from: date)
    }
    
    
    func drawGraghIntoScrollView() {
        
        var year = Int(dateFormat(date: superBank.mostOldDate, stringFormat: "yyyy"))
        var month = Int(dateFormat(date: superBank.mostOldDate, stringFormat: "MM"))
        
        let finalYear = Int(dateFormat(date: superBank.mostNewDate, stringFormat: "yyyy"))
        let finalMonth = Int(dateFormat(date: superBank.mostNewDate, stringFormat: "MM"))
        
        // StringをDateに変換するためのFormatterを用意
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        while year! <= finalYear! {
            
            var overMonth: Int
            
            if year == finalYear {
                overMonth = 12
            } else {
                overMonth = finalMonth!
            }
            
            while month! <= overMonth {
                
                let from = "\(year!)/\(month!)/01"
                let to: String
                
                if month! == 12 {
                    to = "\(year! + 1)/01/01"
                } else {
                    to = "\(year!)/\(month! + 1)/01"
                }
                
                // 収支金額
                let totalBalance = superBank.getSumTotalBalance(fromDate: dateFormatter.date(from: from), toDate: dateFormatter.date(from: to))
                // 月々の収入
                let income = 80000
                
                myData.append(income - totalBalance)
                
                month! += 1
            }
            year! += 1
            month = 1
        }
        
        
        let screenSize = UIScreen.main.bounds.size
        let height = graghScrollView.frame.size.height
        
        let spendingGragh = BarGragh(dataArray: myData, date: superBank.mostOldDate, barAreaWidth: screenSize.width / 4, height: height, average: Int(textField.text!)!)
        self.barGragh = spendingGragh
        
        graghScrollView.addSubview(spendingGragh)
        graghScrollView.contentSize = CGSize(width: spendingGragh.frame.size.width, height: spendingGragh.frame.size.height)
        
        textField.delegate = self
        graghScrollView.delegate = self
        
        print("drawGraghIntoScrollView")
        
    }
    
    
}


extension GraghViewController: UITextFieldDelegate {
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        print("textFieldDidEndEditing")
//        drawGraghIntoScrollView()
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        // 初期化
        for sub in graghScrollView.subviews {
            sub.removeFromSuperview()
        }
        self.myData.removeAll()
        // 再描画
        drawGraghIntoScrollView()
        return true
    }
    
}


extension GraghViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 設定額のラベルをスクロールとともに追従させる
        barGragh.averageLabel.frame.origin.x = scrollView.contentOffset.x
        
    }
    
}




