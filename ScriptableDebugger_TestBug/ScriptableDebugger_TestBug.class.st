"
Bits of playground script

""Capture the execution comand running the test and put them in chest before running the following, or you'll lock your image""""

(Chest at: 1) executeCommand.
(Chest at: 2) executeCommand.
dbg1 := ScriptableDebugger debug: [ (Chest at: 1) executeCommand ].
dbg2 := ScriptableDebugger debug: [ (Chest at: 2) executeCommand ].
dbg1 stepUntil: [ dbg1 method == (ScriptableDebugger_TestBug >>#testStep)].
dbg2 stepUntil: [ dbg2 method == (ScriptableDebugger_TestBug >>#testStep)].
[ dbg1 currentNode == dbg2 currentNode ] whileTrue: [ dbg1 step. dbg2 step. ]. dbg1 method. dbg2 method.
p1 := (dbg1 temporaries at: #aProcess).
p2 := (dbg2 temporaries at: #aProcess).
[(p1 suspendedContext method) == (p2 suspendedContext method)] whileTrue: [ dbg1 step. dbg2 step. ].
dbg1 currentNode. dbg2 currentNode.
(p1 suspendedContext sourceNodeExecuted). (p2 suspendedContext sourceNodeExecuted).
[ p1 suspendedContext selector = #on:do: ] whileFalse: [ dbg1 step ].
dbg1 stack. dbg1 currentNode. p1 suspendedContext sourceNodeExecuted.
dbg1 stepUntil: [ dbg1 method == (ScriptableDebugger_TestBug >>#testStep)]. dbg1 currentNode.
p1 suspendedContext sourceNodeExecuted.
[p1 suspendedContext selector = #testStep] whileFalse: [ p1 step ].
p1 suspendedContext sourceNodeExecuted.
p1 suspendedContext stack.
"
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
