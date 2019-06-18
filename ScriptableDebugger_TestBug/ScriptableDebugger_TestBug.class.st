Class {
	#name : #'ScriptableDebugger_TestBug',
	#superclass : #TestCase,
	#instVars : [
		'breakpointsBeforeTest'
	],
	#category : #'ScriptableDebugger_TestBug'
}

{ #category : #tests }
ScriptableDebugger_TestBug >> helperMethod13 [
	| a |
	a := 5.
	^ Point x: 5 y: '3' asInteger.
]

{ #category : #tests }
ScriptableDebugger_TestBug >> runCaseManaged [
	"This prevents the TestExecutionEnvironment from trying to kill processes created during the test. Without it, it adds on:do: contexts on the process, and this somehow makes the process answers true to isTerminating, triggering the protection against stepping terminating processes from DebugSessionPlus>>stepInto:
	It is not necessary to terminate processes created by ScriptableDebugger because these processes are not scheduled."
	^ self runCase.
]

{ #category : #running }
ScriptableDebugger_TestBug >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	breakpointsBeforeTest := VirtualBreakpoint all.
	VirtualBreakpoint all removeAll.
]

{ #category : #running }
ScriptableDebugger_TestBug >> tearDown [
	VirtualBreakpoint all removeAll.
	breakpointsBeforeTest do: [ :brkpt | VirtualBreakpoint all add: brkpt ].
]

{ #category : #tests }
ScriptableDebugger_TestBug >> testStep [
	| node scdbg |
	scdbg := ScriptableDebugger debug: [ self helperMethod13 ].
	scdbg step.
	node := scdbg currentNode.
	self assert: node isAssignment.
	self assert: node variable name equals: #a.
	scdbg step.
	node := scdbg currentNode.
	self assert: node isMessage.
	self assert: node selector equals: #asInteger.
]
