//
//  ViewController.swift
//  SolarTestInterview
//

import UIKit

typealias ResponseData = [InstructionElement]

struct InstructionElement: Codable {
    let category: String
    let contents: [Content]
}

struct Content: Codable {
    let title, description: String
}

class ViewController: UIViewController {

    private var dataInstruction = [InstructionElement]()
    private var indexCollapsed: [IndexPath: Bool] = [:]
    
    @IBOutlet private weak var instructionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataInstruction = fetchDataInstruction() ?? []
        
        instructionTableView.delegate = self
        instructionTableView.dataSource = self
        
        instructionTableView.register(UINib(nibName: "InstructiontCell", bundle: nil), forCellReuseIdentifier: "InstructiontCellID")
    }

    private func fetchDataInstruction() -> [InstructionElement]? {
        if let url = Bundle.main.url(forResource: "SolarIOSInterview", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    private func getEstHeight(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: width,
                                                  height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataInstruction.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataInstruction[section].contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = instructionTableView.dequeueReusableCell(withIdentifier: "InstructiontCellID", for: indexPath) as? InstructiontCell else {
            return UITableViewCell()
        }
        let data = dataInstruction[indexPath.section].contents[indexPath.row]
        let isCollapsed = indexCollapsed[indexPath] ?? true
        cell.setupData(title: "\(indexPath.row + 1). \(data.title)",
                       content: data.description,
                       isCollapse: isCollapsed)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0,
                                        y: 0,
                                        width: tableView.frame.width,
                                        height: 20))
        view.backgroundColor = .clear
        
        let lbl = UILabel(frame: CGRect(x: 8,
                                        y: 0,
                                        width: view.frame.width,
                                        height: 20))
        
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        lbl.textColor = UIColor(hex: "#141315")?.withAlphaComponent(0.9)
        lbl.text = dataInstruction[section].category
        view.addSubview(lbl)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = dataInstruction[indexPath.section].contents[indexPath.row]
        let isCollapsed = indexCollapsed[indexPath] ?? true
        
        let titleEstHeight = getEstHeight(text: data.title,
                                          font: UIFont.systemFont(ofSize: 15,
                                                                  weight: .medium),
                                          width: UIScreen.main.bounds.width - 112)
        let descEstHeight = getEstHeight(text: data.description,
                                          font: UIFont.systemFont(ofSize: 15,
                                                                  weight: .regular),
                                          width: UIScreen.main.bounds.width - 64)
        return isCollapsed
        ? titleEstHeight + 56
        : titleEstHeight + descEstHeight + 68
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexCollapsed[indexPath] = !(indexCollapsed[indexPath] ?? true)
        instructionTableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}
