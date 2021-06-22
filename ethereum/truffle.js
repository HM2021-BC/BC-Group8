/*
 * NB: since truffle-hdwallet-provider 0.0.5 you must wrap HDWallet providers in a 
 * function when declaring them. Failure to do so will cause commands to hang. ex:
 * ```
 * mainnet: {
 *     provider: function() { 
 *       return new HDWalletProvider(mnemonic, 'https://mainnet.infura.io/<infura-key>') 
 *     },
 *     network_id: '1',
 *     gas: 4500000,
 *     gasPrice: 10000000000,
 *   },
 */


const HDWalletProvider = require("@truffle/hdwallet-provider");

const gasPrice = 1000000000; //process.env.GASPRICE;
let privateKeys = ["90f8e2e2fe4473f2859d00da9936fd739b070cd59165b1f9cf1e9aa96fe57a31"];
const network = "http://bops.morpheuslabs.io:21523";
//const chainId = 1871;
const chainId = 660;

module.exports = {
  compilers: {
    solc: {
      //version: "0.5.8",
      settings: {
        optimizer: {
          enabled: true,
          runs: 200
        },
        //evmVersion: 'petersburg'
      },
    },
  },
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
    // network for unit testing
    development: {
      host: '127.0.0.1',
      port: 7545,
      network_id: '*',
      gas: 5000000,
    },
    private_poa: { 

      provider: function () {
        return new HDWalletProvider(
            {
                privateKeys: privateKeys,
                providerOrUrl: network,
                chainId: chainId
            }
        )
    },
      network_id: "*",
      gas: 6000000,
      gasPrice: gasPrice
    }
  }
};
