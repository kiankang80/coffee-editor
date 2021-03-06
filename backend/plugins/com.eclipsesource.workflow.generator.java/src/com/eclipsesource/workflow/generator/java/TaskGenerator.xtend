package com.eclipsesource.workflow.generator.java

import com.eclipsesource.modelserver.coffee.model.coffee.AutomaticTask
import com.eclipsesource.modelserver.coffee.model.coffee.ManualTask
import com.eclipsesource.modelserver.coffee.model.coffee.Task
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

class TaskGenerator {
	String sourceDirectory
	
	new(String sourceDirectory) {
		this.sourceDirectory = sourceDirectory
	}

	def String toFileName(String packageName, String taskName) {
		'''«sourceDirectory»/«JavaUtil.getFilePath(packageName)»Abstract«JavaUtil.getJavaFileName(taskName)»'''
	}

	def String toFileContent(String packageName, String sourceFileName, Task task) {
		'''	
			// auto-generated from '«sourceFileName»' at «DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss").format(LocalDateTime.now)»
			package «packageName»;
			
			«IF task instanceof ManualTask»
				import «packageName».library.ManualWorkflowTask;
					
				public abstract class Abstract«JavaUtil.normalize(task.name)» extends ManualWorkflowTask {
			«ELSE»
				import «packageName».library.AutomaticWorkflowTask;
					
				public abstract class Abstract«JavaUtil.normalize(task.name)» extends AutomaticWorkflowTask {
			«ENDIF»
				@Override
				«IF task instanceof ManualTask»
				public String getActor() {
					return "«(task as ManualTask).actor»";
				}
				«ELSEIF task instanceof AutomaticTask»
				public String getComponent() {
					return "«(task as AutomaticTask).component»";
				}
				«ENDIF»
			
			
				@Override
				public int getDuration() {
					return «task.duration»;
				}
			
			}
		'''
	}
}
