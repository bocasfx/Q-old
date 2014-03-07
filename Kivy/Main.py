from kivy.app import App
from Medium import Medium
from Transport import Transport
from kivy.uix.floatlayout import FloatLayout
from ToolsPanel import ToolsPanel
from MainSettings import MainSettings
from kivy.core.window import Window
from kivy.logger import Logger

class QApp(App):

    def __init__(self, **kwargs):
        super(QApp, self).__init__(**kwargs)

        # Initialize keyboard handler.
        self._keyboard = Window.request_keyboard(self._keyboard_closed, self)
        self._keyboard.bind(on_key_down=self._on_keyboard_down)

    def _keyboard_closed(self):
        self._keyboard.unbind(on_key_down=self._on_keyboard_down)
        self._keyboard

    # Keyboard handler
    def _on_keyboard_down(self, keyboard, keycode, text, modifiers):
        Logger.debug('Key pressed: ' + str(keycode))
        if keycode[1] == 'spacebar':
            self.transport.on_spacebar_pressed()
        elif keycode[1] == 'k':
            self.medium.clear()
        elif keycode[1] == 's':
            self.mainSettings.toggle()
        elif keycode[1] == 't':
            self.toggle_panel(self.tools_panel)
        elif keycode[1] == 'p':
            self.toggle_panel(self.transport)
        return True

    def toggle_panel(self, panel):
        if panel.visibility == 'hidden':
            self.main_layout.add_widget(panel)
            panel.visibility = 'visible'
        else:
            self.main_layout.remove_widget(panel)
            panel.visibility = 'hidden'

    def build(self):
        self.mainSettings = MainSettings()
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
