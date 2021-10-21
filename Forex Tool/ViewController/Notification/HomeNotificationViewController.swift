//
//  HomeNotificationViewController.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 18/10/2021.
//

import UIKit

class HomeNotificationViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    //
    let notificationVM = NotificationViewModel()
    var notification_2D:[[NotificationModel]] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        let nibCell = UINib(nibName: "NotificationTableViewCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "NotificationTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Notification".localized()
        
        notificationVM.getListNotification { success, listNotification in
            if success{
                guard let notifications = listNotification else {return}
                self.notification_2D = []
                var groupNotifi = [NotificationModel]()
                var firstDate = notifications.first?.date?.dateFormatter()
                
                for eachNotifi in notifications{
                    if eachNotifi.date?.dateFormatter() == firstDate{
                        groupNotifi.append(eachNotifi)
                    }else{
                        self.notification_2D.append(groupNotifi)
                        groupNotifi = []
                        groupNotifi.append(eachNotifi)
                        firstDate = eachNotifi.date?.dateFormatter()
                    }
                }
                if groupNotifi.count > 0{
                    self.notification_2D.append(groupNotifi)
                }
                self.tableView.reloadData()
            }
        }
    }
    //MARK: Helper Method
    

}
extension HomeNotificationViewController:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return notification_2D.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notification_2D[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        let notification = notification_2D[indexPath.section][indexPath.row]
        cell.configCell(item: notification)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9647058824, blue: 1, alpha: 1)
        let title = UILabel()
        title.textColor = #colorLiteral(red: 0.4823529412, green: 0.4823529412, blue: 0.4823529412, alpha: 1)
        title.text = notification_2D[section].first?.date?.dateFormatter()
        title.font = UIFont(name: "Roboto-Regular", size: 16)
        headerView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        title.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let targetVC = DetailNotificationViewController()
        targetVC.notificationItem = notification_2D[indexPath.section][indexPath.row]
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
}
