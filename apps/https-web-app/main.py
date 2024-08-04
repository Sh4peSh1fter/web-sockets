from fastapi import FastAPI
import uvicorn
import os

app = FastAPI()

@app.get("/")
async def read_root():
    return {"message": "this is an https web app (using fastapi)"}

if __name__ == '__main__':
    uvicorn.run('main:app', host='0.0.0.0', port=int(os.environ.get('PORT')), ssl_keyfile='/etc/ssl/certs/server.key', ssl_certfile='/etc/ssl/certs/server.crt')