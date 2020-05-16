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
  
  private let pickerNumberOfTiles = [5, 6, 7, 8]
  private var selectedPickerNumber = 7
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
  private let statusLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.isHidden = true
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
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
    skView.ignoresSiblingOrder = true
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
    scene.myDelegate = self
    setupPickerView()
    setupButton()
    setupStatusLabel()
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
    button.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
    NSLayoutConstraint.activate(
      [
        button.leadingAnchor.constraint(equalTo: pickerView.trailingAnchor, constant: 30),
        button.widthAnchor.constraint(equalToConstant: 80),
        button.heightAnchor.constraint(equalToConstant: 50),
        button.centerYAnchor.constraint(equalTo: pickerView.centerYAnchor)
      ]
    )
  }
  
  private func setupStatusLabel() {
    view.addSubview(statusLabel)
    statusLabel.font = UIFont.hiramaru(size: 35)
    NSLayoutConstraint.activate(
      [
        statusLabel.centerXAnchor.constraint(equalTo: pickerView.centerXAnchor),
        statusLabel.centerYAnchor.constraint(equalTo: pickerView.centerYAnchor),
        statusLabel.widthAnchor.constraint(equalTo: pickerView.widthAnchor),
        statusLabel.heightAnchor.constraint(equalTo: pickerView.heightAnchor)
      ]
    )
  }
  
  @objc private func handleButton() {
    switch scene.status {
    case .initial:
      pickerView.isHidden = true
      statusLabel.isHidden = false
      scene.start(numberOfTiles: selectedPickerNumber)
      button.setTitle("消す", for: .normal)
    case .processing, .running, .end:
      statusLabel.isHidden = true
      pickerView.isHidden = false
      scene.clear()
      button.setTitle("開始", for: .normal)
    }
  }
}

extension BubbleSortViewController: UIPickerViewDataSource, UIPickerViewDelegate {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerNumberOfTiles.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return "\(pickerNumberOfTiles[row])個"
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    selectedPickerNumber = pickerNumberOfTiles[row]
  }
}

extension BubbleSortViewController: StatusLabelDelegate {
  func changeStatusLabelText() {
    statusLabel.text = scene.status.rawValue
  }
}
