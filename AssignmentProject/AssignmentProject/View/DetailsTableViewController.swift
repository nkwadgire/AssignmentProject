/**
 *  * *****************************************************************************
 *  * Filename: DetailsTableViewController.swift
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

class DetailsTableViewController: UIViewController {
    var detailsViewModel = DetailsViewModel()
    weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    // MARK: - View life cycle methods
    
    override func loadView() {
        super.loadView()
        self.addTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView()
        self.addPullToRefresh()
        self.addRefreshButton()
        self.updateUI(pullRefresh: false)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Private functions
    
    private func configTableView() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        self.tableView.register(DetailsTableViewCell.self, forCellReuseIdentifier: "CustomCell")
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
    
    private func scrollToFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    private func updateUI(pullRefresh: Bool) {
        DispatchQueue.main.async {
            ActivityIndicatorView.shared.showActivityIndicator(inView: self.view)
        }
        
        detailsViewModel.fetchDetails { [weak self] response in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch response {
                case .failure(let error):
                    if error.localizedDescription ==  NetworkError.alertMessage {
                        self.showAlert(strError: error.localizedDescription)
                    }
                    
                case .success:
                    self.updateNavTitle(strTitle: self.detailsViewModel.arrDetails.navTitle ?? "")
                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                }
                
                if pullRefresh {
                    self.refreshControl.endRefreshing()
                } else {
                    self.scrollToFirstRow()
                }
                ActivityIndicatorView.shared.hideActivityIndicator()
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
    
    private func addPullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: Constants.pullToRefresh)
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    private func addRefreshButton() {
        let refreshImage = UIImage(named: "refresh")!.withRenderingMode(.alwaysOriginal)
        let rightButton = UIBarButtonItem(image: refreshImage,
                                          style: UIBarButtonItem.Style.plain,
                                          target: self,
                                          action: #selector(self.refresh(_:)))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func showAlert(strError: String) {
        let alertController = UIAlertController(title: "", message: strError, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Selector methods
    
    @objc func refresh(_ sender: AnyObject) {
        self.updateUI(pullRefresh: true)
    }
    
    private func fetchImage(urlString: String, completion: @escaping(UIImage) -> Void) {
        DispatchQueue.main.async {
            ActivityIndicatorView.shared.showActivityIndicator(inView: self.view)
        }
        
        detailsViewModel.fetchImageData(urlString: urlString) { (imgData, error) in
            DispatchQueue.main.async {
                ActivityIndicatorView.shared.hideActivityIndicator()
                if error != nil && error?.localizedDescription == NetworkError.alertMessage {
                    self.showAlert(strError: error?.localizedDescription ?? "")
                }
            }
            if let image = UIImage(data: imgData) {
                completion(image)
            } else {
                completion(UIImage(named: "placeholder") ?? UIImage())
            }
        }
    }
}

extension DetailsTableViewController: UITableViewDataSource {
    // MARK: - UITableViewDataSource functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailsViewModel.arrDetails.details?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? DetailsTableViewCell
        if indexPath.row < self.detailsViewModel.arrDetails.details?.count ?? 0 {
            let value = self.detailsViewModel.arrDetails.details?[indexPath.item]
            cell?.titleLabel.text = value?.rowTitle
            cell?.subTitleLabel.text = value?.rowDescription
            self.fetchImage(urlString: value?.rowImageHref ?? "", completion: { (img) in
                DispatchQueue.main.async {
                    cell?.imgView.image = img
                }
            })
        }
        return cell ?? DetailsTableViewCell()
    }
}

extension DetailsTableViewController: UITableViewDelegate {
    // MARK: - UITableViewDelegate functions
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
