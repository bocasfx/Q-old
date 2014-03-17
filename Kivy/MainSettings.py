from Settings import Settings

class MainSettings(Settings):

	def __init__(self, **kwargs):
		# super(MainSettings, self).__init__(**kwargs)
		pass

	def show(self, node):
		return super(MainSettings, self).show(self)