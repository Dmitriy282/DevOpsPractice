from flask import Flask, render_template, request, jsonify
import os, requests, json
import logging
# import requests as req


logging.basicConfig(level=logging.DEBUG)




def create_app():
    app = Flask(__name__)

    @app.route('/')
    def index():
        return render_template('index.html')




    return app



app = create_app()  # Создаем экземпляр приложения

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5555)
