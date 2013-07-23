import logging
import logging.config
import App


def main():
    """ Main entry to the application """

    logging.config.fileConfig('logger.conf')
    my_app = App.App(size=(1000, 700), bg_colour=(50, 50, 50))
    my_app.loop()

if __name__ == '__main__':
    main()
