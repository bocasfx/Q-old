from MainSettings import MainSettings
from kivy.logger import Logger

class NodeSettings(MainSettings):
	
	def __init__(self, **kwargs):
		super(NodeSettings, self).__init__(**kwargs)

	def show(self, id):
		Logger.debug('Displaying settings for node: ' + str(id))
		return super(NodeSettings, self).show(self)
