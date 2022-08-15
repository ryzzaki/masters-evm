## Quick Start

```bash
# create the .env file
touch .env

# copy the variables
cat .env.example > .env
```

Fill out the variables with your own information.

```bash
# install all the dependencies
yarn install
```

To deploy the smart contracts, run the following commands in order:

```bash
# clean out the repository just to be sure
yarn clean

# merge the contracts
yarn merge

# cleanse the duplicated SPDX licenses
yarn cleanse

# deploy all the contracts to TESTNET
yarn start:dev
```

To update each of the contracts:

```bash
# upgrade the BEE token
yarn upgrade:bee

# upgrade the HIVE token
yarn upgrade:hive

# upgrade the MANAGER contract
yarn upgrade:manager
```
