from kivy.uix.popup import Popup
from kivy.uix.label import Label
from kivy.uix.floatlayout import FloatLayout

class MainSettings():

	popup = ''
	visibility = 'hidden'
	layout = FloatLayout()

	def __init__(self, **kwargs):
		label = Label(text='Settings')

		self.layout.add_widget(label)
		self.popup = Popup(title='Settings', content=self.layout, size_hint=(0.9, 0.9))
		self.visibility = 'hidden'

	def show(self):
		self.popup.open()
		self.visibility = 'visible'

	def dismiss(self, *args):
		self.popup.dismiss()
		self.visibility = 'hidden'
