from kivy.uix.popup import Popup
from kivy.uix.label import Label
from kivy.logger import Logger
from kivy.uix.floatlayout import FloatLayout
from kivy.uix.button import Button

class MainSettings():

	popup = ''
	visibility = 'hidden'
	layout = FloatLayout()

	def __init__(self, **kwargs):
		label = Label(text='Settings')

		self.btn_dismiss = Button(text='Dismiss')
		self.btn_dismiss.bind(on_release=self.dismiss)

		self.layout.add_widget(label)
		self.layout.add_widget(self.btn_dismiss)

		self.popup = Popup(title='Settings', content=self.layout, size_hint=(0.9, 0.9))
		self.visibility = 'hidden'

	def open(self):
		self.popup.open()
		self.visibility = 'visible'

	def dismiss(self, *args):
		self.popup.dismiss()
		self.visibility = 'hidden'

	def toggle(self):
		if self.visibility == 'hidden':
			self.open()
		else:
			self.dismiss()