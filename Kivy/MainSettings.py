from kivy.uix.popup import Popup
from kivy.uix.gridlayout import GridLayout
from kivy.logger import Logger
from kivy.uix.label import Label
from kivy.uix.checkbox import CheckBox
from functools import partial

class MainSettings(object):

	popup = ''
	layout = GridLayout()
	title = 'Settings'

	col1Width = 0.50
	rowHeight = 0.1

	def __init__(self, **kwargs):
		super(MainSettings, self).__init__(**kwargs)
		self.layout.orientation = 'vertical'
		self.layout.clear_widgets()
		self.layout.cols = 3
		self.layout.padding = [15, 15]
		self.layout.row_default_height = 30
		self.layout.row_force_default = True
		self.layout.spacing = [10, 10]
		self.popup = Popup(title=self.title, content=self.layout, size_hint=(0.9, 0.9))	

	def show(self, streams):
		self.clear()
		index = 0
		indexHeaderLabel = Label(text='Stream')
		activeHeaderLabel = Label(text='Active')
		speedHeaderLabel = Label(text='Particle speed')

		self.add_widget(indexHeaderLabel)
		self.add_widget(activeHeaderLabel)
		self.add_widget(speedHeaderLabel)

		for stream in streams:
			Logger.debug("Got stream: " + str(stream))
			streamIndexLabel = Label(text=str(index), size_hint=(self.col1Width, self.rowHeight))

			activeCheckbox = CheckBox(active=stream.get_active())
			activeCheckbox.bind(active=partial(self.on_active_change, stream))

			particleSpeedCheckBox = CheckBox(active=True)
			particleSpeedCheckBox.bind(active=partial(self.on_particle_speed_change, stream))
			self.add_widget(streamIndexLabel)
			self.add_widget(activeCheckbox)
			self.add_widget(particleSpeedCheckBox)
			index = index + 1
		self.popup.open()

	def on_particle_speed_change(self, *args):
		Logger.debug('Args: ' + str(args))
		stream = args[0]
		enabled = args[2]
		stream.enable_speed(enabled)

	def on_active_change(self, *args):
		pass

	def add_widget(self, widget):
		self.layout.add_widget(widget)

	def clear(self, *args):
		self.layout.clear_widgets()