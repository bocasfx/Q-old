from kivy.app import App
from Medium import Medium
from Transport import Transport
from kivy.uix.floatlayout import FloatLayout
from ToolsPanel import ToolsPanel

class QApp(App):

    def __init__(self, **kwargs):
        super(QApp, self).__init__(**kwargs)

    def build(self):
        self.medium = Medium(do_translation=False)
        self.tools_panel = ToolsPanel(medium=self.medium)
        self.tools_panel.visibility = 'visible'
        self.transport = Transport(medium=self.medium)
        self.transport.visibility = 'visible'
        self.main_layout = FloatLayout()
        self.main_layout.add_widget(self.medium, 999)
        self.main_layout.add_widget(self.tools_panel, 0)
        self.main_layout.add_widget(self.transport, 0)
        return self.main_layout

if __name__ == '__main__':
    QApp().run()
