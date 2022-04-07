//
//  AddParticipantsViewController.swift
//  MirrorflyUIkit
//
//  Created by John on 23/11/21.
//

import UIKit
import FlyCommon

class AddParticipantsViewController: UIViewController {
    
    let groupCreationViewModel = GroupCreationViewModel()
    var groupCreationDeletgate : GroupCreationDelegate?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var participantTableView: UITableView!
    var participants = [ProfileDetails]()
    var searchedParticipants = [ProfileDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpTableView()
        getContacts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resetSearch()
        participantTableView.reloadData()
    }
    
    func setUpUI() {
        setUpStatusBar()
        searchBar.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            participantTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + participantTableView.rowHeight + 30, right: 0)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        participantTableView.contentInset = .zero
    }
    
    func setUpTableView() {
        participantTableView.delegate = self
        participantTableView.dataSource = self
        participantTableView.register(UINib(nibName: Identifiers.participantCell , bundle: .main), forCellReuseIdentifier: Identifiers.participantCell)
        participantTableView.register(UINib(nibName: Identifiers.noResultFound , bundle: .main),forCellReuseIdentifier: Identifiers.noResultFound)
    }
    
    
    @IBAction func didBackTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func didNextTap(_ sender: Any) {
        
        if groupCreationViewModel.checkMaximumParticipant(selectedParticipant: GroupCreationData.participants) {
            AppAlert.shared.showToast(message: maximumGroupUsers)
            return
        }
        
        if groupCreationViewModel.checkMinimumParticipant(selectedParticipants: GroupCreationData.participants) {
            print("groupName \(GroupCreationData.groupName) imagePath\(GroupCreationData.groupImageLocalPath) selectedparticipantCount \(GroupCreationData.participants.count)")
            performSegue(withIdentifier: Identifiers.groupCreationPreview, sender: nil)
        } else {
            AppAlert.shared.showToast(message: atLeastTwoParticipant)
        }
    }
    
    func getContacts() {
        groupCreationViewModel.getContacts(fromServer: false, completionHandler: { [weak self] (profiles, error)  in
            if error != nil {
                return
            }
            self?.participants = (profiles?.sorted{ $0.name.capitalized < $1.name.capitalized }) ?? []
            self?.searchedParticipants = (profiles?.sorted{ $0.name.capitalized < $1.name.capitalized }) ?? []  
            self?.participantTableView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.groupCreationPreview {
            let groupCreationPreviewController = segue.destination as! GroupCreationPreviewController
            groupCreationPreviewController.groupCreationDeletgate = groupCreationDeletgate
        }
    }
}

// TableViewDelegate
extension AddParticipantsViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchedParticipants.count > 0 {
            return searchedParticipants.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchedParticipants.count > 0 {
            let cell = (tableView.dequeueReusableCell(withIdentifier: Identifiers.participantCell, for: indexPath) as? ParticipantCell)!
            let profileDetail = searchedParticipants[indexPath.row]
            cell.nameUILabel?.text = profileDetail.name
            cell.statusUILabel?.text = profileDetail.status
            let hashcode = profileDetail.name.hashValue
            let color = getColor(userName: profileDetail.name)
            cell.removeButton?.isHidden = true
            cell.removeIcon?.isHidden = true
            cell.setImage(imageURL: profileDetail.image, name: profileDetail.name, color: color ?? .gray)
            cell.checkBoxImageView?.image = GroupCreationData.participants.contains(where: {$0.jid == profileDetail.jid}) ?  UIImage(named: ImageConstant.ic_checked) : UIImage(named: ImageConstant.ic_check_box)
            cell.setTextColorWhileSearch(searchText: searchBar.text ?? "", profileDetail: profileDetail)
            cell.emptyView?.isHidden = true
            return cell
        } else {
            let cell = (tableView.dequeueReusableCell(withIdentifier: Identifiers.noResultFound, for: indexPath) as? NoResultFoundCell)!
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileDetail = searchedParticipants[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as! ParticipantCell
        let jid = profileDetail.jid ?? ""
        if GroupCreationData.participants.contains(where: {$0.jid == jid}) {
            cell.checkBoxImageView?.image = UIImage(named: ImageConstant.ic_check_box)
            GroupCreationData.participants = groupCreationViewModel.removeSelectedParticipantJid(selectedParticipants: GroupCreationData.participants, participant: profileDetail)
        } else {
            cell.checkBoxImageView?.image = UIImage(named: ImageConstant.ic_checked)
            GroupCreationData.participants.append(profileDetail)
        }
    }
    
    func resetSearch() {
        searchBar.text = ""
        searchedParticipants = groupCreationViewModel.searchContacts(text: "", contacts: participants)
        searchBar.resignFirstResponder()
        dismissKeyboard()
    }
    
    private func getColor(userName : String) -> UIColor {
        return ChatUtils.getColorForUser(userName: userName)
    }
}

extension AddParticipantsViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        searchedParticipants = groupCreationViewModel.searchContacts(text: searchText.trim(), contacts: participants)
        self.participantTableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
        searchedParticipants = participants
        self.participantTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
}
