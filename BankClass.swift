//
//  BankClass.swift
//  MyBalanceInquiry
//
//  Created by 酒井恭平 on 2016/09/21.
//  Copyright © 2016年 酒井恭平. All rights reserved.
//

import Foundation


// MARK: - Bankクラス

class Bank {
    // 銀行名
    var bankName:String
    // 初期残高を記録
    let firstBalance: Int
    // 残高
    var balance: Int
    // 入出金データ
    var bankStatement:[(date: Date, banking: Banking, amount: Int)] = []
    
    init() {
        self.bankName = ""
        self.firstBalance = 0
        self.balance = 0
    }
    
    init(name: String, firstBalance: Int) {
        self.bankName = name
        self.firstBalance = firstBalance
        self.balance = firstBalance
    }
    
    // 取引を追加し、入出金データに格納
    func addBanking(date: Date!, banking: Banking, amount: Int) {
        let data:(Date, Banking, Int) = (date, banking, amount)
        self.bankStatement.append(data)
        
        // 日付順にデータを並び替えて格納する -> insertがうまく機能せず…
        //        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        //        // 配列が空でなければ
        //        if bankStatement.isEmpty == false {
        //            let count = bankStatement.count
        //            var i = 1
        //
        //            while (calendar.compare(date, to: bankStatement[count - i].date, toUnitGranularity: .day) == .orderedAscending) || count < i {
        //
        //                i += 1
        //            }
        //
        //            self.bankStatement.insert((date, banking, amount), at: count - i + 1)
        //        } else {
        //            self.bankStatement.append(data)
        //        }
        
        
        // 残高を求める
        if banking == Banking.Payment {
            self.balance += amount
        } else {
            self.balance -= amount
        }
    }
    
    // 過去全ての取引を計算する
    func getTotalBalance() -> Int {
        var totalBalance: Int = self.firstBalance
        
        for i in bankStatement {
            if i.banking == Banking.Payment {
                totalBalance += i.amount
            } else {
                totalBalance -= i.amount
            }
        }
        return totalBalance
    }
    
    // 指定した期間の取引を計算する
    func getTotalBalance(fromDate: Date!, toDate: Date!) -> Int {
        var totalBalance: Int = 0
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        
        // fromData < toDateでなかった場合は強制終了
        if calendar.compare(fromDate, to: toDate, toUnitGranularity: .day) != .orderedAscending {
            print("期間設定に誤りがあります。")
            exit(0)
        }
        
        for i in bankStatement {
            
            let result1 = calendar.compare(i.date, to: fromDate, toUnitGranularity: .day)
            // i.date > fromDateであれば
            if result1 == .orderedDescending {
                
                let result2 = calendar.compare(i.date, to: toDate, toUnitGranularity: .day)
                // i.data < toDateであれば
                if result2 == .orderedAscending {
                    if i.banking == Banking.Payment {
                        totalBalance += i.amount
                    } else {
                        totalBalance -= i.amount
                    }
                }
            }
        }
        return totalBalance
    }
    
    
    
    // 取引明細を一覧で表示
    func printBankStatement() {
        for i in bankStatement {
            print(i)
        }
    }
    
    // 指定した日にちの取引のみを表示
    func printBankStatement(fromDate: Date!) {
        for i in bankStatement {
            if i.date == fromDate {
                print(i)
            }
        }
    }
    
    // 指定した期間の取引のみを表示
    func printBankStatement(fromDate: Date!, toDate: Date!) {
        
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        
        // fromData < toDateでなかった場合は強制終了
        if calendar.compare(fromDate, to: toDate, toUnitGranularity: .day) != .orderedAscending {
            print("期間設定に誤りがあります。")
            return;
        }
        
        for i in bankStatement {
            
            let result1 = calendar.compare(i.date, to: fromDate, toUnitGranularity: .day)
            // i.date > fromDateであれば
            if result1 == .orderedDescending {
                
                let result2 = calendar.compare(i.date, to: toDate, toUnitGranularity: .day)
                // i.data < toDateであれば
                if result2 == .orderedAscending {
                    print(i)
                }
            }
        }
    }
    
}

// 銀行取引の種類
enum Banking {
    // 入金
    case Payment
    // 出金
    case Withdrawal
}


// MARK: - Bankクラスをまとめて扱うクラス

class BankManager {
    var bank: [Bank]
    var totalBalance: Int = 0
    
    init() {
        self.bank = []
    }
    
    init(bank: [Bank]) {
        self.bank = bank
        self.totalBalance = getSumTotalBalance()
    }
    
    // 銀行を追加
    func addBank(bank: Bank) {
        self.bank.append(bank)
        self.totalBalance = self.getSumTotalBalance()
    }
    
    // 合計残高を算出
    func getSumTotalBalance() -> Int {
        var total = 0
        
        for i in self.bank {
            total += i.getTotalBalance()
        }
        return total
    }
    
    // 指定期間の収支バランスを求める
    func getSumTotalBalance(fromDate: Date!, toDate: Date!) -> Int {
        var total = 0
        
        for i in self.bank {
            total += i.getTotalBalance(fromDate: fromDate, toDate: toDate)
        }
        return total
    }
    
}

















