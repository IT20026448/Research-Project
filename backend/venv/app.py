from flask import Flask, request, jsonify
from flask_cors import CORS
import PIL
import numpy as np
import tensorflow as tf
import cv2

app = Flask(__name__)
CORS(app)

# Load your trained model
def load_model():
    # Load the model from the specified file
    model = tf.keras.models.load_model('skin_disease_model.h5')
    return model

@app.route('/predict', methods=['POST'])
def predict():
    try:
        image_file = request.files['image']
        image_data = image_file.read()
        
         # Decode the image using OpenCV
        image_arr = cv2.imdecode(np.frombuffer(image_data, np.uint8), -1)

        # Resize the image to 100x100 pixels
        resized_image = cv2.resize(image_arr, (100, 100))

        # Load the model
        model = load_model()

        # Make prediction using the model
        prediction = model.predict(np.expand_dims(resized_image, axis=0))  # Modify this based on your model

        # Format and send the prediction result
        result = {
            "prediction": prediction.tolist()  # Convert prediction to a list
        }

        return jsonify(result)
    except Exception as e:
        return jsonify({"error": str(e)})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8083)