# Vengo Tracker

## Table of Contents
- [Summary](https://github.com/demesvardestin/vengo-tracker#summary)
- [Stack](https://github.com/demesvardestin/vengo-tracker#stack)
- [Features](https://github.com/demesvardestin/vengo-tracker#features)
- [Design]((https://github.com/demesvardestin/vengo-tracker#design))
- [Specs](https://github.com/demesvardestin/vengo-tracker#specs)
    - [Main](https://github.com/demesvardestin/vengo-tracker#main)
    - [API](https://github.com/demesvardestin/vengo-tracker#api)
    - [Tests](https://github.com/demesvardestin/vengo-tracker#tests)
- [To Do](https://github.com/demesvardestin/vengo-tracker#todo)

## Summary
Vengo Tracker is a web and api based tracker (simulator) for Vengo Machines. **Note**:
It doesn't make calls to an actual external API from Vengo Labs itself, but only
simulates a tracker, should there be one.

Demo - [VengoTracker](https://vengo-tracker.herokuapp.com "VengoTracker")
![vengotracker](https://github.com/demesvardestin/vengo-tracker/raw/master/public/images/vengo_tracker.png "VengoTracker")

## Stack
- Rails 4.2.8 (Earlier versions cause a problem with production push due to Fixnum & Bignum deprecation)
- Ruby 2.3.4
- Bootstrap
- jQuery
- Geocoder
- SendGrid
- Puma (production)

## Features
- CRUD - Web
- CRUD - REST API
- Email Alerts
- Purchase Simulator - Web

## Design
The overall app comprises 3 main components:
- The main web app, which the user interacts with
- The simulator, which is just an additional interface to simulate purchases and refills
- The JSON API

Each component has its own namespace, in order to separate concerns. This means
different routes, controllers and views (where needed). If you count Devise, this
would technically constitute a fourth component, since the controller extensions
used are also separated into their own namespace. All controllers from each
namespace inherit from an abstract controller, which itself inherits from
**ActionController::Base**. This prevents repetition where modules like concerns
or other libraries need to be used by multiple controllers in a namespace, or
when an entire namespace needs to be re-configured.

### Web App
This component is what the operator sees on their computer. They can authenticate,
perform CRUD functions on Machines and Products, as well as update their own
account info.

### Simulator
This is technically part of the web app, but it's separated with its own namespace.
It allows the operator to simulate purchases and refills on any product of a given
machine. This component uses a vey minimal amount of jQuery to perform
asynchronous calls to the server and update the view to reflect the changes.

### JSON API
The RESTful JSON API, designed minimalistically. The current authentication
is a simple check against the Operator's **secret_token**, which they supply on
each call. Since this can get super repetitive, it certainly is not a preferred
method for production. Something like [JWT](https://jwt.io/) would be better suited.
More details [below](https://github.com/demesvardestin/vengo-tracker#api).

## Specs

#### Main
These functionalities are all web based. These include creating (installing),
reading (viewing), updating (restocking), and deleting (uninstalling) a machine;
creating (adding), updating (refilling), reading (viewing), and deleting (removing)
products from a machine; creating (installing) a random number of machines, with
a random number of products randomized by name and inventory details.

#### API
Also included is a RESTful JSON API with CRUD endpoints. The base url is 
https://vengo-tracker.herokuapp.com. All requests should include a **secret_token**
parameter to validate and authenticate the operator. For example:

``` console
foo@bar:~$ curl -X GET "https://vengo-tracker.herokuapp.com/api/machines/30?secret_token=your_secret_token"
{
    created_at: 2019-04-29T03:17:23.898Z,
    updated_at: 2019-04-29T03:17:23.898Z,
    id: 30,
    operator_id: 1,
    latitude: 40.60000,
    longitude: -74.08089
}

```

``` sh
# Endpoints
#
# MACHINES
# retrieve list of machines. returns an array of machine objects
# GET /api/machines
[
    {
        created_at: 2019-04-29T03:17:23.898Z,
        updated_at: 2019-04-29T03:17:23.898Z,
        id: 30,
        operator_id: 1,
        latitude: 40.60000,
        longitude: -74.08089
    },
    {
        ...
    }
]

# create a new machine. returns the created object
# POST /api/machines
{
    created_at: 2019-04-29T03:17:23.898Z,
    updated_at: 2019-04-29T03:17:23.898Z,
    id: 30,
    operator_id: 1,
    latitude: 40.60000,
    longitude: -74.08089
}

# retrieve a machine
# GET /api/machines/:id
{
    created_at: 2019-04-29T03:17:23.898Z,
    updated_at: 2019-04-29T03:17:23.898Z,
    id: 30,
    operator_id: 1,
    latitude: 40.60000,
    longitude: -74.08089
}

# update a machine. returns an empty body
# PUT /api/machines/:id

# delete a machine. returns an empty body
# DELETE /api/machines/:id

# PRODUCTS
#
# retrieve list of a machine's products. returns an array of product objects
# GET /api/machines/:machine_id/products
[
    {
        id: 172,
        name: "Snacks",
        machine_id: 29,
        max_inventory_count: 15,
        current_inventory_count: 15,
        threshold: 8,
        inventory_status: "Stocked",
        created_at: 2019-04-29T03:17:23.898Z,
        updated_at: 2019-04-29T03:17:23.898Z
    },
    {
        ...
    }
]

# add new product to a machine. returns the created object
# POST /api/machines/:machine_id/products
{
    id: 172,
    name: "Snacks",
    machine_id: 29,
    max_inventory_count: 15,
    current_inventory_count: 15,
    threshold: 8,
    inventory_status: "Stocked",
    created_at: 2019-04-29T03:17:23.898Z,
    updated_at: 2019-04-29T03:17:23.898Z
}

# retrieve a machine's product
# GET /api/machines/:machine_id/products/:id
{
    id: 172,
    name: "Snacks",
    machine_id: 29,
    max_inventory_count: 15,
    current_inventory_count: 15,
    threshold: 8,
    inventory_status: "Stocked",
    created_at: 2019-04-29T03:17:23.898Z,
    updated_at: 2019-04-29T03:17:23.898Z
}

# update a machine's product. returns an empty body
# PUT /api/machines/:machine_id/products/:id

# delete a machine's product. returns an empty body
# DELETE /api/machines/:machine_id/products/:id
```

#### Tests
Also included is a simple test suite in RSpec for the models and the controllers.
The latter tests focus solely on the API portion, and check all endpoints for
both machine and product. The current suite omits Devise and operator authentication,
and simply tests the working functionality of the endpoints.

## Todo
UI is currently super basic and could use some work, mostly as far as realtime
functionalities (using a framework like React or Vue). Secondly, for the API, a more
robust authentication system should be implemented for production commits, such
as with [JSON Web Token](https://jwt.io/).
