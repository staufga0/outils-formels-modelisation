import PetriKit

public class MarkingGraph {

    public let marking   : PTMarking
    public var successors: [PTTransition: MarkingGraph]

    public init(marking: PTMarking, successors: [PTTransition: MarkingGraph] = [:]) {
        self.marking    = marking
        self.successors = successors
    }

}

public extension PTNet {

    public func markingGraph(from marking: PTMarking) -> MarkingGraph? {
        // Write here the implementation of the marking graph generation.
        var node = MarkingGraph(marking : marking)
        var toBuild = [node]
        var done = [MarkingGraph]()

        while let current = toBuild.popLast(){
            done.append(current)
            for t in self.transitions {
                if let m = t.fire(from: current.marking){
                  if toBuild.contains(where: {$0.marking == m}) {
                    current.successors[t] = toBuild.first(where: {$0.marking == m})
                  } else if done.contains(where: {$0.marking == m}) {
                    current.successors[t] = done.first(where: {$0.marking == m})
                  } else {
                    var newNode = MarkingGraph(marking : m)
                    toBuild.append(newNode)
                    current.successors[t] = newNode
                  }
                }

              }

        }
        return node
    }

}
