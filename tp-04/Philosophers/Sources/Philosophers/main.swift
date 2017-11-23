import PetriKit
import PhilosophersLib

do {
    enum C: CustomStringConvertible {
        case b, v, o

        var description: String {
            switch self {
            case .b: return "b"
            case .v: return "v"
            case .o: return "o"
            }
        }
    }

    func g(binding: PredicateTransition<C>.Binding) -> C {
        switch binding["x"]! {
        case .b: return .v
        case .v: return .b
        case .o: return .o
        }
    }

    let t1 = PredicateTransition<C>(
        preconditions: [
            PredicateArc(place: "p1", label: [.variable("x")]),
        ],
        postconditions: [
            PredicateArc(place: "p2", label: [.function(g)]),
        ])

    let m0: PredicateNet<C>.MarkingType = ["p1": [.b, .b, .v, .v, .b, .o], "p2": []]
    guard let m1 = t1.fire(from: m0, with: ["x": .b]) else {
        fatalError("Failed to fire.")
    }
    print(m1)
    guard let m2 = t1.fire(from: m1, with: ["x": .v]) else {
        fatalError("Failed to fire.")
    }
    print(m2)
}

print()

do {
    let philosophers = lockFreePhilosophers(n: 5)
    let mlf5 = philosophers.markingGraph(from: philosophers.initialMarking!)!.count
    print ("\(mlf5) marquages possibles dans le modèle des philosophes non bloquable à 5 philosophes")

     let lphilosophers = lockablePhilosophers(n: 5)
     let lphilograph = lphilosophers.markingGraph(from: lphilosophers.initialMarking!)
     let ml5 = lphilograph!.count
     print ("\(ml5) marquages possibles dans le modèle des philosophes bloquable à 5 philosophes")

     for n in lphilograph!{
       var lock = 1
       for t in lphilosophers.transitions{
         for _ in t.fireableBingings(from : n.marking){
           lock = 0
         }
       }
       if lock == 1 {
         print("le réseau et bloqué pour le marquage suivant : \(n.marking)")
       }
     }

    /*for m in philosophers.simulation(from: philosophers.initialMarking!).prefix(10) {
        print(m)
    }*/
    //philosophers.markingGraph(from: philosophers.initialMarking!)
    //print(philosophers.markingGraph(from: philosophers.initialMarking!)!.count)
}
