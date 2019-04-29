# Vengo Tracker

## Table of Contents
- [Summary](https://github.com/demesvardestin/vengo-tracker#summary)
- [Stack](https://github.com/demesvardestin/vengo-tracker#stack)
- [Features](https://github.com/demesvardestin/vengo-tracker#features)
- [Specs](https://github.com/demesvardestin/vengo-tracker#specs)
    - [Main](https://github.com/demesvardestin/vengo-tracker#main)
    - [API](https://github.com/demesvardestin/vengo-tracker#api)
    - [Simulation](https://github.com/demesvardestin/vengo-tracker#simulation)
    - [Tests](https://github.com/demesvardestin/vengo-tracker#tests)
- [To Do](https://github.com/demesvardestin/vengo-tracker#todo)

## Summary
This is a web and api based tracker (simulator) for Vengo machines.

Demo - [VengoTracker](https://vengo-tracker.herokuapp.com "VengoTracker")
![vengotracker](https://github.com/demesvardestin/vengo-tracker/raw/master/public/images/vengo_tracker.png "VengoTracker")

## Stack
- Rails 4.2.8 (Fixnum & Bignum deprecation causes a problem with production deployment when using earlier versions)
- Ruby 2.3.4
- Bootstrap
- jQuery
- Geocoder

## Features
- CRUD - Web
- CRUD - REST API
- Email Alerts
- Purchase Simulator - Web

## Specs

#### Main
These functionalities are all web based. These include creating (installing),
reading (viewing), updating (restocking), and deleting (uninstalling) a machine;
creating (adding), updating (refilling), reading (viewing), and deleting (removing)
products from a machine; creating (installing) a random number of machines, with
a random number of products randomized by name and inventory details.

#### API
Also included is a RESTful JSON API with CRUD endpoints:
```
# MACHINES
#
# retrieve list of machines. returns an array of machine objects
GET /api/machines
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
POST /api/machines
{
    created_at: 2019-04-29T03:17:23.898Z,
    updated_at: 2019-04-29T03:17:23.898Z,
    id: 30,
    operator_id: 1,
    latitude: 40.60000,
    longitude: -74.08089
}

# retrieve a machine
GET /api/machines/:id
{
    created_at: 2019-04-29T03:17:23.898Z,
    updated_at: 2019-04-29T03:17:23.898Z,
    id: 30,
    operator_id: 1,
    latitude: 40.60000,
    longitude: -74.08089
}

# update a machine. returns an empty body
PUT /api/machines/:id

# delete a machine. returns an empty body
DELETE /api/machines/:id

# PRODUCTS
#
# retrieve list of a machine's products. returns an array of product objects
GET /api/machines/:machine_id/products
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
POST /api/machines/:machine_id/products
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
GET /api/machines/:machine_id/products/:id
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
PUT /api/machines/:machine_id/products/:id

# delete a machine's product. returns an empty body
DELETE /api/machines/:machine_id/products/:id
```

#### Simulation
This is a simple interface for simulating purchases and refills of a machine's products.
Includes a short javascript function to asynchronously update the page to reflect the
product's inventory change and status.

#### Tests
Also included is a simple test suite in RSpec for the models and the controllers.
The latter tests focus solely on the API portion, and check all endpoints for
both machine and product. The current suite omits Devise and operator authentication,
and simply tests the working functionality of the endpoints.

## Todo
UI is currently super basic and could use some work, mostly as far as realtime
functionalities (using a framework like React or Vue).
