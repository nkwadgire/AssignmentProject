/**
 *  * *****************************************************************************
 *  * Filename: ViewController.swift
 *  * Author  : Nagraj Wadgire
 *  * Creation Date: 17/12/20
 *  * *
 *  * *****************************************************************************
 *  * Description:
 *  * This viewcontroller will show the API response using tableView
 *  *                                                                             *
 *  * *****************************************************************************
 */

import UIKit

class ViewController: UIViewController {
    var arrResponse = Details()
    weak var tableView: UITableView!
    var networkStatus: NetworkReachability?
    
    // MARK: - View life cycle methods
    
    override func loadView() {
        super.loadView()
        self.addTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkStatus = NetworkReachability()
        self.configTableView()
        self.updateUI(pullRefresh: false)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func configTableView() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        self.tableView.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.isHidden = true
    }
    
    private func addTableView() {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.separatorColor = .black
        
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            self.view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: tableView.topAnchor),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            self.view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor)
        ])
        self.tableView = tableView
    }
    
    // MARK: - Private functions
    
    private func updateUI(pullRefresh: Bool) {
        let webservice = Webservice()
        guard (networkStatus?.networkAvailable()) == true else {
            return
        }
        webservice.getDetails { (response, _)  in
            self.arrResponse = response
            self.arrResponse.details = response.details?.filter {($0 as Rows).rowTitle != nil}
            DispatchQueue.main.async {
                self.updateNavTitle(strTitle: self.arrResponse.navTitle ?? "")
                self.tableView.reloadData()
                self.tableView.isHidden = false
            }
        }
    }
    
    private func updateNavTitle(strTitle: String) {
        navigationItem.title = nil
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 26)
        titleLabel.textColor = .black
        titleLabel.text = strTitle
        titleLabel.backgroundColor = .clear
        navigationItem.titleView = titleLabel
    }
}

extension ViewController: UITableViewDataSource {
    // MARK: - UITableViewDataSource functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrResponse.details?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomCell
        let value = self.arrResponse.details?[indexPath.item]
        cell?.titleLabel.text = value?.rowTitle
        cell?.subTitleLabel.text = value?.rowDescription
        
        Webservice().downloadImage(from: value?.rowImageHref ?? "") { (imgData, _)  in
            DispatchQueue.main.async {
                if let image = UIImage(data: imgData) {
                    cell?.imgView.image = image
                } else {
                    cell?.imgView.image = UIImage(named: "placeholder")
                }
            }
        }
        return cell ?? CustomCell()
    }
}

extension ViewController: UITableViewDelegate {
    // MARK: - UITableViewDelegate functions
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
