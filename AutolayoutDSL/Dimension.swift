//
//  Dimension.swift
//  AutolayoutDSL
//
//  Created by Robert Böhnke on 17/06/14.
//  Copyright (c) 2014 Robert Böhnke. All rights reserved.
//

import Foundation

enum Dimension : Property {
    case Width(UIView)
    case Height(UIView)

    var view: UIView {
        switch (self) {
            case let .Width(view): return view
            case let .Height(view): return view
        }
    }

    var attribute: NSLayoutAttribute {
        switch (self) {
            case .Width(_): return NSLayoutAttribute.Width
            case .Height(_): return NSLayoutAttribute.Height
        }
    }
}

struct Expression {
    let dimension: Dimension
    var coefficients: Coefficients

    init(_ dimension: Dimension, _ coefficients: Coefficients) {
        self.dimension = dimension
        self.coefficients = coefficients
    }
}

// Equality

@infix func ==(lhs: Dimension, rhs: Float) {
    apply(lhs, coefficients: Coefficients(1, rhs))
}

@infix func ==(lhs: Float, rhs: Dimension) {
    rhs == lhs
}

@infix func ==(lhs: Dimension, rhs: Expression) {
    apply(lhs, coefficients: rhs.coefficients, to: rhs.dimension)
}

@infix func ==(lhs: Expression, rhs: Dimension) {
    rhs == lhs
}

@infix func ==(lhs: Dimension, rhs: Dimension) {
    apply(lhs, to: rhs)
}

// Inequality

@infix func <=(lhs: Dimension, rhs: Float) {
    apply(lhs, coefficients: Coefficients(1, rhs), relation: NSLayoutRelation.LessThanOrEqual)
}

@infix func <=(lhs: Float, rhs: Dimension) {
    apply(rhs, coefficients: Coefficients(1, lhs), relation: NSLayoutRelation.GreaterThanOrEqual)
}

@infix func >=(lhs: Dimension, rhs: Float) {
    apply(lhs, coefficients: Coefficients(1, rhs), relation: NSLayoutRelation.GreaterThanOrEqual)
}

@infix func >=(lhs: Float, rhs: Dimension) {
    apply(rhs, coefficients: Coefficients(1, lhs), relation: NSLayoutRelation.LessThanOrEqual)
}

@infix func <=(lhs: Dimension, rhs: Expression) {
    apply(lhs, coefficients: rhs.coefficients, to: rhs.dimension, relation: NSLayoutRelation.LessThanOrEqual)
}

@infix func <=(lhs: Expression, rhs: Dimension) {
    apply(rhs, coefficients: lhs.coefficients, to: lhs.dimension, relation: NSLayoutRelation.GreaterThanOrEqual)
}

@infix func >=(lhs: Dimension, rhs: Expression) {
    return rhs <= lhs
}

@infix func >=(lhs: Expression, rhs: Dimension) {
    return rhs <= lhs}

// Addition

@infix func +(c: Float, rhs: Dimension) -> Expression {
    return Expression(rhs, Coefficients(1, c))
}

@infix func +(lhs: Dimension, rhs: Float) -> Expression {
    return rhs + lhs
}

@infix func +(c: Float, rhs: Expression) -> Expression {
    return Expression(rhs.dimension, rhs.coefficients + c)
}

@infix func +(lhs: Expression, rhs: Float) -> Expression {
    return rhs + lhs
}

// Multiplication

@infix func *(m: Float, rhs: Dimension) -> Expression {
    return Expression(rhs, Coefficients(m, 0))
}

@infix func *(lhs: Dimension, rhs: Float) -> Expression {
    return rhs * lhs
}

@infix func *(m: Float, rhs: Expression) -> Expression {
    return Expression(rhs.dimension, rhs.coefficients * m)
}

@infix func *(lhs: Expression, rhs: Float) -> Expression {
    return rhs * lhs
}
