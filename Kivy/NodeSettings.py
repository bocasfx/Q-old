from kivy.logger import Logger
from kivy.uix.label import Label
from kivy.uix.textinput import TextInput
from kivy.uix.checkbox import CheckBox
from kivy.uix.slider import Slider
from functools import partial
from kivy.uix.popup import Popup
from kivy.uix.gridlayout import GridLayout

class NodeSettings(object):

	
	node = col1Width = 0.15
	col2Width = 1.0 - col1Width
	rowHeight = 0.1

	popup = ''
	layout = GridLayout()
	title = 'Settings'
	
	def __init__(self, **kwargs):
		super(NodeSettings, self).__init__(**kwargs)
		self.layout.orientation = 'vertical'
		self.layout.clear_widgets()
		self.layout.cols = 2
		self.layout.padding = [15, 15]
		self.layout.row_default_height = 30
		self.layout.row_force_default = True
		self.layout.spacing = [10, 10]
		self.popup = Popup(title=self.title, content=self.layout, size_hint=(0.9, 0.9))


	def show(self, node):
		Logger.debug('Displaying settings for node: ' + str(node.id))
		self.clear()

		self.node = node

		self.set_title('Node Settings')

		enabledCheckBoxLabel = Label(text='Enable', size_hint=(self.col1Width, self.rowHeight))
		enabledCheckBox = CheckBox(active=True)
		enabledCheckBox.bind(active=self.on_enabled_change)

		velocityLabel = Label(text='Velocity', size_hint=(self.col1Width, self.rowHeight))
		velocitySlider = Slider(min=0, max=127)
		velocitySlider.bind(value=self.on_slider_change)

		note = self.node.note
		Logger.debug('Note: ' + str(note))

		noteLabel = Label(text='Note', size_hint=(self.col1Width, self.rowHeight))
		noteTextInput = TextInput(text=str(self.node.note), multiline=False, size_hint=(self.col2Width, self.rowHeight))
		noteTextInput.bind(on_text_validate=partial(self.on_note_change, node))

		self.add_widget(enabledCheckBoxLabel)
		self.add_widget(enabledCheckBox)
		self.add_widget(velocityLabel)
		self.add_widget(velocitySlider)
		self.add_widget(noteLabel)
		self.add_widget(noteTextInput)

		self.popup.open()

	def on_note_change(self, *args):
		note = args[1].text
		Logger.debug('Note: ' + str(note))
		self.node.set_note(note)

	def on_slider_change(self, *args):
		velocity = args[1]
		self.node.set_velocity(velocity)

	def on_enabled_change(self, *args):
		enabled = args[1]
		self.node.set_enabled(enabled)

	def dismiss(self, *args):
		self.popup.dismiss()

	def clear(self, *args):
		self.layout.clear_widgets()

	def add_widget(self, widget):
		self.layout.add_widget(widget)

	def set_title(self, title):
		self.title = title
		self.popup.title = self.title
