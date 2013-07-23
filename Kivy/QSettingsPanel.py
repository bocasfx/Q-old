
from kivy.uix.settings import Settings, SettingItem, SettingsPanel, SettingTitle
from kivy.uix.button import Button
from kivy.logger import Logger

class QSettingsPanel():
	def __init__(self, **kwargs):
		# super(QSettingsPanel, self).__init__(**kwargs)

		self.medium = kwargs.get('medium')
		self.settings_panel = Settings()

		self.add_panel()
		panel = SettingsPanel(title="Customized", settings=self) #create instance of left side panel
		item1 = SettingItem(panel=panel, title="easy :)", desc="press that button to see it your self", settings = self) #create instance of one item in left side panel
		item2 = SettingTitle(title="Kivy is awesome") #another widget in left side panel
		button = Button(text="Add one more panel")

		item1.add_widget(button) #add widget to item1 in left side panel
		button.bind(on_release=self.add_panel) #bind that button to function

		panel.add_widget(item1) # add item1 to left side panel
		panel.add_widget(item2) # add item2 to left side panel
		self.settings_panel.add_widget(panel) #add left side panel itself to the settings menu

		# return self.settings_panel # show the settings interface

	def add_panel(self):
		panel = SettingsPanel(title="I like trains", settings=self)
		self.settings_panel.add_widget(panel)
