import PetriKit

public func createTaskManager() -> PTNet {
    // Places
    let taskPool    = PTPlace(named: "taskPool")
    let processPool = PTPlace(named: "processPool")
    let inProgress  = PTPlace(named: "inProgress")

    // Transitions
    let create      = PTTransition(
        named          : "create",
        preconditions  : [],
        postconditions : [PTArc(place: taskPool)])
    let spawn       = PTTransition(
        named          : "spawn",
        preconditions  : [],
        postconditions : [PTArc(place: processPool)])
    let success     = PTTransition(
        named          : "success",
        preconditions  : [PTArc(place: taskPool), PTArc(place: inProgress)],
        postconditions : [])
    let exec       = PTTransition(
        named          : "exec",
        preconditions  : [PTArc(place: taskPool), PTArc(place: processPool)],
        postconditions : [PTArc(place: taskPool), PTArc(place: inProgress)])
    let fail        = PTTransition(
        named          : "fail",
        preconditions  : [PTArc(place: inProgress)],
        postconditions : [])

    // P/T-net
    return PTNet(
        places: [taskPool, processPool, inProgress],
        transitions: [create, spawn, success, exec, fail])
}


public func createCorrectTaskManager() -> PTNet {
    // Places
       let taskPool    = PTPlace(named: "taskPool")
    let processPool = PTPlace(named: "processPool")
    let inProgress  = PTPlace(named: "inProgress")
    let availableTask = PTPlace(named: "availableTask") // Je créée une nouvelle place qui contient le nombre de tâches pas encore gérées par un processus

    // Transitions
    let create      = PTTransition(
        named          : "create",
        preconditions  : [],
        postconditions : [PTArc(place: taskPool), PTArc(place: availableTask)]) // Quand une nouvelle tâche est créée, le nombre de tâches disponible augmente
    let spawn       = PTTransition(
        named          : "spawn",
        preconditions  : [],
        postconditions : [PTArc(place: processPool)])
    let success     = PTTransition(
        named          : "success",
        preconditions  : [PTArc(place: taskPool), PTArc(place: inProgress)],
        postconditions : [])                //en cas de succès le nombre de tâches disponible ne change pas
    let exec       = PTTransition(
        named          : "exec",
        preconditions  : [PTArc(place: taskPool), PTArc(place: processPool), PTArc(place: availableTask)], // pour démarrer un processus il faut qu'il y aie une tâche disponible
        postconditions : [PTArc(place: taskPool), PTArc(place: inProgress)])
    let fail        = PTTransition(
        named          : "fail",
        preconditions  : [PTArc(place: inProgress)],
        postconditions : [PTArc(place: availableTask)])     // si un processus échoue, la tâche est de nouveau disponible, donc le nombre augmente de 1

    // P/T-net
    return PTNet(
        places: [taskPool, processPool, inProgress, availableTask],
        transitions: [create, spawn, success, exec, fail])
}
