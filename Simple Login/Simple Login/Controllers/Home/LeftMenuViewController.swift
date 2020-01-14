//
//  LeftMenuViewController.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 10/01/2020.
//  Copyright © 2020 SimpleLogin. All rights reserved.
//

import UIKit

protocol LeftMenuViewControllerDelegate {
    func didSelectAlias()
    func didSelectDirectory()
    func didSelectCustomDomain()
    func didSelectSettings()
    func didSelectAbout()
}

final class LeftMenuViewController: UIViewController {
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    private let options: [[LeftMenuOption]] = [[.alias, .aliasDirectory, .customDomains], [.separator],  [.settings, .about]]
    
    var userInfo: UserInfo?
    var delegate: LeftMenuViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindUserInfo()
    }

    private func setUpUI() {
        view.backgroundColor = SLColor.menuBackgroundColor
        
        // topView
        topViewHeightConstraint.constant = hasTopNotch ? 150 : 120
        
        // avatarImageView
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
        avatarImageView.layer.borderWidth = 2
        avatarImageView.layer.borderColor = SLColor.tintColor.cgColor
        avatarImageView.layer.backgroundColor = SLColor.tintColor.withAlphaComponent(0.5).cgColor
        
        // usernameLabel
        usernameLabel.textColor = SLColor.textColor
        
        // shadowView
        let gradient = CAGradientLayer()
        gradient.colors = [SLColor.shadowColor.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = .init(x: 0.0, y: 0.0)
        gradient.endPoint = .init(x: 0.0, y: 1.0)
        gradient.frame = .init(origin: .zero, size: .init(width: shadowView.bounds.width, height: 5))
        shadowView.layer.insertSublayer(gradient, at: 0)
        shadowView.alpha = 0
        shadowView.backgroundColor = SLColor.shadowColor
        
        // tableView
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = .clear
        tableView.backgroundColor = .clear
        
        let footerView = UIView(frame: .init(origin: .zero, size: .init(width: tableView.bounds.width, height: 44)))
        let simpleLoginLabel = UILabel(frame: .zero)
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        simpleLoginLabel.text = version != nil ? "SimpleLogin v\(version!)" : "SimpleLogin"
        simpleLoginLabel.textColor = .lightGray
        simpleLoginLabel.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        footerView.addSubview(simpleLoginLabel)
        simpleLoginLabel.fillSuperview(padding: UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20))
        
        tableView.tableFooterView = footerView
        
        LeftMenuOptionTableViewCell.register(with: tableView)
        SeparatorTableViewCell.register(with: tableView)
    }
    
    private func bindUserInfo() {
        guard let userInfo = userInfo else {
            usernameLabel.text = nil
            statusLabel.text = nil
            return
        }
        
        usernameLabel.text = userInfo.name
        
        if userInfo.isPremium {
            statusLabel.text = "Premium"
            statusLabel.textColor = SLColor.premiumColor
            statusLabel.shadowColor = SLColor.premiumColor.withAlphaComponent(0.5)
        } else {
            statusLabel.text = "Upgrade"
            statusLabel.textColor = SLColor.titleColor
            statusLabel.shadowColor = SLColor.titleColor.withAlphaComponent(0.5)
        }
    }
}

// MARK: - UITableViewDataSource
extension LeftMenuViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let option = options[indexPath.section][indexPath.row]
        
        if option != .separator {
            return UITableView.automaticDimension
        }
        
        return 1 // separator cell
    }
}

// MARK: - UITableViewDelegate
extension LeftMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let option = options[indexPath.section][indexPath.row]
        
        switch option {
        case .alias: delegate?.didSelectAlias()
        case .aliasDirectory: delegate?.didSelectDirectory()
        case .customDomains: delegate?.didSelectCustomDomain()
        case .settings: delegate?.didSelectSettings()
        case .about: delegate?.didSelectAbout()
        case .separator: return
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = options[indexPath.section][indexPath.row]
        
        if option != .separator {
            let cell = LeftMenuOptionTableViewCell.dequeueFrom(tableView, forIndexPath: indexPath)
            
            cell.bind(with: option)
            return cell
        }
        
        return SeparatorTableViewCell.dequeueFrom(tableView, forIndexPath: indexPath)
    }
}

// MARK: - UIScrollViewDelegate
extension LeftMenuViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Animate shadowView's alpha base on tableView's contentOffset.y
        guard scrollView.contentOffset.y > 0 else { return }
        shadowView.alpha = scrollView.contentOffset.y / 44
    }
}
