from kivy.uix.popup import Popup
from kivy.uix.gridlayout import GridLayout

class Settings(object):

	popup = ''
	layout = GridLayout()
	title = 'Settings'

	def __init__(self, **kwargs):
		self.layout.orientation = 'vertical'
		self.layout.clear_widgets()
		self.layout.cols = 2
		self.layout.padding = [15, 15]
		self.layout.row_default_height = 30
		self.layout.row_force_default = True
		self.layout.spacing = [10, 10]
		self.popup = Popup(title=self.title, content=self.layout, size_hint=(0.9, 0.9))

	def show(self, *args):
		self.popup.open()

	def dismiss(self, *args):
		self.popup.dismiss()

	def clear(self, *args):
		self.layout.clear_widgets()

	def add_widget(self, widget):
		self.layout.add_widget(widget)

	def set_title(self, title):
		self.title = title
		self.popup.title = self.title
