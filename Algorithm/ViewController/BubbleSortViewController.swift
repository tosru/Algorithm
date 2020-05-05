//
//  BubbleSort.swift
//  Algorithm
//
//  Created by tosru on 2020/05/03
//  ©︎ 2020 tosru
//

import SpriteKit
import UIKit

class BubbleSortViewController: UIViewController {
  
  private let numberSquare = [3, 4, 5, 6, 7, 8]
  private var scene: BubbleSortScene
  private lazy var pickerView: UIPickerView = {
    let view = UIPickerView()
    view.dataSource = self
    view.delegate = self
    view.selectRow(2, inComponent: 0, animated: false)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  private let button: UIButton = {
    let btn = UIButton()
    btn.backgroundColor = .white
    btn.setTitle("開始", for: .normal)
    btn.setTitleColor(.black, for: .normal)
    btn.layer.cornerRadius = 10
    btn.layer.masksToBounds = true
    btn.translatesAutoresizingMaskIntoConstraints = false
    return btn
  }()
  
  init(scene: BubbleSortScene) {
    self.scene = scene
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    let skView = SKView(frame: UIScreen.main.bounds)
    view = skView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let view = self.view as? SKView {
      scene.size = view.frame.size
      scene.scaleMode = .aspectFill
      view.presentScene(scene)
    } else {
      fatalError("view should be converted to SKView")
    }
    if #available(iOS 11.0, *) {
      navigationItem.largeTitleDisplayMode = .never
    }
    
    setupPickerView()
    setupButton()
  }
  
  private func setupPickerView() {
    view.addSubview(pickerView)
    NSLayoutConstraint.activate(
      [
        pickerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
        pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        pickerView.widthAnchor.constraint(equalToConstant: view.frame.width / 2),
        pickerView.heightAnchor.constraint(equalToConstant: 100)
      ]
    )
  }
  
  private func setupButton() {
    view.addSubview(button)
    NSLayoutConstraint.activate(
      [
        button.leadingAnchor.constraint(equalTo: pickerView.trailingAnchor, constant: 30),
        button.widthAnchor.constraint(equalToConstant: 80),
        button.heightAnchor.constraint(equalToConstant: 50),
        button.centerYAnchor.constraint(equalTo: pickerView.centerYAnchor)
      ]
    )
  }
}

extension BubbleSortViewController: UIPickerViewDataSource, UIPickerViewDelegate {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return numberSquare.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return "\(numberSquare[row])個"
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    // select something
    print(numberSquare[row])
  }
}

