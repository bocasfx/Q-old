from kivy.uix.popup import Popup
from kivy.uix.gridlayout import GridLayout

class MainSettings(object):

	popup = ''
	layout = GridLayout()
	title = 'Settings'

	def __init__(self, **kwargs):
		super(MainSettings, self).__init__(**kwargs)
		self.layout.orientation = 'vertical'
		self.layout.clear_widgets()
		self.layout.cols = 2
		self.layout.padding = [15, 15]
		self.layout.row_default_height = 30
		self.layout.row_force_default = True
		self.layout.spacing = [10, 10]
		self.popup = Popup(title=self.title, content=self.layout, size_hint=(0.9, 0.9))	

	def show(self, node):
		self.popup.open()