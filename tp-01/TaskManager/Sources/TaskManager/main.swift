import TaskManagerLib

let taskManager = createTaskManager()

//extraction des transitions

var create = taskManager.transitions.filter{ $0.name == "create" }[0]
var spawn = taskManager.transitions.filter{ $0.name == "spawn" }[0]
var exec = taskManager.transitions.filter{ $0.name == "exec" }[0]
var success = taskManager.transitions.filter{ $0.name == "success" }[0]
var fail = taskManager.transitions.filter{ $0.name == "fail" }[0]

//extraction des Places

var taskPool = taskManager.places.filter{ $0.name == "taskPool" }[0]
var processPool = taskManager.places.filter{ $0.name == "processPool" }[0]
var inProgress = taskManager.places.filter{ $0.name == "inProgress" }[0]


// Show here an example of sequence that leads to the described problem.
// For instance:
     var m1 = create.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
     var m2 = spawn.fire(from: m1!)
     var m3 = spawn.fire(from: m2!)
     var m4 = exec.fire(from: m3!)
     var m5 = exec.fire(from: m4!) // le deuxième processus commence avec la tâche déjà traitée, mais le système ne dit rien
     var m6 = success.fire(from: m5!) // la tâche disparait
     var m7 = success.fire(from: m6!) // le deuxième processus ne peut finir par un succès car il ne reste plus de tâche à traiter
//     ...

let correctTaskManager = createCorrectTaskManager()

//extraction des nouvelles transitions

create = correctTaskManager.transitions.filter{ $0.name == "create" }[0]
spawn = correctTaskManager.transitions.filter{ $0.name == "spawn" }[0]
exec = correctTaskManager.transitions.filter{ $0.name == "exec" }[0]
success = correctTaskManager.transitions.filter{ $0.name == "success" }[0]
fail = correctTaskManager.transitions.filter{ $0.name == "fail" }[0]

//extraction des nouvelles Places

taskPool = correctTaskManager.places.filter{ $0.name == "taskPool" }[0]
processPool = correctTaskManager.places.filter{ $0.name == "processPool" }[0]
inProgress = correctTaskManager.places.filter{ $0.name == "inProgress" }[0]
var availableTask = correctTaskManager.places.filter{ $0.name == "availableTask" }[0]

// Show here that you corrected the problem.
// For instance:
// avec la même séquence, le deuxième processus ne peux pas démarrer car la place availableTask est vide
     m1 = create.fire(from: [taskPool: 0, processPool: 0, inProgress: 0, availableTask: 0])
     m2 = spawn.fire(from: m1!)
     m3 = spawn.fire(from: m2!)
     m4 = exec.fire(from: m3!)
//     let m5 = exec.fire(from: m4!) le processus ne pourrai pas démarrer
     m5 = fail.fire(from: m4!) // si le premier processus échoue le deuxième peut reprendre la tâche
     m6 = exec.fire(from: m5!) // le deuxième processus peut démarrer puisque la tâche est de nouveau disponible
     m7 = success.fire(from: m6!) // Le processus peut se terminer avec un succès
