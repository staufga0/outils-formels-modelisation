import TaskManagerLib

let taskManager = createTaskManager()

// Show here an example of sequence that leads to the described problem.
// For instance:
     let m1 = create.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
     let m2 = spawn.fire(from: m1!)
     let m3 = spawn.fire(from: m2!)
     let m4 = exec.fire(from: m3!)
     let m5 = exec.fire(from: m4!) // le deuxième processus commence avec la tâche déjà traitée, mais le système ne dit rien
     let m6 = success.fire(from: m5!) // la tâche disparait
     let m7 = success.fire(from: m6!) // le deuxième processus ne peut finir par un succès car il ne reste plus de tâche à traiter 
//     ...

let correctTaskManager = createCorrectTaskManager()

// Show here that you corrected the problem.
// For instance:
// avec la même séquence, le deuxième processus ne peux pas démarrer car la place availableTask est vide
     let m1 = create.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
     let m2 = spawn.fire(from: m1!)
     let m3 = spawn.fire(from: m2!)
     let m4 = exec.fire(from: m3!)
//     let m5 = exec.fire(from: m4!) le processus ne pourrai pas démarrer
     let m5 = fail.fire(from: m4!) // si le premier processus échoue le deuxième peut reprendre la tâche
     let m6 = exec.fire(from: m5!) // le deuxième processus peut démarrer puisque la tâche est de nouveau disponible
     let m7 = success.fire(from: m6!) // Le processus peut se terminer avec un succès
