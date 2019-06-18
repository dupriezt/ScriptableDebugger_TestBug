Class {
	#name : #'BaselineOfScriptableDebugger_TestBug',
	#superclass : #BaselineOf,
	#category : #'BaselineOfScriptableDebugger_TestBug'
}

{ #category : #baselines }
BaselineOfScriptableDebugger_TestBug >> baseline: spec [
	<baseline>
	spec
		for: #common		
		do: [		
			"Dependency"
			spec
				baseline: 'ScriptableDebugger'
				with: [ spec repository: 'github://dupriezt/ScriptableDebugger' ].
			spec
				baseline: 'Chest'
				with: [ spec repository: 'github://dupriezt/Chest' ].
			"Packages"
			spec
				package: 'ScriptableDebugger_TestBug'.
		 ]

]
