## Introduction

`agn` is a tool for API development, which can generate an API server and its client from a single specification.

You can install it globally with

```
npm install agn -g
```

and then use

```
agn new name0
```

to create the directory named "name0" and a new project inside of it.

## Usage

After entering the directory with `cd name0`, you can run `npm start` to start a development session. This command will:

- create the packages at './dist/server' and './dist/client';
- watch for changes to the sources and update the packages continuously;
- run the API server at 8080 port on all available network interfaces;
- restart the API server when it gets updated;

In your frontend project(a project where you would like to use the API), you can install the client package with `npm i /path/to/name0/dist/client`, and then use it as follows:

```
{ getNumber } = require 'name0.client'
```

Each API function exported by the client returns a Promise and can be used with `await`:

```
number = await getNumber()
```

## Development

To work on `agn` itself, run `npm run dev` in this repository.

To run the tests:

```
npm run test
```
