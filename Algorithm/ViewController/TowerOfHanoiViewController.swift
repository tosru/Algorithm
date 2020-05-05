//
//  TowerOfHanoiViewController.swift
//  Algorithm
//
//  Created by tosru on 2020/04/26
//  ©︎ 2020 tosru
//

import SpriteKit
import UIKit

class TowerOfHanoiViewController: UIViewController {
  
  private var startButton: UIButton!
  private var diskNumber = 3
  private let diskNumberPickerTitles = [1, 2, 3, 4, 5]
  private var pickerView: UIPickerView!
  private let speedScalePickerTitles = [0.25, 0.5, 1, 2, 4, 10]
  private var completedSecondsLabel: UILabel!
  private var scene: TowerOfHanoiScene
  private var statusLabel: UILabel = {
    let sL = UILabel()
    sL.textAlignment = .center
    sL.isHidden = true
    return sL
  }()
  
  init(scene: TowerOfHanoiScene) {
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
    
    scene.myDelegate = self
    setupStartButton()
    setupPickerView()
    setupCompletedSecondsLabel()
    setupStatusLabel()
  }

  override func viewWillLayoutSubviews() {
    //この時点でsafeAreaが決まる
    if #available(iOS 11.0, *) {
      TowerOfHanoiScene.bottomSafeArea = view.safeAreaInsets.bottom
    }
  }
    
  private func setupStartButton() {
    startButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 50))
    startButton.center = view.center
    startButton.backgroundColor = .white
    startButton.setTitle("開始", for: .normal)
    startButton.setTitleColor(.black, for: .normal)
    startButton.layer.cornerRadius = 10.0
    startButton.layer.masksToBounds = true
    startButton.addTarget(self, action: #selector(startButtonAction(sender:)), for: .touchUpInside)
    view.addSubview(startButton)
  }
  
  private func setupPickerView() {
    pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.25))
    pickerView.center = CGPoint(x: view.frame.midX, y: view.frame.maxY * 0.25)
    pickerView.delegate = self
    pickerView.dataSource = self
    pickerView.selectRow(2, inComponent: 0, animated: false)
    pickerView.selectRow(2, inComponent: 1, animated: false)
    view.addSubview(pickerView)
  }
  
  private func setupCompletedSecondsLabel() {
    completedSecondsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.5, height: view.frame.height / 16))
    completedSecondsLabel.center = CGPoint(x: view.frame.midX, y: view.frame.maxY * 0.4) //真ん中少し上
    completedSecondsLabel.textAlignment = .center
    completedSecondsLabel.font = UIFont.hiramaru(size: 20)
    showCompletedSeconds() //デフォルトの完了時間を書く
    view.addSubview(completedSecondsLabel)
  }
  
  private func setupStatusLabel() {
    statusLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.8, height: view.frame.height * 0.25))
    statusLabel.center = CGPoint(x: view.frame.midX, y: view.frame.maxY * 0.25)
    statusLabel.textAlignment = .center
    statusLabel.font = UIFont.hiramaru(size: 55)
    statusLabel.isHidden = true
    view.addSubview(statusLabel)
  }
  
  @objc private func startButtonAction(sender: UIButton) {
    pickerView.isHidden = true
    statusLabel.isHidden = false
    scene.startHanoi(numDisk: diskNumber)
    sender.removeTarget(self, action: #selector(startButtonAction(sender:)), for: .touchUpInside)
    sender.addTarget(self, action: #selector(removeAction(sender:)), for: .touchUpInside)
    sender.setTitle("消す", for: .normal)
  }
  
  @objc private func removeAction(sender: UIButton) {
    statusLabel.isHidden = true
    pickerView.isHidden = false
    scene.initValue()
    scene.isPaused = false
    sender.removeTarget(self, action: #selector(removeAction(sender:)), for: .touchUpInside)
    sender.addTarget(self, action: #selector(startButtonAction(sender:)), for: .touchUpInside)
    sender.setTitle("開始", for: .normal)
  }
  
  private func showCompletedSeconds() {
    let order = pow(2.0, Double(diskNumber)) - 1.0  //実行回数が2^n - 1であるため
    let tmp1 = scene.defaultDuration["upDown"]!
    let tmp2 = scene.defaultDuration["leftRight"]!
    let round = (order * (tmp1 + tmp2 + tmp1)).rounded()
    var text: String
    if round == 0.0 {
      text = "およそ0.1秒かかる"
    } else {
      text = "およそ\(Int(round))秒かかる"
    }
    completedSecondsLabel.text = text
  }
}

extension TowerOfHanoiViewController: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if component == 0 {
      return "\(diskNumberPickerTitles[row])枚"
    } else if component == 1 {
      if row == 2 {
        return "標準(1秒)"
      }
      return "\(speedScalePickerTitles[row])倍速"
    } else {
      fatalError(#function)
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if component == 0 {
      diskNumber = diskNumberPickerTitles[row]
      showCompletedSeconds()
    } else if component == 1 {
      scene.changeSpeed(speedScale: 1.0 / speedScalePickerTitles[row])
      showCompletedSeconds()
    }
  }
}

extension TowerOfHanoiViewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 2
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if component == 0 {
      return diskNumberPickerTitles.count
    } else if component == 1 {
      return speedScalePickerTitles.count
    } else {
      fatalError(#function)
    }
  }
}

extension TowerOfHanoiViewController: StatusLabelDelegate {
  func changeStatusLabelText() {
    statusLabel.text = scene.status.rawValue
  }
}
