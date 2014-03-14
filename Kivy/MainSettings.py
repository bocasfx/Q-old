from kivy.uix.popup import Popup
from kivy.uix.label import Label
from kivy.uix.floatlayout import FloatLayout

class MainSettings(object):

	popup = ''
	layout = FloatLayout()

	def __init__(self, **kwargs):
		label = Label(text='Settings')

		self.layout.add_widget(label)
		self.popup = Popup(title='Settings', content=self.layout, size_hint=(0.9, 0.9))

	def show(self, *args):
		self.popup.open()

	def dismiss(self, *args):
		self.popup.dismiss()
