import os
import io
from googleapiclient.discovery import build
from googleapiclient.http import MediaIoBaseDownload
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
import pickle

SCOPES = ["https://www.googleapis.com/auth/drive.readonly"]

DRIVE_FOLDER_ID = "1iiFACz1aa0sI9BoBV-EDDN4V6W9JW6N3"
LOCAL_ROOT = "dataset"

def authenticate():
    creds = None
    if os.path.exists("token.pickle"):
        with open("token.pickle", "rb") as f:
            creds = pickle.load(f)

    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file("credentials.json", SCOPES)
            creds = flow.run_local_server(port=0)

        with open("token.pickle", "wb") as f:
            pickle.dump(creds, f)

    return build("drive", "v3", credentials=creds)

def download_file(service, file_id, path):
    request = service.files().get_media(fileId=file_id)
    fh = io.FileIO(path, "wb")
    downloader = MediaIoBaseDownload(fh, request)

    done = False
    while not done:
        status, done = downloader.next_chunk()

def walk_and_download(service, folder_id, local_path):
    os.makedirs(local_path, exist_ok=True)

    results = service.files().list(
        q=f"'{folder_id}' in parents and trashed=false",
        fields="files(id, name, mimeType)"
    ).execute()

    items = results.get("files", [])

    for item in items:
        name = item["name"]
        file_id = item["id"]
        mime = item["mimeType"]

        if mime == "application/vnd.google-apps.folder":
            walk_and_download(service, file_id, os.path.join(local_path, name))
        else:
            file_path = os.path.join(local_path, name)
            print("Downloading:", file_path)
            download_file(service, file_id, file_path)

def main():
    service = authenticate()
    print("Connected to Google Drive")
    walk_and_download(service, DRIVE_FOLDER_ID, LOCAL_ROOT)
    print("Download complete")

if __name__ == "__main__":
    main()
import os
import io
from googleapiclient.discovery import build
from googleapiclient.http import MediaIoBaseDownload
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
import pickle

SCOPES = ["https://www.googleapis.com/auth/drive.readonly"]

DRIVE_FOLDER_ID = "1YfAJBokyTIsqNv8DoOjYtcflL6uZJGW"
LOCAL_ROOT = "dataset"

def authenticate():
    creds = None
    if os.path.exists("token.pickle"):
        with open("token.pickle", "rb") as f:
            creds = pickle.load(f)

    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file("credentials.json", SCOPES)
            creds = flow.run_local_server(port=0)

        with open("token.pickle", "wb") as f:
            pickle.dump(creds, f)

    return build("drive", "v3", credentials=creds)

def download_file(service, file_id, path):
    request = service.files().get_media(fileId=file_id)
    fh = io.FileIO(path, "wb")
    downloader = MediaIoBaseDownload(fh, request)

    done = False
    while not done:
        status, done = downloader.next_chunk()

def walk_and_download(service, folder_id, local_path):
    os.makedirs(local_path, exist_ok=True)

    results = service.files().list(
        q=f"'{folder_id}' in parents and trashed=false",
        fields="files(id, name, mimeType)"
    ).execute()

    items = results.get("files", [])

    for item in items:
        name = item["name"]
        file_id = item["id"]
        mime = item["mimeType"]

        if mime == "application/vnd.google-apps.folder":
            walk_and_download(service, file_id, os.path.join(local_path, name))
        else:
            file_path = os.path.join(local_path, name)
            print("Downloading:", file_path)
            download_file(service, file_id, file_path)

def main():
    service = authenticate()
    print("Connected to Google Drive")
    walk_and_download(service, DRIVE_FOLDER_ID, LOCAL_ROOT)
    print("Download complete")

if __name__ == "__main__":
    main()
import os
import io
from googleapiclient.discovery import build
from googleapiclient.http import MediaIoBaseDownload
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
import pickle

SCOPES = ["https://www.googleapis.com/auth/drive.readonly"]

DRIVE_FOLDER_ID = "1YfAJBokyTIsqNv8DoOjYtcflL6uZJGW"
LOCAL_ROOT = "dataset"

def authenticate():
    creds = None
    if os.path.exists("token.pickle"):
        with open("token.pickle", "rb") as f:
            creds = pickle.load(f)

    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file("credentials.json", SCOPES)
            creds = flow.run_local_server(port=0)

        with open("token.pickle", "wb") as f:
            pickle.dump(creds, f)

    return build("drive", "v3", credentials=creds)

def download_file(service, file_id, path):
    request = service.files().get_media(fileId=file_id)
    fh = io.FileIO(path, "wb")
    downloader = MediaIoBaseDownload(fh, request)

    done = False
    while not done:
        status, done = downloader.next_chunk()

def walk_and_download(service, folder_id, local_path):
    os.makedirs(local_path, exist_ok=True)

    results = service.files().list(
        q=f"'{folder_id}' in parents and trashed=false",
        fields="files(id, name, mimeType)"
    ).execute()

    items = results.get("files", [])

    for item in items:
        name = item["name"]
        file_id = item["id"]
        mime = item["mimeType"]

        if mime == "application/vnd.google-apps.folder":
            walk_and_download(service, file_id, os.path.join(local_path, name))
        else:
            file_path = os.path.join(local_path, name)
            print("Downloading:", file_path)
            download_file(service, file_id, file_path)

def main():
    service = authenticate()
    print("Connected to Google Drive")
    walk_and_download(service, DRIVE_FOLDER_ID, LOCAL_ROOT)
    print("Download complete")

if __name__ == "__main__":
    main()
import os
import io
from googleapiclient.discovery import build
from googleapiclient.http import MediaIoBaseDownload
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
import pickle

SCOPES = ["https://www.googleapis.com/auth/drive.readonly"]

DRIVE_FOLDER_ID = "1YfAJBokyTIsqNv8DoOjYtcflL6uZJGW"
LOCAL_ROOT = "dataset"

def authenticate():
    creds = None
    if os.path.exists("token.pickle"):
        with open("token.pickle", "rb") as f:
            creds = pickle.load(f)

    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file("credentials.json", SCOPES)
            creds = flow.run_local_server(port=0)

        with open("token.pickle", "wb") as f:
            pickle.dump(creds, f)

    return build("drive", "v3", credentials=creds)

def download_file(service, file_id, path):
    request = service.files().get_media(fileId=file_id)
    fh = io.FileIO(path, "wb")
    downloader = MediaIoBaseDownload(fh, request)

    done = False
    while not done:
        status, done = downloader.next_chunk()

def walk_and_download(service, folder_id, local_path):
    os.makedirs(local_path, exist_ok=True)

    results = service.files().list(
        q=f"'{folder_id}' in parents and trashed=false",
        fields="files(id, name, mimeType)"
    ).execute()

    items = results.get("files", [])

    for item in items:
        name = item["name"]
        file_id = item["id"]
        mime = item["mimeType"]

        if mime == "application/vnd.google-apps.folder":
            walk_and_download(service, file_id, os.path.join(local_path, name))
        else:
            file_path = os.path.join(local_path, name)
            print("Downloading:", file_path)
            download_file(service, file_id, file_path)

def main():
    service = authenticate()
    print("Connected to Google Drive")
    walk_and_download(service, DRIVE_FOLDER_ID, LOCAL_ROOT)
    print("Download complete")

if __name__ == "__main__":
    main()
