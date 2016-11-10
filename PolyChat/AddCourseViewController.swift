//
//  AddCourseViewController.swift
//  PolyChat
//
//  Created by Bonilla, Stefan on 7/13/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class AddCourseViewController: UIViewController, UITextFieldDelegate {

    var courseService = CourseServiceFactory.sharedInstance
    @IBOutlet weak var courseNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        // TODO: Load course into Firebase
        let courseName = courseNameTextField.text!
        let courseDict = ["name" : courseName]
        let course = Course(dictionary: courseDict as NSDictionary)
        
        if !isValidCourseName(courseName) {
            courseService?.addCourse(course, callback: { (string, error) in
                if let error = error {
                    print(error)
                } else {
                    // TODO: Make feedback for course added
                    print("Course \(course.name) added")
                }
            })
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func isValidCourseName(_ str: String) -> Bool {
        if(str.isEmpty) {
            return true
        }
        return (str.trimmingCharacters(in: CharacterSet.whitespaces) == "")
    }

}
