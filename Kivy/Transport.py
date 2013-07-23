from kivy.uix.anchorlayout import AnchorLayout
from kivy.uix.togglebutton import ToggleButton

class Transport(AnchorLayout):

    btn_play = ''

    def __init__(self, **kwargs):
        super(Transport, self).__init__(**kwargs)

        self.medium = kwargs.get('medium', '')

        # self.pos_hint = {'x': 0.5, 'y': 0.5}
        # # self.orientation = 'lr-tb'
        self.anchor_x = 'center'
        self.anchor_y = 'top'

        btn_size = 0.03

        self.btn_play = ToggleButton(
            size_hint=(btn_size, btn_size),
            text='P',
            state='down')

        self.add_widget(self.btn_play)

        self.btn_play.bind(on_release=self.medium.toggle_play_status)

    def on_spacebar_pressed(self, *args):
        self.btn_play.state = 'normal' \
            if self.btn_play.state == 'down' else 'down'
        self.medium.toggle_play_status()
