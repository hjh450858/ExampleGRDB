//
//  ViewController.swift
//  ExampleGRDB
//
//  Created by 황재현 on 7/10/25.
//

import UIKit
import GRDB
import SnapKit
import Then
import RxSwift
import RxRelay

class ViewController: UIViewController {
    let textField = UITextField().then {
        $0.placeholder = "제목을 입력해주세요."
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 0.3
        $0.layer.cornerRadius = 8
    }
    
    let tableView = UITableView().then {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    let addBtn = UIButton(type: .system).then {
        $0.setTitle("저장하기", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 0.3
        $0.layer.cornerRadius = 8
    }
    
    var memos = BehaviorRelay<[MemoModel]>(value: [])
    
    var viewModel = MainVM()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        bindigVM()
        
        loadData()
    }
    
    
    func configureUI() {
        view.addSubview(textField)
        view.addSubview(tableView)
        view.addSubview(addBtn)
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        addBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(addBtn.snp.bottom)
        }
    }
    
    func loadData() {
        viewModel.fetchMemo()
            .observe(on: MainScheduler.instance)
            .bind(to: self.memos)
            .disposed(by: disposeBag)
    }
    
    func bindigVM() {
        memos.bind(to: tableView.rx.items(cellIdentifier: "cell")) { [weak self] index, memo, cell in
            guard let self = self else { return }
            cell.textLabel?.text = memo.title
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(MemoModel.self).subscribe { [weak self] memo in
            guard let self = self else { return }
            print("selected - memo = \(memo)")
        }.disposed(by: disposeBag)
        
        tableView.rx.modelDeleted(MemoModel.self).subscribe { [weak self] memo in
            guard let self = self else { return }
            DBManager.shared.deleteMemo(memo: memo)
            self.loadData()
        }.disposed(by: disposeBag)
        
        addBtn.rx.tap.subscribe { [weak self] tap in
            guard let self = self else { return }
            print("tap")
            // 입력한 내용 없으면 리턴
            if self.textField.text!.isEmpty { return }
            
            self.viewModel.addMemo(text: self.textField.text!)
            self.textField.text = nil
            self.loadData()
        }.disposed(by: disposeBag)
    }
}

