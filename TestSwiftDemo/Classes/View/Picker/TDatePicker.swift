//
//  TDatePicker.swift
//  TestSwiftDemo
//
//  Created by FW on 2021/5/31.
//

import UIKit

enum DatePickerType {
    case ym, ymd
}

class TDatePicker: UIView {
    
    private var rect = KSCREENBOUNDS
    private var pickerType: DatePickerType = .ym
    private var date: Date = Date()
    private var dataList: [[Int]] = []
    
    var confirm: ConfirmBlock<Date>?
    var cancel: CancelBlock?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(_ pickerType: DatePickerType = .ym, date: Date = Date()) {
        super.init(frame: KSCREENBOUNDS)
        
        self.pickerType = pickerType
        self.date = date
        setupSubviews()
        setupData()
    }
    
    deinit {
        print("TDatePicker deinit")
    }
    
    override func layoutSubviews() {
        if self.superview != nil {
            rect = self.superview!.bounds
        }
        
        self.frame = rect
    }
    
    //MARK: - Lazy
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.0)
        let ges = UITapGestureRecognizer.init(target: self, action: #selector(bgClick))
        view.addGestureRecognizer(ges)
        return view
    }()
    
    lazy var pickerView: UIPickerView = {
        let view = UIPickerView.init(frame: CGRect(x: 0, y: KSCREENHEIGHT, width: KSCREENWIDTH, height: 250))
        view.backgroundColor = UIColor.white
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    lazy var toolBar: UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: KSCREENHEIGHT, width: KSCREENWIDTH, height: 44))
        view.backgroundColor = UIColor.white
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        view.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(0.5)
        }
        return view
    }()
    
    lazy var cancelBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(defaultTitleColor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .light)
        btn.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("确定", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .light)
        btn.setTitleColor(defaultTitleColor, for: .normal)
        btn.addTarget(self, action: #selector(confirmClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = defaultTitleColor
        return label
    }()
}

// MARK: - Private
extension TDatePicker {
    private func setupSubviews() {
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        bgView.addSubview(pickerView)
        bgView.addSubview(toolBar)
        
        toolBar.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(toolBar)
            make.left.equalTo(toolBar).offset(16)
        }
        
        toolBar.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(toolBar)
            make.right.equalTo(toolBar).offset(-16)
        }
        
        toolBar.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalTo(toolBar)
        }
    }
    
    private func setupData() {
        /// year
        var year: [Int] = []
        for i in 2010...2025 {
            year.append(i)
        }
        
        /// month
        var month: [Int] = []
        for i in 1...12 {
            month.append(i)
        }
        
        dataList.append(year)
        dataList.append(month)
        
        pickerView.selectRow(year.firstIndex(of: self.date.year) ?? 0, inComponent: 0, animated: false)
        pickerView.selectRow(month.firstIndex(of: self.date.month) ?? 0, inComponent: 1, animated: false)
        
        if (pickerType == .ymd) {
            pickerView.selectRow(self.date.day, inComponent: 2, animated: false)
        }
        
        titleLabel.text = pickerType == .ymd ? "选择日期" : "选择月份"
    }
    
    private func animate(_ isShow: Bool = true, completion: ((Bool) -> Void)? = nil) {
        
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.bgView.backgroundColor = UIColor.init(white: 0, alpha: isShow ? 0.3 : 0.0)
                        self.pickerView.frame = CGRect(x: 0,
                                                       y: isShow ? self.rect.height - 250 : self.rect.height,
                                                       width: self.rect.width,
                                                       height: 250)
                        self.toolBar.frame = CGRect(x: 0,
                                                    y: isShow ? self.rect.height - 250 - 44 : self.rect.height,
                                                    width: self.rect.width,
                                                    height: 44)
                       },
                       completion: completion)
    }
    
    @objc private func bgClick() {
        cancelClick()
    }
    
    @objc private func cancelClick() {
        dismiss()
        if let cancel = cancel {
            cancel()
        }
    }
    
    @objc private func confirmClick() {
        dismiss()
        if let confirm = confirm, let date = Date(year: dataList[0][pickerView.selectedRow(inComponent: 0)],
                                                  month: dataList[1][pickerView.selectedRow(inComponent: 1)]) {
            confirm(date)
        }
    }
    
    private func dismiss() {
        animate(false) { (_) in
            self.removeFromSuperview()
        }
    }
}


// MARK: - Public
extension TDatePicker {
    func show(_ view: UIView? = UIApplication.shared.currentWindow) {
        
        var targetView = view
        
        if targetView == nil {
            targetView = UIApplication.shared.currentWindow
        }
        
        guard let view = targetView else {
            return
        }
        
        view.addSubview(self)
        animate()
    }
}

// MARK: - UIPickerViewDataSource
extension TDatePicker: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        pickerType == .ym ? 2 : 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard component != 2 else {
            return 10
        }
        return dataList[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard component != 2 else {
            return "1日"
        }
        let title = "\(dataList[component][row])" + "\(component == 0 ? "年" : "月")"
        return title
    }
    
    
}

// MARK: - UIPickerViewDelegate
extension TDatePicker: UIPickerViewDelegate {
    
}

extension TDatePicker {
    var string: String {return ""}
}
