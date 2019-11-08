Class {
	#name : #RuRulesTest,
	#superclass : #RuTestCase,
	#instVars : [
		'rootRule'
	],
	#category : #'Rules-Tests'
}

{ #category : #running }
RuRulesTest >> buildRootRule [
	rootRule := self rootRule.
	self addSomeRulesTo: rootRule
]

{ #category : #helpers }
RuRulesTest >> rulesToTest [
	^ rootRule listAllRules
]

{ #category : #running }
RuRulesTest >> setUp [
	super setUp.
	self buildRootRule
]

{ #category : #tests }
RuRulesTest >> testNumberOfRules [
	self assert: self rulesToTest size equals: 4
]

{ #category : #tests }
RuRulesTest >> testRuleInfo [
	| rule |
	rule := self rulesToTest first.
	self assert: rule totalRemediationTime equals: (Duration minutes: 15).
	self assert: rule workingHours equals: 8.
	self assert: rule label equals: 'Long Containers'.
	self assert: rule explanation equals: 'Containers should not be longer than 6 lines of code'.
	self assert: rule remediationTimeInDays equals: 1 / 96
]

{ #category : #tests }
RuRulesTest >> testRuleResults [
	| expectedResults n |
	expectedResults := #(3 0 2 1).
	n := 1.
	self rulesToTest
		do: [ :each | 
			self assert: each computeResult size equals: (expectedResults at: n).
			n := n + 1 ]
]

{ #category : #tests }
RuRulesTest >> testRuleResultsType [
	self rulesToTest do: [ :each | self assert: each result isArray ]
]

{ #category : #tests }
RuRulesTest >> testRuleType [
	self assert: (self rulesToTest first isKindOf: RuRule)
]

{ #category : #tests }
RuRulesTest >> testRulesComputationErrorRaiseError [
	"An error should not return a default value as -1"

	self
		should: [ 
			self rulesToTest first copy
				ruleBlock: [ Error signal ];
				totalRemediationTime ]
		raise: RuUnaplicableRuleException
]