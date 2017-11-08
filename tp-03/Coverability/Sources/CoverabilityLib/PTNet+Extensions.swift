import PetriKit

public extension PTNet {


    public func ConvMarking (from marking: CoverabilityMarking) -> PTMarking {    // pour pouvoir tirer des transitions je crée un PTMarking correspondant au CoverabilityMarking current.marking

      var m : PTMarking = [:]
      for p in self.places{
        m[p] = 1000
        for i in 0...900{
          if UInt(i) == marking[p]!{
            m[p] = UInt(i)
          }
        }
      }
      return m
    }

    public func ConvCovMarking (from marking: PTMarking) -> CoverabilityMarking {    // pour pouvoir tirer des transitions je crée un PTMarking correspondant au CoverabilityMarking current.marking

      var m : CoverabilityMarking = [:]     //je reconverti le PTMarking sortit de la transition en CoverabilityMarking
      for p in self.places{
        if marking[p]!<900{
          m[p] = .some(marking[p]!)
        }else{
          m[p] = .omega
        }
      }
      return m
    }

    public func coverabilityGraph(from marking: CoverabilityMarking) -> CoverabilityGraph {
        // Write here the implementation of the coverability graph generation.

        // Note that CoverabilityMarking implements both `==` and `>` operators, meaning that you
        // may write `M > N` (with M and N instances of CoverabilityMarking) to check whether `M`
        // is a greater marking than `N`.

        // IMPORTANT: Your function MUST return a valid instance of CoverabilityGraph! The optional
        // print debug information you'll write in that function will NOT be taken into account to
        // evaluate your homework.

        var node = CoverabilityGraph(marking : marking)
        var toBuild = [node]
        var done = [CoverabilityGraph]()

        while let current = toBuild.popLast(){
            done.append(current)

            let m1 = ConvMarking(from: current.marking)
            for t in self.transitions {
                if let m2 = t.fire(from: m1){
                  var m = ConvCovMarking(from: m2)
                  for ancetre in node{
                    if m > ancetre.marking{
                      for p in self.places{
                        if m[p]! > ancetre.marking[p]!{
                            m[p] = .omega
                        }
                      }
                    }
                  }
                  if toBuild.contains(where: {$0.marking == m}) {
                    current.successors[t] = toBuild.first(where: {$0.marking == m})
                  } else if done.contains(where: {$0.marking == m}) {
                    current.successors[t] = done.first(where: {$0.marking == m})
                  } else {
                    var newNode = CoverabilityGraph(marking : m)
                    toBuild.append(newNode)
                    current.successors[t] = newNode
                  }
                }
              }

        }
        return node
    }

}
