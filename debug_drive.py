import os
import pickle
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request

SCOPES = ['https://www.googleapis.com/auth/drive.readonly']

def authenticate():
    creds = None
    if os.path.exists("token.pickle"):
        with open("token.pickle", "rb") as f:
            creds = pickle.load(f)

    if not creds or not creds.valid:
        flow = InstalledAppFlow.from_client_secrets_file("credentials.json", SCOPES)
        creds = flow.run_local_server(port=0)
        with open("token.pickle", "wb") as f:
            pickle.dump(creds, f)

    return build("drive", "v3", credentials=creds)

service = authenticate()

FOLDER_ID = "1Cv2x8VJRtU_YCgRwf3itrl7dhqxQ1Kiy"   # current ID

results = service.files().list(
    q=f"'{FOLDER_ID}' in parents",
    fields="files(id, name, mimeType)"
).execute()

print("\nItems inside this Drive folder:\n")

for f in results.get("files", []):
    print(f["name"], " | ", f["mimeType"], " | ", f["id"])
