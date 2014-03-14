from MainSettings import MainSettings
from kivy.logger import Logger
from kivy.uix.label import Label
from kivy.uix.textinput import TextInput

class NodeSettings(MainSettings):
	
	def __init__(self, **kwargs):
		super(NodeSettings, self).__init__(**kwargs)

	def show(self, node):
		Logger.debug('Displaying settings for node: ' + str(node.id))
		self.layout.clear_widgets()
		
		label2 = Label(text='Settings2')
		self.layout.add_widget(label2)

		textinput = TextInput(text='', multiline=False, size=("200px", "30px"))
		textinput.bind(on_text_validate=self.on_settings_update)
		self.layout.add_widget(textinput)

		return super(NodeSettings, self).show(self)

	def on_settings_update(self):
		Logger.debug("on_settings_update.")
