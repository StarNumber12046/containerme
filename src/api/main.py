from flask import Flask, request
import docker
import random

client = docker.from_env()
app = Flask("")
@app.route("/api/containers", methods=["GET"])
def get_containers():
    cts = client.containers.list()
    print()
    print([ct.attrs.keys() for ct in cts if ct.attrs["Name"].endswith("_containerme")])
    return {"containers": [{"image": ct.attrs["Image"], "Name": ct.attrs["Name"].removeprefix("/"), "ports": ct.attrs["NetworkSettings"]["Ports"]["22/tcp"], "mounts": ct.attrs.get("Mounts", [])} for ct in cts if ct.attrs["Name"].endswith("_containerme")]}

@app.route("/api/containers", methods=["POST"])
def create_container():
    
    data = request.get_json()
    print(data)
    name = data.get("name")
    image = data.get("image")
    if not name or not image:
        return {"success": False, "error": "name and image are required"}, 400
    container = client.containers.run(image+"_containerme", name=f"{name}_containerme",
        ports={"22/tcp": random.randint(10000, 40000)},
        volumes={f"{name}_containerme": {"bind": "/data", "mode": "rw"}},
        detach=True)
    binds = container.attrs["HostConfig"]["PortBindings"]["22/tcp"]
    return {"name": container.attrs["Name"].removeprefix("/"),
            "image": container.attrs["Config"]["Image"],
            "binds": binds,
            "mounts": container.attrs.get("Mounts", [])}

@app.route("/api/containers", methods=["DELETE"])
def remove_container():
    data = request.get_json()
    name = data.get("name")
    if not name:
        return {"error": "name is required"}, 400
    try:
        container = client.containers.get(name)
    except:
        return {"success": False, "error": "container not found"}, 404
    container.stop()
    container.remove()
    return {"success": True}

@app.route("/api/containers", methods=["PATCH"])
def edit_container():
    data = request.args.to_dict()
    json_data = request.get_json()
    if "restart" in data and data["restart"] == "1":
        try:
            container = client.containers.get(json_data["name"])
        except:
            return {"success": False, "error": "container not found"}, 404
        
        container.restart()
        return {"success": True}
    else:
        container = client.containers.get(json_data["name"])
        container.stop()
        container.update(request.get_json())
        container.start()
        return {"success": True}


app.run("0.0.0.0", 3000)
