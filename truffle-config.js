module.exports = {
  networks: {
    development: {
      host: "192.168.1.88",
      port: 7545,
      network_id: '*',
    },
  },
  contracts_directory: './contracts',
  compilers: {
    solc: {
      version: '0.8.19',
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },

  db: {
    enabled: false,
  },
};
