import asyncio
import websockets
import ssl

async def echo(websocket):
    async for message in websocket:
        await websocket.send(message)

ssl_context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
ssl_context.load_cert_chain(certfile='/etc/ssl/certs/server.crt', keyfile='/etc/ssl/certs/server.key')

start_server = websockets.serve(echo, '0.0.0.0', 4001, ssl=ssl_context)

asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()