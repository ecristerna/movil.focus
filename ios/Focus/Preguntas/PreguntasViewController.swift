//
//  PreguntasViewController.swift
//  Focus
//
//  Created by Eduardo Cristerna on 01/08/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

let PREGUNTA_CELL = "PreguntaViewCell"

class PreguntasViewController: UITableViewController {
    
    var id: Int?
    var preguntas: [Pregunta]?
    var respuesta: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: PREGUNTA_CELL, bundle: nil), forCellReuseIdentifier: PREGUNTA_CELL)
        self.tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.dismissKeyboard()
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Video
    // -----------------------------------------------------------------------------------------------------------
    
    @IBAction func dismissVideoPlayer(segue: UIStoryboardSegue) {
        self.dismissSegueSourceViewController(segue)
    }
    
    func presentVideo() {
        let moviePlayerController = UIStoryboard(name: "Preguntas", bundle: nil).instantiateViewControllerWithIdentifier("Video")
        self.presentViewController(moviePlayerController, animated: true, completion: nil)
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - TableView
    // -----------------------------------------------------------------------------------------------------------
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Pregunta \(section + 1)"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.preguntas?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PREGUNTA_CELL, forIndexPath: indexPath) as! PreguntaViewCell
        cell.pregunta = self.preguntas![indexPath.section]
        cell.configureForPregunta()
        cell.selectionStyle = .None
        cell.videoHandler = #selector(self.presentVideo)
        
        return cell
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Save Answers
    // -----------------------------------------------------------------------------------------------------------
    
    @IBAction func doneAnswering(sender: AnyObject) {
        self.dismissKeyboard()
        self.respuesta = ""
        
        for pregunta in self.preguntas! {
            if (pregunta.tipo == TipoPregunta.Multiple.rawValue) {
                for i in 0..<pregunta.opciones.count {
                    pregunta.respuesta += pregunta.selectedOptions[i] ? "\(pregunta.opciones[i])&" : ""
                }
            }
            
            if (pregunta.respuesta.isEmpty) {
                return self.missingAnswerAlert(pregunta.numPregunta)
            }
            
            self.respuesta += "\(pregunta.respuesta)|"
        }
        
        self.saveAnswers()
    }
    
    func missingAnswerAlert(numPregunta: Int) {
        let alertTitle = "La pregunta \(numPregunta) no ha sido respondida."
        let alertMesssage = "Por favor, responda a todas las preguntas e intente enviar las respuestas nuevamente."
        
        self.presentAlertWithTitle(alertTitle, withMessage: alertMesssage, withButtonTitles: ["OK"], withButtonStyles: [.Cancel], andButtonHandlers: [nil])
    }
    
    func saveAnswers() {
        let parameters: [String : AnyObject] = [
            "id" : self.id!,
            "respuestas" : self.respuesta
        ]
        
        Controller.requestForAction(.SAVE_ANSWERS, withParameters: parameters, withSuccessHandler: self.successHandler, andErrorHandler: self.errorHandler)
    }
    
    func successHandler(response: NSDictionary) {
        let alertTitle = (response["status"] as? String == "SUCCESS") ? "Respuestas Guardadas" : "Error"
        let alertMesssage = (response["status"] as? String == "SUCCESS") ? "Gracias por responder la encuesta." : "No pudimos guardar tus respuestas en este momento."
        
        func firstBlock(action: UIAlertAction) {
            self.performSegueWithIdentifier("doneAnswering", sender: nil)
        }
        
        self.presentAlertWithTitle(alertTitle, withMessage: alertMesssage, withButtonTitles: ["OK"], withButtonStyles: [.Cancel], andButtonHandlers: [firstBlock])
    }
    
    func errorHandler(response: NSDictionary) {
        self.successHandler(response)
        print(response["error"])
    }
    
}
