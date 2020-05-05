//
//  PullingPoleViewController.swift
//  Algorithm
//
//  Created by tosru on 2020/04/26
//  ©︎ 2020 tosru
//

import SpriteKit
import UIKit

class PullingPoleViewController: UIViewController {
  
  private var activityIndicatorView: UIActivityIndicatorView!
  private var mazeSize: Int = 5
  private let mazeSizePicker = stride(from: 5, through: 57, by: 4).map { Int($0) }
  private var pickerView: UIPickerView!
  private var startStopButton: UIButton!
  private var scene: PullingPoleScene
  private var statusLabel: UILabel = {
    let sL = UILabel()
    sL.textAlignment = .center
    sL.isHidden = true
    return sL
  }()
  
  init(scene: PullingPoleScene) {
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
    setupPickerView()
    setupStartStopButton()
    setupStatusLabel()
    setupActivityIndicatorView()
  }

  override func viewWillLayoutSubviews() {
    //この時点でsafeAreaが決まる
    if #available(iOS 11.0, *) {
      PullingPoleScene.bottomSafeArea = view.safeAreaInsets.bottom
    }
  }
  
  private func setupPickerView() {
    pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.5, height: view.frame.height * 0.25))
    pickerView.center = CGPoint(x: view.frame.midX * 0.5, y: view.frame.maxY * 0.25)
    pickerView.delegate = self
    pickerView.dataSource = self
    view.addSubview(pickerView)
  }
  
  private func setupStartStopButton() {
    startStopButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 50))
    startStopButton.center = CGPoint(x: view.frame.maxX * 0.75 , y: view.frame.maxY * 0.25)
    startStopButton.backgroundColor = .white
    startStopButton.setTitle("開始", for: .normal)
    startStopButton.setTitleColor(.black, for: .normal)
    startStopButton.layer.cornerRadius = 10
    startStopButton.layer.masksToBounds = true
    startStopButton.addTarget(self, action: #selector(startMazeAction(sender:)), for: .touchUpInside)
    view.addSubview(startStopButton)
  }
  
  private func setupStatusLabel() {
    statusLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.5, height: view.frame.height * 0.25))
    statusLabel.center = CGPoint(x: view.frame.midX * 0.5, y: view.frame.maxY * 0.25)
    statusLabel.textAlignment = .center
    statusLabel.font = UIFont.hiramaru(size: 35)
    statusLabel.isHidden = true
    view.addSubview(statusLabel)
  }
  
  private func setupActivityIndicatorView() {
    activityIndicatorView = UIActivityIndicatorView()
    activityIndicatorView.center = CGPoint(x: view.frame.maxX * 0.75 , y: view.frame.maxY * 0.25)
    activityIndicatorView.style = .large
    activityIndicatorView.color = .black
    activityIndicatorView.hidesWhenStopped = true
    view.addSubview(activityIndicatorView)
  }
  
  @objc private func startMazeAction(sender: UIButton) {
    pickerView.isHidden = true
    statusLabel.isHidden = false
    statusLabel.text = scene.status.rawValue
    sender.isHidden = true
    sender.removeTarget(self, action: #selector(startMazeAction(sender:)), for: .touchUpInside)
    sender.setTitle("消す", for: .normal)
    sender.addTarget(self, action: #selector(stopMazeAction(sender:)), for: .touchUpInside)
    activityIndicatorView.startAnimating()
    //サブスレッドで重い処理を実行
    DispatchQueue.global(qos: .default).async {
      self.scene.startMaze(mazeSize: self.mazeSize)
      //メインスレッドへ戻る
      DispatchQueue.main.async {
        self.scene.startTimer(mazeSize: self.mazeSize)
        self.statusLabel.text = self.scene.status.rawValue
        self.activityIndicatorView.stopAnimating()
        sender.isHidden = false
      }
    }
  }
  
  @objc private func stopMazeAction(sender: UIButton) {
    scene.initValue()
    pickerView.isHidden = false
    statusLabel.isHidden = true
    sender.removeTarget(self, action: #selector(stopMazeAction(sender:)), for: .touchUpInside)
    sender.setTitle("開始", for: .normal)
    sender.addTarget(self, action: #selector(startMazeAction(sender:)), for: .touchUpInside)
  }
}

extension PullingPoleViewController: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    mazeSize = mazeSizePicker[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    let oneEdgeSize = mazeSizePicker[row]
    return oneEdgeSize.description + " x " + oneEdgeSize.description
  }
}

extension PullingPoleViewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return mazeSizePicker.count
  }
}

extension PullingPoleViewController: StatusLabelDelegate {
  func changeStatusLabelText() {
    statusLabel.text = scene.status.rawValue
  }
}
