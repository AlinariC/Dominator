# DominatorRelay

DominatorRelay is a small Flask API that collects check-in data from Dominator agents.

## Endpoints

- `POST /checkin` – send a JSON payload containing at least a `device_id` field. The request
  must include the header `Authorization: Bearer <token>`.
- `GET /devices` – returns all saved check-in payloads as JSON. Requires the same token header.

Set the environment variable `API_TOKEN` to define the expected token. If not set,
`changeme` is used.

## Running Locally

```bash
# create virtual environment and install dependencies
./install.sh

# set the API token
export API_TOKEN=mysecrettoken

# start the development server
source venv/bin/activate
python app.py
```

The server listens on `http://0.0.0.0:5000`.

## Running with Gunicorn

```bash
source venv/bin/activate
export API_TOKEN=mysecrettoken

# start gunicorn with 4 workers
gunicorn -w 4 -b 0.0.0.0:8000 app:app
```
