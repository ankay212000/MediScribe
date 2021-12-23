import os
import re
from app import app
from flask import Flask, request, redirect, jsonify
from werkzeug.utils import secure_filename
from flask_cors import CORS
from speech_rec import convert2text
from symptoms_extract import extract_symptoms

ALLOWED_EXTENSIONS = set(['mp3','aac','wav','flac'])

CORS(app)
def allowed_file(filename):
	return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/file-upload', methods=['POST'])
def upload_file():
	# check if the post request has the file part
	if 'file' not in request.files:
		resp = jsonify({'message' : 'No file part in the request'})
		resp.status_code = 400
		return resp
	file = request.files['file']
	if file.filename == '':
		resp = jsonify({'message' : 'No file selected for uploading'})
		resp.status_code = 400
		return resp
	if file and allowed_file(file.filename):
		filename = secure_filename(file.filename)
		if('lang' in request.form):
			lang = request.form['lang']
		else:
			lang = "en-IN"
        #Saving the file
		file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
		text = convert2text(os.path.join(app.config['UPLOAD_FOLDER'], filename) , lang)
		output = {}
		output["converted_text"] = text
		resp = jsonify(output)
		resp.status_code = 201
		return resp
	else:
		resp = jsonify({'message' : 'Allowed file types are txt, pdf, png, jpg, jpeg, gif'})
		resp.status_code = 400
		return resp

@app.route('/symptom_extraction', methods=['POST'])
def symptom_extraction():
	if 'text' not in request.form:
		resp = jsonify({'message' : 'No text part in the request'})
		resp.status_code = 400
		return resp
	text = request.form['text']
	if text == '':
		resp = jsonify({'message' : 'Empty Text'})
		resp.status_code = 400
		return resp
	if text:
		symptoms = extract_symptoms(text)
		resp = jsonify(symptoms)
		resp.status_code = 201
		return resp
	else:
		resp = jsonify({'message' : 'Unknown error encountered'})
		resp.status_code = 400
		return resp

if __name__ == "__main__":
    app.run()
