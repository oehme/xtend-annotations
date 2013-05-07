package de.oehme.xtend.annotation.example

import de.oehme.xtend.annotation.events.FiresEvent
import java.awt.BorderLayout
import java.awt.Dimension
import java.util.Date
import javax.swing.JButton
import javax.swing.JFrame
import javax.swing.JTextField
import javax.swing.event.ChangeEvent
import javax.swing.event.ChangeListener

@FiresEvent(typeof(ChangeListener))
class MyTextBox extends JTextField {

	def override setText(String s) {
		super.setText(s);
 		fireStateChanged(new ChangeEvent(this));//<- generated by @FiresEvent
	}
}
 
class Window {
	def static void main(String[] args) {
		val textBox = new MyTextBox => [
			it.editable = false
		]
		val frame = new JFrame("Change test");
		frame.contentPane => [
			add(textBox, BorderLayout::CENTER)
			add(new JButton("OK") => [
				it.addActionListener[
					textBox.text = (new Date).toString
				]
			], BorderLayout::SOUTH)	
		]		
		frame => [
			defaultCloseOperation = JFrame::EXIT_ON_CLOSE
			visible = true
			size = new Dimension(300, 100)
			locationRelativeTo = null //center
		]
		textBox.addChangeListener[ //<- generated by @FiresEvent
			frame.title = textBox.text
		]
 		textBox.text = 'press ok';
	}
}
