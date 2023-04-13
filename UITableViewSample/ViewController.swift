//
//  ViewController.swift
//  UITableViewSample
//
//  Created by hiraoka on 2022/07/16.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    @IBOutlet var tableHeaderView: UIView!

    @IBOutlet var tableFooterView: UIView!

//    private var offset: CGPoint?

    @IBOutlet var bottomConstraint: NSLayoutConstraint!

    private var dataSource: [String] = (0...100).reversed().map { "default - \($0)" }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self

        self.tableView.contentInset.top = self.tableHeaderView.frame.height

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PrototypeCell")

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification: NSNotification) {
//        offset = tableView.contentOffset

        if
            let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double

        {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            bottomConstraint.constant = -keyboardHeight + view.safeAreaInsets.bottom
            tableView.setContentOffset(
                .init(x: tableView.contentOffset.x,
                      y: tableView.contentOffset.y + keyboardHeight - view.safeAreaInsets.bottom),
                animated: true)
            UIView.animate(withDuration: keyboardAnimationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        if
//            let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double

        {
//            let keyboardHeight = keyboardFrame.cgRectValue.height


            self.bottomConstraint.constant = .zero

//            if let offset = self.offset,
//               tableView.contentOffset.y == (offset.y + keyboardHeight - view.safeAreaInsets.bottom) {
//                                print("💙 [\(#function) \(#line)] offset.y 1: \(offset.y + keyboardHeight - view.safeAreaInsets.bottom)")
//                                print("💙 [\(#function) \(#line)] offset.y 2: \(tableView.contentSize.height - tableView.frame.height + tableView.contentInset.bottom)")
//                                print("💙 [\(#function) \(#line)] tableView.contentOffset: \(tableView.contentOffset)")
//
//                let offset = CGPoint(x: offset.x, y: offset.y + keyboardHeight - view.safeAreaInsets.bottom)
//                self.tableView.setContentOffset(offset, animated: true)
//            }
            UIView.animate(withDuration: keyboardAnimationDuration, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        tableView.reloadData()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    @IBAction func scrollToBottom(_ sender: Any) {
        tableView.setContentOffset(
            CGPoint(x: tableView.contentOffset.x,
                    y: max(
                        -tableView.adjustedContentInset.top,
                         tableView.contentSize.height - tableView.frame.height + tableView.contentInset.bottom
                    )),
            animated: true)
    }
    @IBAction func addContents(_ sender: Any) {

        let add = (0...Int.random(in: 10...30)).reversed().map { "add - \($0)" }

        dataSource = add + dataSource
        let topIndexPath = tableView.indexPathsForVisibleRows!.first!
        print(topIndexPath.description)
        print(add.count)
        tableView.reloadData()
        self.view.layoutIfNeeded()
        tableView.scrollToRow(at: .init(row: add.count, section: topIndexPath.section),
                              at: .top, animated: false)
//
//        let before = tableView.contentSize
//        print("💙 [\(#function) \(#line)] before size: \(before)")
//        print("💙 [\(#function) \(#line)] before offset: \(tableView.contentOffset)")
//        tableView.reloadData()
//        let after = tableView.contentSize
//        print("💙 [\(#function) \(#line)] after size: \(after)")
//        print("💙 [\(#function) \(#line)] after offset: \(tableView.contentOffset)")
//        let diffHeight = after.height - before.height
//        print("💙 [\(#function) \(#line)] after diff: \(diffHeight)")
////        tableView.setContentOffset(.init(x: tableView.contentOffset.x,
////                                         y: tableView.contentOffset.y + diffHeight
////                                         ),
////                                   animated: true)
////        self.view.layoutIfNeeded()
//
//        print("💙 [\(#function) \(#line)] finish offset: \(tableView.contentOffset)")
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrototypeCell", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = "\(dataSource[indexPath.row]) \(indexPath.description)"
        cell.contentConfiguration = configuration
        return cell
    }
}

extension ViewController: UITableViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        view.endEditing(true)
        UIView.animate(withDuration: 0.2, animations: {
            self.tableHeaderView.transform = CGAffineTransform(translationX: .zero, y: -self.tableHeaderView.frame.height)
            self.tableView.contentInset.top = .zero
        }) { _ in
            self.tableHeaderView.isHidden = true
            self.view.layoutIfNeeded()
        }

    }

        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//            if decelerate {
//                view.endEditing(true)
//                return
//            }
//            UIView.animate(withDuration: 0.2, animations: {
//                self.tableHeaderView.transform = CGAffineTransform.identity
//            }) { _ in
//                self.tableView.contentInset.top = self.tableHeaderView.frame.height
//                self.tableHeaderView.isHidden = false
//                self.view.layoutIfNeeded()
//            }
        }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.2, animations: {
            self.tableHeaderView.transform = CGAffineTransform.identity
            self.tableView.contentInset.top = self.tableHeaderView.frame.height
            if self.tableView.contentOffset.y.isZero {
                self.tableView.setContentOffset(
                    CGPoint(x: self.tableView.contentOffset.x, y: -self.tableView.contentInset.top),
                    animated: true
                )
            }
        }) { _ in
            self.tableHeaderView.isHidden = false
            self.view.layoutIfNeeded()
        }
    }
}
