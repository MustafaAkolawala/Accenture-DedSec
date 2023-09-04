import nltk
from nltk.stem.lancaster import LancasterStemmer
import numpy as np
import tensorflow
from tensorflow import keras
from keras.models import Sequential , load_model
from keras.layers import Dense
import random
import json
import pickle

stemmer = LancasterStemmer()

with open("intent.json") as file:
    data = json.load(file)

def develop_model(input_size,output_size):
    model = Sequential([
        Dense(8, input_shape=(input_size,), activation='relu'),
        Dense(8, activation='relu'),
        Dense(8, activation='relu'),
        Dense((output_size), activation='softmax')
    ])

    model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])

    return model

def bag_of_words(query, words):
    bag = [0 for _ in range(len(words))]

    s_words = nltk.word_tokenize(query)
    s_words = [stemmer.stem(word.lower()) for word in s_words if word != '?']

    for i in s_words:
        if i in words:
            bag[words.index(i)] = 1

    return bag  

def chat():
    print("Start talking with the bot (type quit to stop)!")
    while True:
        inp = input("You: ")
        if inp.lower() == "quit":
            break
        if use_pre_trained_model and pre_trained_model:
            results = pre_trained_model.predict([bag_of_words(inp, words)])
        else:    
            results = model.predict([bag_of_words(inp, words)])

        results_index = np.argmax(results)
        tag = labels[results_index]
        
        for tg in data["intents"]:
            if tg['tag'] == tag:
                responses = tg['responses']

        print(random.choice(responses))

pre_trained_model = None
use_pre_trained_model = False

try:
    with open("data.pickle", "rb") as f:
        words, labels, training, output = pickle.load(f)

    try:
        pre_trained_model = load_model('model_keras.h5')
        use_pre_trained_model = True

    except FileNotFoundError:
        pass

except FileNotFoundError:
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

    words = [stemmer.stem(w.lower()) for w in words if w != "?"]
    words = sorted(list(set(words)))

    labels = sorted(labels)

    training = []
    output = []

    out_empty = [0 for _ in range(len(labels))]

    for x, doc in enumerate(docs_x):
        bag = []

        wrds = [stemmer.stem(w.lower()) for w in doc]

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

    model = develop_model(input_size,output_size)
    model.fit(training, output, epochs=1000, batch_size=8, verbose=1) 
    model.save("model_keras.h5")

chat()