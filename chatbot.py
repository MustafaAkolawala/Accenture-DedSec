import nltk
from nltk.stem.lancaster import LancasterStemmer
import numpy as np
import tensorflow
from tensorflow import keras
from keras.models import Sequential
from keras.layers import Dense
import random
import json

stemmer = LancasterStemmer()

with open("intent.json") as file:
    data = json.load(file)

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

model = Sequential([
    Dense(8, input_shape=(len(training[0]),), activation='relu'),
    Dense(8, activation='relu'),
    Dense(8, activation='relu'),
    Dense(len(output[0]), activation='softmax')
])

model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])
model.fit(training, output, epochs=1000, batch_size=8, verbose=1) 
model.save("model_keras.h5")


def generate_response(query, bag_of_words):
    bag = [0 for _ in range(len(bag_of_words))]

    s_words = nltk.word_tokenize(query)
    s_words = [stemmer.stem(word.lower()) for word in s_words if word != '?']

    for i in s_words:
        for j, w in enumerate(bag_of_words):
            if w == i:
                bag[j] = 1
            
    return np.array(bag)

def chat():
    print("Start talking with the bot (type quit to stop)!")
    while True:
        inp = input("You: ")
        if inp.lower() == "quit":
            break

        results = model.predict([generate_response(inp, words)])
        results_index = np.argmax(results)
        tag = labels[results_index]

        for tg in data["intents"]:
            if tg['tag'] == tag:
                responses = tg['responses']

        print(random.choice(responses))
