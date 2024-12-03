//
//  CustomView.swift
//  MockAPI
//
//  Created by Muralidhar reddy Kakanuru on 12/3/24.
//

import UIKit

class CustomView: UIView {
    
    private let gitDataservice: GitData = DataGit.shared

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        fetchData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),

        ])
    }

    private func fetchData() {
        let url = "https://swapi.py4e.com/api/people/1/"
        gitDataservice.getData(url: url) {character in
            DispatchQueue.main.async {
                self.populateStackView(with: character)
            }
        }
    }

    private func populateStackView(with character: Character) {
        
        let properties: [(String, String)] = [
            ("Name", character.name),
            ("Height", "\(character.height)"),
            ("Mass", "\(character.mass)"),
            ("Hair Color", character.hair_color),
            ("Skin Color", character.skin_color),
            ("Eye Color", character.eye_color),
            ("Birth Year", character.birth_year),
            ("Gender", character.gender),
            ("Created", changeDateFormat(character.created))
        ]
        
        properties.forEach { addPropertyLabel(title: $0.0, value: $0.1) }
    }

    private func addPropertyLabel(title: String, value: String) {
        let label = UILabel()
        label.text = "\(title): \(value)"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        stackView.addArrangedSubview(label)
    }
}

private func changeDateFormat(_ givenDate: String) -> String {
        let input = DateFormatter()
        input.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        let output = DateFormatter()
        output.dateFormat = "dd-MM-yy"

        if let date = input.date(from: givenDate) {
            return output.string(from: date)
        } else {
            return givenDate
        }
    }
