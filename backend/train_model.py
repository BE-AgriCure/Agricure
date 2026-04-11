#import gdown
import os
import shutil
import tensorflow as tf
from tensorflow.keras.applications import MobileNetV2
from tensorflow.keras.layers import Dense, GlobalAveragePooling2D
from tensorflow.keras.models import Model
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.callbacks import ModelCheckpoint
from sklearn.metrics import classification_report, confusion_matrix
from tensorflow.keras.callbacks import ModelCheckpoint, EarlyStopping, ReduceLROnPlateau
import matplotlib.pyplot as plt
import numpy as np
import json
from PIL import Image
import io

# Config
  # Replace with your public Drive folder ID

# commented the code of downloading once dataset downloaded
# Step 1: Fetch dataset from Drive (assumes zipped train/valid or direct folders; unzip if needed)
#    os.makedirs(DATA_DIR, exist_ok=True)
#    os.makedirs(OUTPUT_DIR, exist_ok=True)

 #   try:
  #     gdown.download_folder(
  #         output=DATA_DIR,
   #         quiet=False
    #    )
    #   print("Dataset downloaded!")
   # except Exception as e:
    #    print(f"Dataset download error: {e}")
     #   print("Please ensure DRIVE_FOLDER_ID is correct and folder is public.")
      #  print("\nTo fix:")
       # print("1. Share your Google Drive folder (right-click > Share > Anyone with link)")
       # print("2. Get the folder ID from the URL: https://drive.google.com/drive/folders/{FOLDER_ID}")
       # print(f"3. Replace DRIVE_FOLDER_ID = '{DRIVE_FOLDER_ID}' in this script")
       # exit(1)

    # Check if dataset was downloaded
# ===================== CONFIG =====================

DATA_DIR = "../dataset"
TRAIN_DIR = os.path.join(DATA_DIR, "train")
VAL_DIR   = os.path.join(DATA_DIR, "valid")

IMG_SIZE = (224, 224)
BATCH_SIZE = 32
TOTAL_EPOCHS = 50
FINE_TUNE_EPOCHS = 10

OUTPUT_DIR = "../flutter_app/assets/"
MODEL_PATH = "plant_model.keras"

os.makedirs(OUTPUT_DIR, exist_ok=True)

# ===================== DATA =====================

train_gen = tf.keras.preprocessing.image.ImageDataGenerator(
    rescale=1./255,
    rotation_range=20,
    width_shift_range=0.2,
    height_shift_range=0.2,
    horizontal_flip=True
)

train_data = train_gen.flow_from_directory(
    TRAIN_DIR,
    target_size=IMG_SIZE,
    batch_size=BATCH_SIZE,
    class_mode="categorical"
)

val_data = tf.keras.preprocessing.image.ImageDataGenerator(
    rescale=1./255
).flow_from_directory(
    VAL_DIR,
    target_size=IMG_SIZE,
    batch_size=BATCH_SIZE,
    class_mode="categorical"
)

num_classes = train_data.num_classes
labels = list(train_data.class_indices.keys())
print("Classes:", labels)

# ===================== MODEL =====================

if os.path.exists(MODEL_PATH):
    print("Loading existing model...")
    model = tf.keras.models.load_model(MODEL_PATH)
else:
    print("Creating new model...")
    base_model = MobileNetV2(
        weights="imagenet",
        include_top=False,
        input_shape=(224, 224, 3)
    )
    base_model.trainable = False

    x = base_model.output
    x = GlobalAveragePooling2D()(x)
    x = Dense(128, activation="relu")(x)
    outputs = Dense(num_classes, activation="softmax")(x)

    model = Model(inputs=base_model.input, outputs=outputs)

model.compile(
    optimizer=Adam(learning_rate=1e-3),
    loss="categorical_crossentropy",
    metrics=["accuracy"]
)

# ===================== CALLBACKS =====================

checkpoint = ModelCheckpoint(
    MODEL_PATH,
    monitor="val_accuracy",
    save_best_only=False,
    verbose=1
)

early_stop = EarlyStopping(
    monitor="val_accuracy",
    patience=6,
    restore_best_weights=True,
    verbose=1
)

reduce_lr = ReduceLROnPlateau(
    monitor="val_loss",
    factor=0.3,
    patience=3,
    min_lr=1e-6,
    verbose=1
)

callbacks = [checkpoint, early_stop, reduce_lr]

# ===================== TRAIN =====================

print("Training model...")
history = model.fit(
    train_data,
    epochs=TOTAL_EPOCHS,
    validation_data=val_data,
    callbacks=callbacks
)

# ===================== FINE TUNING =====================

print("Fine-tuning model...")
model.layers[0].trainable = True

model.compile(
    optimizer=Adam(learning_rate=1e-4),
    loss="categorical_crossentropy",
    metrics=["accuracy"]
)

history_fine = model.fit(
    train_data,
    epochs=FINE_TUNE_EPOCHS,
    validation_data=val_data,
    callbacks=callbacks
)

# ===================== GRAPHS =====================

acc = history.history["accuracy"] + history_fine.history["accuracy"]
val_acc = history.history["val_accuracy"] + history_fine.history["val_accuracy"]

loss = history.history["loss"] + history_fine.history["loss"]
val_loss = history.history["val_loss"] + history_fine.history["val_loss"]

plt.figure(figsize=(8,5))
plt.plot(acc, label="Training Accuracy")
plt.plot(val_acc, label="Validation Accuracy")
plt.xlabel("Epoch")
plt.ylabel("Accuracy")
plt.title("Training vs Validation Accuracy")
plt.legend()
plt.grid(True)
plt.savefig(os.path.join(OUTPUT_DIR, "final_accuracy.png"))
plt.close()

plt.figure(figsize=(8,5))
plt.plot(loss, label="Training Loss")
plt.plot(val_loss, label="Validation Loss")
plt.xlabel("Epoch")
plt.ylabel("Loss")
plt.title("Training vs Validation Loss")
plt.legend()
plt.grid(True)
plt.savefig(os.path.join(OUTPUT_DIR, "final_loss.png"))
plt.close()

# ===================== SAVE FOR FLUTTER =====================

converter = tf.lite.TFLiteConverter.from_keras_model(model)
converter.optimizations = [tf.lite.Optimize.DEFAULT]
tflite_model = converter.convert()

with open(os.path.join(OUTPUT_DIR, "model.tflite"), "wb") as f:
    f.write(tflite_model)

with open(os.path.join(OUTPUT_DIR, "labels.txt"), "w") as f:
    f.write("\n".join(labels))

remedies = {label: f"Apply appropriate treatment for {label}" for label in labels}
with open(os.path.join(OUTPUT_DIR, "remedies.json"), "w") as f:
    json.dump(remedies, f, indent=2)

print("Training completed and Flutter files generated")