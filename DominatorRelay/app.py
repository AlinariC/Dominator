from flask import Flask, request, jsonify, abort
import os

app = Flask(__name__)

checkins = {}
API_TOKEN = os.environ.get("API_TOKEN", "changeme")


def require_token():
    auth = request.headers.get("Authorization")
    if not auth or not auth.startswith("Bearer "):
        abort(401)
    token = auth.split(" ", 1)[1]
    if token != API_TOKEN:
        abort(403)


@app.route("/checkin", methods=["POST"])
def checkin():
    require_token()
    if not request.is_json:
        return jsonify({"error": "Invalid JSON"}), 400
    data = request.get_json()
    device_id = data.get("device_id")
    if not device_id:
        return jsonify({"error": "device_id required"}), 400
    checkins[device_id] = data
    return jsonify({"status": "ok"})


@app.route("/devices", methods=["GET"])
def devices():
    require_token()
    return jsonify(checkins)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
