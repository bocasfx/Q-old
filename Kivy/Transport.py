from kivy.uix.anchorlayout import AnchorLayout
from kivy.uix.togglebutton import ToggleButton

class Transport(AnchorLayout):

    btn_play = ''

    def __init__(self, **kwargs):
        super(Transport, self).__init__(**kwargs)

        self.medium = kwargs.get('medium', '')

        self.anchor_x = 'center'
        self.anchor_y = 'top'

        btn_size = "30px"

        self.btn_play = ToggleButton(
            size=(btn_size, btn_size),
            size_hint=(None, None),
            background_normal='images/play.png',
            background_down='images/pause.png',
            border=(0,0,0,0),
            state='down')

        self.add_widget(self.btn_play)

        self.btn_play.bind(on_release=self.medium.toggle_play_status)
        self.padding = 10

    def on_spacebar_pressed(self, *args):
        self.btn_play.state = 'normal' \
            if self.btn_play.state == 'down' else 'down'
        self.medium.toggle_play_status()
