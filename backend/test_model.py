import os
import numpy as np
import tensorflow as tf
from sklearn.metrics import classification_report, confusion_matrix

# ================= PATHS =================
DATA_DIR = "../dataset"
TEST_DIR = os.path.join(DATA_DIR, "test")
MODEL_PATH = "plant_model.keras"
IMG_SIZE = (224, 224)
BATCH_SIZE = 32

# ================= LOAD MODEL =================
print("Loading trained model...")
model = tf.keras.models.load_model(MODEL_PATH)

# ================= LOAD TEST DATA =================
print("Loading test dataset...")

test_data = tf.keras.preprocessing.image.ImageDataGenerator(
    rescale=1./255
).flow_from_directory(
    TEST_DIR,
    target_size=IMG_SIZE,
    batch_size=BATCH_SIZE,
    class_mode="categorical",
    shuffle=False
)

# ================= EVALUATE =================
print("\nEvaluating on Test Dataset...")
test_loss, test_accuracy = model.evaluate(test_data)

print("Test Loss:", round(test_loss, 4))
print("Test Accuracy:", round(test_accuracy * 100, 2), "%")

# ================= DETAILED METRICS =================
predictions = model.predict(test_data)
y_pred = np.argmax(predictions, axis=1)
y_true = test_data.classes

print("\nClassification Report:")
print(classification_report(y_true, y_pred, target_names=list(test_data.class_indices.keys())))

print("\nConfusion Matrix:")
print(confusion_matrix(y_true, y_pred))