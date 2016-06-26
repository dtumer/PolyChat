//
//  FirebaseInitMockDatabase.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/24/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class FirebaseInitMockDatabase {
    //mock classes
    let classes = [
        //cpe classes
        "CPE-101",
        "CPE-102",
        "CPE-103",
        "CPE-357",
        "CPE-458",
        "CPE-321",
        
        //math classes
        "MATH-141",
        "MATH-142",
        "MATH-143",
        
        //philosophy classes
        "PHIL-321",
        "PHIL-201",
        
        //psychology classes
        "PSY-201",
        "PSY-202",
        
        //english classes
        "ENGL-149",
        "ENGL-134",
    ]
    
    //mock students
    let students = [
        "dtumer@calpoly.edu",
    ]
    
    //initializes mock database with initial user values and classes
    func initMockDB() {
//        let dataService = DataServiceFactory.getDataService(Constants.CURRENT_SERVICE_KEY)
        
        //for each student create a student object
        for _ in students {
            //insert students into the users menu
            //dataService.insertData(Constants.usersDBKey, id: nil, data: createStudent(student))
        }
    }
    
    //creates a student
    private func createStudent(email: String) -> [String:AnyObject] {
        var student: [String: AnyObject] = [:]
        
        student["email"] = email
        student["courses"] = enrollStudent()
        
        return student
    }
    
    //enrolls a student in multiple classes
    private func enrollStudent() -> [String] {
        let numCourses = Int(arc4random_uniform(2)) + 3 //generates a random number between 3 and 4
        var courses: [String] = []
        
        for _ in 0..<numCourses {
            let ndx = Int(arc4random_uniform(UInt32(self.classes.count)))
            courses.append(createSection(Int(ndx)))
        }
        
        return courses
    }
    
    //appends a section to the course
    private func createSection(ndx: Int) -> String {
        let section = Int(arc4random_uniform(6))
        
        return self.classes[ndx] + "-0" + String(section)
    }
}