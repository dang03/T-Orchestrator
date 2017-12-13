TODO:
Wikipage for each default microservice?
* Logger
 -> Receive the logger from each microservice

* Security
 -> Auth/AuthZ
    -> finalise tests

* Monitoring
  -> Service is up? Check the port if is listening
    -> Time to check services? Timer (Sleep)?
    -> Generate an alert
  -> Synthetic monitoring

* Logging
  -> Receive all the logs from all the services
  
  
---
* Page to register microservices
    -> Allows to register new microservices
    -> Show alerts/errors in each microservice
    -> Integrate with the Mngt UI

*When a microservice is blocked/dead/error..., orchestrator should conitune running!
    -> Microservices continues working but in background

### Installation

```sh
bundle install
```

### Run Server

With the default microservices (auth, logg, monitoring...):

```sh
foreman start
```

Only the orchestrator (allows to register services and also contains the proxy to each registred microservice):

```sh
rake start
```

Register a service:
POST '/registerService' with the following content:

    {
        "service_name" => "servivceName",
        "service_host" => "IP",
        "service_port" => "Port"
    }