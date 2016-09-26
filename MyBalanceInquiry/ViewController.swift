//
//  ViewController.swift
//  MyBalanceInquiry
//
//  Created by 酒井恭平 on 2016/09/20.
//  Copyright © 2016年 酒井恭平. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myBanktableView: UITableView!
    
    var superBank: BankManager!
    
    var selectedBank: Bank!
    
    var isFirstLoad: Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初めてのロードであれば、初期設定を行う
        if isFirstLoad != false {
            setBanking()
        }
        
        myBanktableView.delegate = self
        myBanktableView.dataSource = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 初期データを設定
    func setBanking() {
        
        // 銀行を追加
        let myBank1 = Bank(name: "みずほ銀行", firstBalance: 0)
        let myBank2 = Bank(name: "三菱東京UFJ銀行", firstBalance: 0)
        let myBank3 = Bank(name: "多摩信用金庫", firstBalance: 0)
        
        // StringをDateに変換するためのFormatterを用意
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        // 取引を追加
        myBank1.addBanking(date: dateFormatter.date(from: "2016/08/04"), banking: .Withdrawal, amount: 24000)
        myBank1.addBanking(date: dateFormatter.date(from: "2016/08/10"), banking: .Payment, amount: 30000)
        myBank1.addBanking(date: dateFormatter.date(from: "2016/08/20"), banking: .Withdrawal, amount: 15000)
        myBank1.addBanking(date: dateFormatter.date(from: "2016/08/25"), banking: .Withdrawal, amount: 10000)
        
        myBank1.addBanking(date: dateFormatter.date(from: "2016/09/04"), banking: .Withdrawal, amount: 27000)
        myBank1.addBanking(date: dateFormatter.date(from: "2016/09/10"), banking: .Payment, amount: 30000)
        myBank1.addBanking(date: dateFormatter.date(from: "2016/09/23"), banking: .Withdrawal, amount: 5000)
        myBank1.addBanking(date: dateFormatter.date(from: "2016/09/30"), banking: .Withdrawal, amount: 10000)
        
        myBank2.addBanking(date: dateFormatter.date(from: "2016/08/04"), banking: .Payment, amount: 80000)  // 外部からの収入
        myBank2.addBanking(date: dateFormatter.date(from: "2016/08/10"), banking: .Withdrawal, amount: 50000)
        myBank2.addBanking(date: dateFormatter.date(from: "2016/08/13"), banking: .Withdrawal, amount: 20000)
        myBank2.addBanking(date: dateFormatter.date(from: "2016/08/17"), banking: .Withdrawal, amount: 10000)
        myBank2.addBanking(date: dateFormatter.date(from: "2016/08/22"), banking: .Withdrawal, amount: 20000)
        
        myBank2.addBanking(date: dateFormatter.date(from: "2016/09/04"), banking: .Payment, amount: 80000)  // 外部からの収入
        myBank2.addBanking(date: dateFormatter.date(from: "2016/09/11"), banking: .Withdrawal, amount: 30000)
        myBank2.addBanking(date: dateFormatter.date(from: "2016/09/21"), banking: .Withdrawal, amount: 20000)
        
        //myBank3.addBanking(date: dateFormatter.date(from: "2016/08/05"), banking: .Withdrawal, amount: 10000)
        
        //myBank3.addBanking(date: dateFormatter.date(from: "2016/09/09"), banking: .Withdrawal, amount: 13000)
        //myBank3.addBanking(date: dateFormatter.date(from: "2016/09/21"), banking: .Withdrawal, amount: 29000)
        
        print(myBank1.balance)
        print(myBank2.balance)
        print(myBank3.balance)
        
        // 全ての銀行を管理
        let superBank = BankManager(bank: [myBank1, myBank2, myBank3])
        self.superBank = superBank
        print("合計残高：\(superBank.totalBalance)")
        
        print("8月の収支：\(superBank.getSumTotalBalance(fromDate: dateFormatter.date(from: "2016/08/01"), toDate: dateFormatter.date(from: "2016/09/01")))")
        print("9月の収支：\(superBank.getSumTotalBalance(fromDate: dateFormatter.date(from: "2016/09/01"), toDate: dateFormatter.date(from: "2016/10/01")))")
        
    }
    
    // My銀行を追加登録するボタンが押された時
    @IBAction func tapAddNewBankButton(_ sender: UIButton) {
        
        performSegue(withIdentifier: "toAddNewBank", sender: nil)
        
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSourceのメソッド

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return superBank.bank.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt  indexPath: IndexPath) -> UITableViewCell {
        // セルを定義（ここではデフォルトのセル）
        let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = superBank.bank[indexPath.row].bankName
        
        return cell
    }
    
    // セルが選択された時の処理
    func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedBank = superBank.bank[indexPath.row]
        performSegue(withIdentifier: "toMyBankViewController", sender: nil)
    }
    
}


// MARK: - 画面遷移に関する処理

extension ViewController {
    // Segue 準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if (segue.identifier == "toMyBankViewController") {
            let myBankVC: MyBankViewController = (segue.destination as? MyBankViewController)!
            // 遷移先にBankの参照先を渡す
            myBankVC.selectedBank = self.selectedBank
        }
        else if (segue.identifier == "toAddNewBank") {
            let newBankVC: AddNewBankViewController = (segue.destination as? AddNewBankViewController)!
            // 遷移先にBankManagerの参照先を渡す
            newBankVC.superBank = self.superBank
        }
        else if (segue.identifier == "toGraghView") {
            let graghVC: GraghViewController = (segue.destination as? GraghViewController)!
            // 遷移先にBankManagerの参照先を渡す
            graghVC.superBank = self.superBank
        }
        
    }
    
    // 戻るボタンにより前画面へ遷移
    @IBAction func back(segue: UIStoryboardSegue) {
        print("back")
    }
    
}

















