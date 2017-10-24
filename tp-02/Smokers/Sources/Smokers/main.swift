import PetriKit
import SmokersLib

// Instantiate the model.
let model = createModel()

// Retrieve places model.
guard let r  = model.places.first(where: { $0.name == "r" }),
      let p  = model.places.first(where: { $0.name == "p" }),
      let t  = model.places.first(where: { $0.name == "t" }),
      let m  = model.places.first(where: { $0.name == "m" }),
      let w1 = model.places.first(where: { $0.name == "w1" }),
      let s1 = model.places.first(where: { $0.name == "s1" }),
      let w2 = model.places.first(where: { $0.name == "w2" }),
      let s2 = model.places.first(where: { $0.name == "s2" }),
      let w3 = model.places.first(where: { $0.name == "w3" }),
      let s3 = model.places.first(where: { $0.name == "s3" })
else {
    fatalError("invalid model")
}

// Create the initial marking.
let initialMarking: PTMarking = [r: 1, p: 0, t: 0, m: 0, w1: 1, s1: 0, w2: 1, s2: 0, w3: 1, s3: 0]

func countNode(markingGraph : MarkingGraph) -> Int {
  var seen = [markingGraph]
  var toVisit = [markingGraph]

  while let current = toVisit.popLast(){
  for (_, successor) in current.successors {
    if !seen.contains(where: { $0 === successor}){
      seen.append(successor)
      toVisit.append(successor)
    }
  }

}
return seen.count
}




// Create the marking graph (if possible).
if let markingGraph = model.markingGraph(from: initialMarking) {

  var twoSmokers = 0
  var twoIngr = 0

  var seen = [markingGraph]
  var toVisit = [markingGraph]

  while let current = toVisit.popLast(){
  for (_, successor) in current.successors {
    if !seen.contains(where: { $0 === successor}){
      seen.append(successor)
      toVisit.append(successor)
      var nbSmokers = 0
      for (p, j) in current.marking{
        if p == s1 || p == s2 || p == s3 {
          nbSmokers = nbSmokers + 1
        }
        if j > 2 {twoIngr = 1}
      }
      if nbSmokers > 1 {
        twoSmokers = 1
      }
      //print(current.marking[
    }
  }

}
  let nbNoeuds = seen.count
  print ("le graphe possède \(nbNoeuds) noeuds")
  if twoSmokers == 0 {
    print ("il ne peut y avoir deux personnes qui fumes en même temps")
  }else{
    print ("deux personnes peuvent fumer en même temps")
  }
  if twoIngr == 0 {
    print ("il ne peut y avoir deux fois le même ingrédients sur la table")
  }else{
    print ("il est possible d'avoir deux fois le même ingrédients sur la table")
  }
    // Write here the code necessary to answer questions of Exercise 4.
}
