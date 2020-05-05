//
//  ViewController.swift
//  Algorithm
//
//  Created by tosru on 2018/12/01.
//  Copyright © 2018年 tosru. All rights reserved.
//

import SpriteKit
import UIKit

class HomeViewController: UIViewController {
  
  private let cellId = "vCcell"
  private lazy var tableView: UITableView = {
    let tV = UITableView(frame: view.bounds, style: .plain)
    tV.delegate = self
    tV.dataSource = self
    return tV
  }()
  private let sectionTitles = ["迷路", "ソート", "その他"]
  private let subTitles = [["棒倒し法"], ["バブルソート"], ["ハノイの塔"]]
  private lazy var viewControllers = [
    [PullingPoleViewController(scene: PullingPoleScene())],
    [BubbleSortViewController(scene: BubbleSortScene())],
    [TowerOfHanoiViewController(scene: TowerOfHanoiScene())]
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white   //横画面から縦画面にするときに一瞬映るためtabelViewと同じ色にしている
    title = "アルゴリズム"
    
    if #available(iOS 11.0, *) {
      navigationController?.navigationBar.prefersLargeTitles = true
      navigationItem.largeTitleDisplayMode = .always
    }
    setupTableView()
  }
  
  func setupTableView() {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    view.addSubview(tableView)
  }
}

extension HomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)  //押下後の色を元に戻す
    let vc = viewControllers[indexPath.section][indexPath.row]
    navigationController?.pushViewController(vc, animated: true)
  }
}

extension HomeViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return sectionTitles.count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sectionTitles[section]
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return subTitles[section].count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    cell.textLabel?.text = subTitles[indexPath.section][indexPath.row]
    // >を表示させる
    cell.accessoryType = .disclosureIndicator
    return cell
  }
}
