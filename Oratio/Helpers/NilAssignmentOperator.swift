precedencegroup NilAssignmentPrecedence {
    lowerThan: NilCoalescingPrecedence
    assignment: true
}

infix operator ??=: NilAssignmentPrecedence

func ??= <T>(lhs: inout T, rhs: T?) {
    if let rhs = rhs {
        lhs = rhs
    }
}
