#!/usr/bin/env python3
"""
Simple dataset downloader using gdown
Just needs the Google Drive folder ID
"""

import gdown
import os
import zipfile

# Your Google Drive folder ID
DRIVE_FOLDER_ID = '1USlDWtOuolq6MT1-CpxHogbThzerSatl'
OUTPUT_DIR = 'dataset'

def download_dataset():
    """Download dataset from Google Drive folder"""
    
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    
    print(f"Downloading dataset from Drive folder: {DRIVE_FOLDER_ID}")
    print(f"Saving to: {OUTPUT_DIR}/")
    
    try:
        # Download entire folder
        gdown.download_folder(
            f'https://drive.google.com/drive/folders/{DRIVE_FOLDER_ID}',
            output=OUTPUT_DIR,
            quiet=False,
            use_cookies=False
        )
        print("\n✓ Download complete!")
        
        # Check if we need to extract zip files
        for file in os.listdir(OUTPUT_DIR):
            if file.endswith('.zip'):
                zip_path = os.path.join(OUTPUT_DIR, file)
                print(f"Extracting {file}...")
                with zipfile.ZipFile(zip_path, 'r') as zip_ref:
                    zip_ref.extractall(OUTPUT_DIR)
                os.remove(zip_path)
                print(f"✓ Extracted {file}")
        
        # Verify structure
        train_dir = os.path.join(OUTPUT_DIR, 'train')
        valid_dir = os.path.join(OUTPUT_DIR, 'valid')
        
        if os.path.exists(train_dir):
            train_classes = os.listdir(train_dir)
            print(f"\n✓ Training data: {len(train_classes)} disease classes")
            for cls in train_classes[:5]:
                count = len(os.listdir(os.path.join(train_dir, cls)))
                print(f"  - {cls}: {count} images")
        
        if os.path.exists(valid_dir):
            valid_classes = os.listdir(valid_dir)
            print(f"✓ Validation data: {len(valid_classes)} disease classes")
        
        return True
        
    except Exception as e:
        print(f"\n✗ Download failed: {e}")
        print("\nTroubleshooting:")
        print("1. Check internet connection")
        print("2. Verify folder ID is correct")
        print("3. Make sure the Google Drive folder is SHARED (public or link-based)")
        print("4. Try manual download: https://drive.google.com/drive/folders/{DRIVE_FOLDER_ID}")
        return False

if __name__ == '__main__':
    success = download_dataset()
    exit(0 if success else 1)
