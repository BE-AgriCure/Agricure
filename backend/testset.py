
#import gdown
#import os

#FOLDER_ID = "1oui9RrQljYrHb1YHn-TiRzIpnODGgw75"

#os.makedirs("../dataset", exist_ok=True)

#gdown.download_folder(
#    id=FOLDER_ID,
#    output="../dataset",
#    quiet=False
#)

import os
import shutil

SOURCE_DIR = "../dataset"   # where images are now
TEST_DIR = "../dataset/test"

os.makedirs(TEST_DIR, exist_ok=True)

# Get class names from train folder
train_classes = os.listdir("../dataset/train")

for class_name in train_classes:
   os.makedirs(os.path.join(TEST_DIR, class_name), exist_ok=True)

# Move images
for file in os.listdir(SOURCE_DIR):
    if file.endswith(".JPG") or file.endswith(".jpg"):
        for class_name in train_classes:
            if file.startswith(class_name):
                shutil.move(
                   os.path.join(SOURCE_DIR, file),
                   os.path.join(TEST_DIR, class_name, file)
               )
            break
