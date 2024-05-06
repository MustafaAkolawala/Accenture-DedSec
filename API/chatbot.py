from flask import Flask,jsonify,request
from flask_ngrok import run_with_ngrok
from pyngrok import ngrok
import nltk
from nltk.stem import WordNetLemmatizer
import numpy as np
import tensorflow
from tensorflow import keras
from keras.models import Sequential , load_model
from keras.layers import Dense
import random
import json
import pickle
nltk.download('wordnet')

# Initialize the Lancaster Stemmer
lematizer = WordNetLemmatizer()

# Load the intents data from a JSON file
with open("D:\\accenture\\hsfg\\Accenture-DedSec-main\\Accenture-DedSec-main\\chatbot\\intent.json") as file:
    data = json.load(file)

# Define a function to develop the neural network model
def develop_model(input_size,output_size):
    model = Sequential([
        Dense(8, input_shape=(input_size,), activation='relu'),
        Dense(8, activation='relu'),
        Dense(8, activation='relu'),
        Dense((output_size), activation='softmax')
    ])

    model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])

    return model

# Define a function to convert a user query into a bag of words
def bag_of_words(query, words):
    bag = [0 for _ in range(len(words))]

    s_words = nltk.word_tokenize(query)
    s_words = [lematizer.lemmatize(word.lower()) for word in s_words if word != '?']

    for i in s_words:
        if i in words:
            bag[words.index(i)] = 1

    return bag  
app=Flask(__name__)
ngrok.set_auth_token("2VXXXJziTlwWNhoPi1PtnxMLQpN_5wfDvoy8cZ8fdhTkacUHd")

run_with_ngrok(app)
@app.route('/bot',methods=['POST'])
# Define the chat function
def chat():
    print("Start talking with the bot (type quit to stop)!")
    while True:
        inpu = dict(request.form)['query']
        inp = ("You:"+inpu)
        if inp.lower() == "quit":
            break
        if use_pre_trained_model and pre_trained_model:
            results = pre_trained_model.predict([bag_of_words(inp, words)])[0]
        else:    
            results = model.predict([bag_of_words(inp, words)])[0]

        results_index = np.argmax(results)
        tag = labels[results_index]
        
        if results[results_index] > 0.7:
            for tg in data["intents"]:
                if tg['tag'] == tag:
                    responses = tg['responses']
                    print(random.choice(responses))
                    return jsonify({'response':random.choice(responses),'tag':tag})
        else:
             response1= "I apologise but I can't quite get you, could you please repeat your query"
             print(response1)
             return jsonify({'response':response1})             

# Initialize variables for pre-trained model and flag for using it
pre_trained_model = None
use_pre_trained_model = False

# Attempt to load pre-processing data and pre-trained model
try:
    with open("D:\\accenture\\hsfg\\Accenture-DedSec-main\\Accenture-DedSec-main\\chatbot\\data.pickle", "rb") as f:
        words, labels, training, output = pickle.load(f)

    try:
        pre_trained_model = load_model('D:\\accenture\\hsfg\\Accenture-DedSec-main\\Accenture-DedSec-main\\chatbot\\model_keras.h5')
        use_pre_trained_model = True

    except FileNotFoundError:
        pass

except FileNotFoundError:
    # If pre-processing data or pre-trained model not found, perform data processing and training
    words = []
    labels = []
    docs_x = []
    docs_y = []

    for intent in data["intents"]:
        for pattern in intent["patterns"]:
            wrds = nltk.word_tokenize(pattern)
            words.extend(wrds)
            docs_x.append(wrds)
            docs_y.append(intent["tag"])

        if intent["tag"] not in labels:
            labels.append(intent["tag"])

    words = [lematizer.lemmatize(w.lower()) for w in words if w != "?"]
    words = sorted(list(set(words)))

    labels = sorted(labels)

    training = []
    output = []

    out_empty = [0 for _ in range(len(labels))]

    for x, doc in enumerate(docs_x):
        bag = []

        wrds = [lematizer.lemmatize(w.lower()) for w in doc]

        for w in words:
            if w in wrds:
                bag.append(1)
            else:
                bag.append(0)

        output_row = out_empty[:]
        output_row[labels.index(docs_y[x])] = 1

        training.append(bag)
        output.append(output_row)

    training = np.array(training)
    output = np.array(output)

    with open("data.pickle", "wb") as f:
        pickle.dump((words, labels, training, output), f)

    input_size = len(training[0])
    output_size = len(output[0])

    # Create and train the neural network model
    model = develop_model(input_size,output_size)
    model.fit(training, output, epochs=1000, batch_size=8, verbose=1) 
    model.save("model_keras.h5")

# Entry point of the script
if __name__=='__main__':
    app.run()