# Stellar Core Docker image

## Docker Hub

The Docker images are automatically built and published at [starformlabs/stellar-core](https://hub.docker.com/r/starformlabs/stellar-core/).

## Credit

This repo was originally forked from [satoshipay/docker-stellar-core](https://github.com/satoshipay/docker-stellar-core). 
The following are the primary changes.

 - Use debian:stretch-slim for the base image
 - Install from binaries instead of source
 - Add a check to makes sure that postgres is up before starting

## Configuration

The container can be fully configured via environment variables.

### Environment variables

All Stellar Core config options can be set via environment variables. Here we list the
ones you probably want to set:

* `NETWORK_PASSPHRASE`: default is `Public Global Stellar Network ; September 2015` which
  is the public production network; use `Test SDF Network ; September 2015` for the testnet.

* `DATABASE`: default is `sqlite3://stellar.db` which you should definitely change for production,
   e.g., `postgresql://dbname=stellar user=postgres host=postgres`.

* `KNOWN_PEERS`: comma-separated list of peers (`ip:port`) to connect to when
   below *TARGET_PEER_CONNECTIONS*, e.g.,
   `core-testnet1.stellar.org,core-testnet2.stellar.org,core-testnet3.stellar.org`.

* `HISTORY`: JSON of the following form:
   ```
   {
     "h1": { "get": "curl -sf https://s3-eu-west-1.amazonaws.com/history.stellar.org/prd/core-testnet/core_testnet_001/{0} -o {1}" },
     "h2": { "get": "curl -sf https://s3-eu-west-1.amazonaws.com/history.stellar.org/prd/core-testnet/core_testnet_002/{0} -o {1}" },
     "h3": { "get": "curl -sf https://s3-eu-west-1.amazonaws.com/history.stellar.org/prd/core-testnet/core_testnet_003/{0} -o {1}" }
   }
   ```

* `QUORUM_SET`: JSON of the following form:
   ```
   [
     {
       "threshold_percent": 51,
       "validators": ["GDKXE2OZMJIPOSLNA6N6F2BVCI3O777I2OOC4BV7VOYUEHYX7RTRYA7Y  sdf1",
                      "GCUCJTIYXSOXKBSNFGNFWW5MUQ54HKRPGJUTQFJ5RQXZXNOLNXYDHRAP  sdf2",
                      "GC2V2EFSXN6SQTWVYA5EPJPBWWIMSD2XQNKUOHGEKB535AQE2I6IXV2Z  sdf3"]
     },
     {
       "path": "1",
       "threshold_percent": 67,
       "validators": [
         "$self",
         "GDXJAZZJ3H5MJGR6PDQX3JHRREAVYNCVM7FJYGLZJKEHQV2ZXEUO5SX2 some_name"
       ]
     }
   ]
   ```
