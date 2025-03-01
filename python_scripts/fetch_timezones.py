import firebase_admin # type: ignore
from firebase_admin import credentials, firestore # type: ignore
import requests # type: ignore
import os
import re

# Get the current script's directory
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

# Initialize Firebase
cred = credentials.Certificate(os.path.join(BASE_DIR, "config", "serviceAccountKey.json"))
firebase_admin.initialize_app(cred)
db = firestore.client()

def sanitize_document_id(doc_id):
    """Replace invalid Firestore characters with underscores."""
    return re.sub(r'[^a-zA-Z0-9_-]', '_', doc_id)

# Function to fetch available timezones
def fetch_timezones():
    url = "https://timeapi.io/api/timezone/availabletimezones"
    response = requests.get(url)
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Error fetching timezones: {response.status_code}")
        return None

# Function to fetch timezone details
def fetch_timezone_details(timezone):
    encoded_timezone = requests.utils.quote(timezone)
    url = f"https://timeapi.io/api/timezone/zone?timeZone={encoded_timezone}"
    response = requests.get(url)
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Error fetching details for {timezone}: {response.status_code}")
        return None

# Store timezones in Firestore
def store_timezones():
    timezones = fetch_timezones()
    if not timezones:
        print("No timezones retrieved.")
        return

    batch = db.batch()
    for timezone in timezones:
        details = fetch_timezone_details(timezone)
        if details:
            doc_ref = db.collection("timezones").document(sanitize_document_id(timezone))
            offset_seconds = details['standardUtcOffset']['seconds']
            hours = offset_seconds // 3600
            minutes = (offset_seconds % 3600) // 60
            offset_formatted = f"{'+' if offset_seconds >= 0 else '-'}{abs(hours):02}:{abs(minutes):02}"
            data = {
                "location": details["timeZone"],
                "label": f"{details["timeZone"]}, (UTC{offset_formatted})",
                "offset_hours": offset_formatted
            }
            batch.set(doc_ref, data)

    batch.commit()
    print("✅ Timezones successfully stored in Firestore.")

# Run the script
if __name__ == "__main__":
    store_timezones()
